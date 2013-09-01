import Graphics.UI.WX
import Graphics.UI.WX.Controls
import Graphics.UI.WXCore
import Graphics.UI.WXCore.Events
import Debug.Trace
import Data.String.Utils
import System.FilePath
import Control.Exception
import Data.Functor

import TechnicalUtils
import Messages

-- render for international messages
r = render ["de_DE"]

main = start mainFrame

data ProgramState = ProgramState { unsavedChanges :: Bool
                                   , fileName     :: FilePath
                                   , undoHistory  :: [String]
                                   , redoHistory  :: [String]
                                   }

mainFrame = do
  -- state of the programm
  state <- varCreate $ ProgramState False "" [] []

  -- file menu
  file   <- menuPane      [ text := r File]
  open   <- menuItem file [ text := r Open]
  save   <- menuItem file [ text := r Save]
  saveAs <- menuItem file [ text := r SaveAs]
  quit   <- menuItem file [ text := r Quit]
  -- goto menu
  goto    <- menuPane     [ text := r GoTo]
  goBack  <- menuItem     goto [ text := r EndOfRecentLine]
  goToEnd <- menuItem     goto [ text := r EndOfDocument]
  goToBuffer <-  menuItem goto [ text := r Buffer]
  goToMainArea <-menuItem goto [ text := r MainArea]

  -- main frame
  f        <- frame [text    := "BiVision"
                    ,menuBar := [file,goto]]
  buffer   <- textEntry f []
  mainArea <- textCtrl  f [ font := fontFixed, wrap := WrapNone]
  controlOnText mainArea (onTextUpdate state f mainArea)
  set f [layout := minsize (sz 300 200) $ column 2 [hfill $ widget buffer, fill $ widget mainArea]]

  -- set callbacks
  set f [on (menu quit)         := onQuit state f mainArea
        ,on (menu open)         := onOpen state f mainArea
        ,on (menu save)         := onSave state f mainArea
        ,on (menu saveAs)       := onSaveAs state f mainArea
        ,on (menu goToBuffer)   := focusOn buffer
        ,on (menu goToMainArea) := focusOn mainArea
        ,on (menu goBack)       := onGoBack mainArea
        ,on (menu goToEnd)      := onGoToEnd mainArea]

onTextUpdate :: Var ProgramState -> Frame a -> TextCtrl a -> IO ()
onTextUpdate state f tc = do
  -- obtain cursor coordinates
  coord <- textCtrlGetXYInsertionPoint tc

  -- update text
  old <- get tc text
  set tc [ text := formatForMainBuffer old ]

  -- set old cursor coordinates
  textCtrlSetXYInsertionPoint tc coord

  -- set state to changed
  varUpdate state $ \s -> (s {unsavedChanges = True})
  updateFrameTitle state f

-- Ensure that the text is correctly formated for the buffer
-- 1. All lines have exactly 40 characters. To many characters are removed, missing characters are filled with spaces
-- 2. There are at least 4 empty lines at the end
formatForMainBuffer :: String -> String
formatForMainBuffer i = unlines $ (map formatLine $ lines i) ++ missingLines
  where
  formatLine :: String -> String
  formatLine l = if length l > 40 then take 40 l else l ++ replicate (40 - length l) ' '
  isEmptyLine :: String -> Bool
  isEmptyLine = and . map (== ' ')
  numEmptyLinesAtEnd = length $ takeWhile (== True) $ map isEmptyLine (reverse $ lines i)
  missingLines = if numEmptyLinesAtEnd < 4 then replicate (4 - numEmptyLinesAtEnd) emptyLine else []
  emptyLine = replicate 40 ' '

-- Take a functions that takes a text buffer (as lines) and a position in it and returns a new position.
-- Set this position to the new position in the text buffer
updateTextBufferPosition :: ((Int,Int) -> [String] -> (Int,Int)) -> TextCtrl a -> IO ()
updateTextBufferPosition f tc = do
  -- cursor coordinates and text
  Point x y <- textCtrlGetXYInsertionPoint tc
  text  <- get tc text
  if null text then
    return ()
  else do
    let (newX, newY) = f (x,y) (lines text)
    textCtrlSetXYInsertionPoint tc (Point newX newY)
 
-- helper function
lastNonSpaceCharPos :: String -> Int
lastNonSpaceCharPos = length . dropWhile (==' ') . reverse 

