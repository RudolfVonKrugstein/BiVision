import Graphics.UI.WX hiding (when)
import Graphics.UI.WX.Controls
import Graphics.UI.WXCore hiding (when)
import Graphics.UI.WXCore.Events
import Debug.Trace
import Data.String.Utils
import System.FilePath
import Control.Exception
import Control.Monad (unless,when)
import Data.Functor

import TechnicalUtils
import Messages
import FrameWithProcessEvent

-- render for international messages
r = render ["us_US"]

main = start createMainFrame

data ProgramState = ProgramState { unsavedChanges :: Bool
                                   , fileName     :: FilePath
                                   , undoHistory  :: [String]
                                   , redoHistory  :: [String]
                                   , curBuffer    :: String
                                   -- often needed elements
                                   , mainFrame    :: Frame ()
                                   , mainArea     :: TextCtrl ()
                                   , undoItem     :: MenuItem ()
                                   , redoItem     :: MenuItem ()
                                   }

-- initial buffer state
initialBuffer = unlines $ replicate 4 . replicate 40 $ ' '

enableUndo :: Bool -> Var ProgramState -> IO ()
enableUndo enable state = do
  uItem <- undoItem <$> varGet state
  set uItem [ enabled := enable]

enableRedo :: Bool -> Var ProgramState -> IO ()
enableRedo enable state = do
  rItem <- redoItem <$> varGet state
  set rItem [ enabled := enable]

addCurToUndo :: Var ProgramState -> IO ()
addCurToUndo state = do
  varUpdate state (\s -> s {undoHistory =(curBuffer s):(undoHistory s), redoHistory = []})
  enableUndo True state
  return ()

createMainFrame = do
  -- file menu
  file   <- menuPane      [ text := r File]
  open   <- menuItemEx file wxID_OPEN   (r Open)   wxITEM_NORMAL []
  save   <- menuItemEx file wxID_SAVE   (r Save)   wxITEM_NORMAL []
  saveAs <- menuItemEx file wxID_SAVEAS (r SaveAs) wxITEM_NORMAL []
  quit   <- menuQuit file [ text := r Quit]
  -- edit menu
  edit  <- menuPane [ text := r Edit]
  copy  <- menuItemEx edit wxID_COPY  (r Copy)  wxITEM_NORMAL []
  cut   <- menuItemEx edit wxID_CUT   (r Cut)   wxITEM_NORMAL []
  paste <- menuItemEx edit wxID_PASTE (r Paste) wxITEM_NORMAL []
  undo  <- menuItemEx edit wxID_UNDO  (r Undo)  wxITEM_NORMAL [ enabled := False]
  redo  <- menuItemEx edit wxID_REDO  (r Redo)  wxITEM_NORMAL [ enabled := False]
  -- goto menu
  goto    <- menuPane     [ text := r GoTo]
  goBack  <- menuItem     goto [ text := r EndOfRecentLine]
  goToEnd <- menuItem     goto [ text := r EndOfDocument]
  goToBuffer <-  menuItem goto [ text := r Buffer]
  goToMainArea <-menuItem goto [ text := r MainArea]

  -- main frame
  f        <- frameWithProcessEvent [text    := "BiVision"
                    ,menuBar := [file,edit,goto]]
  buffer   <- textEntry f []
  mainArea <- textCtrl  f [ font := fontFixed, wrap := WrapNone]
  set f [layout := minsize (sz 300 200) $ column 2 [hfill $ widget buffer, fill $ widget mainArea]]

  -- state of the programm
  state <- varCreate $ ProgramState False "" [] [] initialBuffer f mainArea undo redo

  -- set callbacks
  controlOnText mainArea (onTextUpdate state)
  set f [on (menu quit)         := onQuit state
        ,on (menu open)         := onOpen state
        ,on (menu save)         := onSave state
        ,on (menu saveAs)       := onSaveAs state
        ,on (menu undo)         := onUndo state
        ,on (menu redo)         := onRedo state
        ,on (menu goToBuffer)   := focusOn buffer
        ,on (menu goToMainArea) := focusOn mainArea
        ,on (menu goBack)       := onGoBack mainArea
        ,on (menu goToEnd)      := onGoToEnd mainArea]

  -- set the initial buffer state
  set mainArea [ text := initialBuffer ]

onTextUpdate :: Var ProgramState -> IO ()
onTextUpdate state = do
  -- obtain cursor coordinates
  tc    <- mainArea <$> varGet state
  coord <- textCtrlGetXYInsertionPoint tc

  -- update text
  old <- get tc text
  let new = formatForMainBuffer old
  set tc [ text := new ]

  -- set old cursor coordinates
  textCtrlSetXYInsertionPoint tc coord

  -- set state to changed and add undo
  addCurToUndo state
  varUpdate state $ \s -> (s {unsavedChanges = True, curBuffer = new})
  enableUndo True state
  updateFrameTitle state

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

-- undo and redo
onUndo :: Var ProgramState -> IO ()
onUndo state = do
  uHist <- undoHistory <$> varGet state
  unless  (null uHist) $ do
    varUpdate state (\s -> s {undoHistory = tail uHist, curBuffer = (head uHist), redoHistory = (curBuffer s):(redoHistory s)})
    enableRedo True state
    enableUndo (not . null . tail $ uHist) state
    tc <- mainArea <$> varGet state
    set tc [text := head uHist]


onRedo :: Var ProgramState -> IO ()
onRedo state = do
  rHist <- redoHistory <$> varGet state
  unless (null rHist) $ do
    varUpdate state (\s -> s {undoHistory = (curBuffer s):(undoHistory s), curBuffer = (head rHist), redoHistory = tail rHist})
    enableUndo True state
    enableRedo (not . null . tail $ rHist) state
    tc <- mainArea <$> varGet state
    set tc [text := head rHist]

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

updateFrameTitle :: Var ProgramState -> IO ()
updateFrameTitle state = do
  fn <- takeFileName . fileName <$> varGet state
  uc <- unsavedChanges <$> varGet state
  f  <- mainFrame <$> varGet state
  set f [text := (if uc then "*" else "") ++ fn ++ " (BiVision)"]

dealWithUnsavedChanges :: Var ProgramState -> IO Bool
dealWithUnsavedChanges state = do
  uc <- unsavedChanges <$> varGet state
  if not uc then return True else do
    f <- mainFrame <$> varGet state
    res <- messageDialog f (r UnsavedChanges) (r WantToSaveUnsavedChanges) (wxYES_NO .+. wxCANCEL .+. wxICON_EXCLAMATION)
    case res of
      _ | res == wxID_CANCEL -> return False
        | res == wxID_NO     -> return True
        | res == wxID_YES    -> do
          onSave state
          -- check if saving worked
          newUnsavedChanges <- unsavedChanges <$> varGet state
          return (not newUnsavedChanges)


onQuit :: Var ProgramState -> IO ()
onQuit state = do
    realyQuit <- dealWithUnsavedChanges state
    f <- mainFrame <$> varGet state
    when realyQuit (close f)
  

-- Function to do the actual saving
saveFile :: TextCtrl a -> Frame a -> FilePath -> IO ()
saveFile tc f fp = do
  txt <- get tc text
  writeFile fp (unlines . reverse . dropWhile null . reverse . map rstrip . lines $ txt) 

openFile :: TextCtrl a -> Frame a -> FilePath -> IO String
openFile tc f fp = do
  txt <- readFile fp
  set tc [text := txt]
  return txt

onSaveAs :: Var ProgramState -> IO ()
onSaveAs state = do
  filePath <- fileName <$> varGet state
  f <- mainFrame <$> varGet state
  fp <- fileSaveDialog f True True (r SelectFileForSave) [("Text file",["*.txt"])] (dropFileName filePath) (takeFileName filePath)
  case fp of
    Nothing -> return ()
    Just newFp -> do
      varUpdate state (\s -> s {fileName = newFp, unsavedChanges = False})
      onSave state

onSave :: Var ProgramState -> IO ()
onSave state = do
  fp <- fileName <$> varGet state
  f <- mainFrame <$> varGet state
  if null fp then onSaveAs state
  else do
    catch (do
             tc <- mainArea <$> varGet state
             saveFile tc f fp
             varUpdate state (\s -> s {unsavedChanges = False})
             updateFrameTitle state
           ) ((\_ -> errorDialog f "Error on writing" ("There was an error writing " ++ fp)) :: SomeException -> IO ())
  
onOpen :: Var ProgramState -> IO ()
onOpen state = do
  realyOpen <- dealWithUnsavedChanges state
  filePath <- fileName <$> varGet state
  when realyOpen $ do
    f <- mainFrame <$> varGet state
    fp <- fileOpenDialog f True True (r SelectFileToOpen) [("Text file",["*.txt"])] (dropFileName filePath) (takeFileName filePath)
    case fp of
      Nothing -> return ()
      Just newFp -> do
        catch (do
                 tc <- mainArea <$> varGet state
                 buf <- openFile tc f newFp
                 onTextUpdate state
                 varUpdate state (\s -> s {fileName = newFp, unsavedChanges = False, undoHistory = [], curBuffer = buf, redoHistory = []})
                 enableUndo False state
                 enableRedo False state
                 updateFrameTitle state
              ) $ ((\_ -> errorDialog f "Error on reading" ("There was an error reading " ++ newFp)) :: SomeException -> IO ()) 