-- goto moste recent line with = in it
onGoBack :: TextCtrl a -> IO ()
onGoBack tc = updateTextBufferPosition findRecentLineWithEqualSign tc
  where
  findRecentLineWithEqualSign (x,y) ls =
    let newY = case lastLineWithSymbol '=' (take y ls) of
             Nothing -> 0
             Just i  -> i
        newX = lastNonSpaceCharPos (ls !! newY)
    in (newX,newY)
  lastLineWithSymbol :: Char -> [String] -> Maybe Int
  lastLineWithSymbol sym ls = if potentialNegative < 0 then Nothing else Just potentialNegative
    where
    potentialNegative = (length . dropWhile (notElem sym) $ (reverse ls)) - 1

-- go after last symbol in last line
onGoToEnd :: TextCtrl a -> IO ()
onGoToEnd tc = updateTextBufferPosition findLastSymbolPosition tc
  where
  findLastSymbolPosition _ ls =
    let newY = boundAtZero $ (length . dropWhile isOnlySpaces $ (reverse ls)) - 1
        boundAtZero i = if i < 0 then 0 else i
        isOnlySpaces = and . map (== ' ')
        newX = lastNonSpaceCharPos (ls !! newY)
    in (newX,newY)

updateFrameTitle :: Var ProgramState -> Frame a -> IO ()
updateFrameTitle state f = do
  fn <- takeFileName . fileName <$> varGet state
  uc <- unsavedChanges <$> varGet state
  set f [text := (if uc then "*" else "") ++ fn ++ " (BiVision)"]

dealWithUnsavedChanges :: Var ProgramState -> Frame a -> TextCtrl a -> IO Bool
dealWithUnsavedChanges state f tc = do
  uc <- unsavedChanges <$> varGet state
  if not uc then return True else do
    res <- messageDialog f "Unsaved changes ..." "You have unsaved changes, do you want to save them?" (wxYES_NO .+. wxCANCEL .+. wxICON_EXCLAMATION)
    case res of
      _ | res == wxID_CANCEL -> return False
        | res == wxID_NO     -> return True
        | res == wxID_YES    -> do
          onSave state f tc
          -- check if saving worked
          newUnsavedChanges <- unsavedChanges <$> varGet state
          return (not newUnsavedChanges)


onQuit :: Var ProgramState -> Frame a -> TextCtrl a -> IO ()
onQuit state f tc = do
    realyQuit <- dealWithUnsavedChanges state f tc
    when realyQuit (close f)
  

-- Function to do the actual saving
saveFile :: TextCtrl a -> Frame a -> FilePath -> IO ()
saveFile tc f fp = do
  txt <- get tc text
  writeFile fp (unlines . reverse . dropWhile null . reverse . map rstrip . lines $ txt) 

openFile :: TextCtrl a -> Frame a -> FilePath -> IO ()
openFile tc f fp = do
  txt <- readFile fp
  set tc [text := txt]

onSaveAs :: Var ProgramState -> Frame a -> TextCtrl a -> IO ()
onSaveAs state f tc = do
  filePath <- fileName <$> varGet state
  fp <- fileSaveDialog f True True "Select a file to save into ..." [("Text file",["*.txt"])] (dropFileName filePath) (takeFileName filePath)
  case fp of
    Nothing -> return ()
    Just newFp -> do
      varUpdate state (\s -> s {fileName = newFp, unsavedChanges = False})
      onSave state f tc

onSave :: Var ProgramState -> Frame a -> TextCtrl a -> IO ()
onSave state f tc = do
  fp <- fileName <$> varGet state
  if null fp then onSaveAs state f tc
  else do
    catch (do
             saveFile tc f fp
             varUpdate state (\s -> s {unsavedChanges = False})
             updateFrameTitle state f
           ) ((\_ -> errorDialog f "Error on writing" ("There was an error writing " ++ fp)) :: SomeException -> IO ())
  
onOpen :: Var ProgramState -> Frame a -> TextCtrl a -> IO ()
onOpen state f tc = do
  realyOpen <- dealWithUnsavedChanges state f tc
  filePath <- fileName <$> varGet state
  when realyOpen $ do
    fp <- fileOpenDialog f True True "Select a file to open ..." [("Text file",["*.txt"])] (dropFileName filePath) (takeFileName filePath)
    case fp of
      Nothing -> return ()
      Just newFp -> do
        catch (do
                 openFile tc f newFp
                 onTextUpdate state f tc
                 varUpdate state (\s -> s {fileName = newFp, unsavedChanges = False})
                 updateFrameTitle state f
              ) $ ((\_ -> errorDialog f "Error on reading" ("There was an error reading " ++ newFp)) :: SomeException -> IO ()) 