import Graphics.UI.WX
import Graphics.UI.WX.Controls
import Graphics.UI.WXCore
import Graphics.UI.WXCore.Events
import TechnicalUtils

main = start mainFrame

data ProgramState = ProgramState { unsavedChanged :: Bool
                                   , fileName       :: String
                                   }

mainFrame = do
  -- state of the programm
  state <- varCreate $ ProgramState False ""

  -- file menu
  file   <- menuPane      [ text := "&File"]
  open   <- menuItem file [ text := "&Open\tCtrl+O"]
  save   <- menuItem file [ text := "&Save\tCtrl+S"]
  saveAs <- menuItem file [ text := "&Save &as"]
  quit   <- menuItem file [ text := "&Quit"]
  -- goto menu
  goto    <- menuPane     [ text := "&GoTo"]
  goBack  <- menuItem     goto [ text := "End of recent line with \"&=\"\tCtrl+1"]
  goToEnd <- menuItem     goto [ text := "&End of document\tCtrl+E"]
  goToBuffer <-  menuItem goto [ text := "&Buffer\tCtrl+B"]
  goToMainArea <-menuItem goto [ text := "&Main Area\tCtrl+M"]

  -- main frame
  f        <- frame [text    := "BiVision"
                    ,menuBar := [file,goto]]
  buffer   <- textEntry f []
  mainArea <- textCtrl  f [ font := fontFixed]
  controlOnText mainArea (onTextUpdate mainArea)
  set f [layout := column 2 [hfill $ widget buffer, fill $ widget mainArea]]

onTextUpdate :: TextCtrl a -> Var ProgramState -> IO ()
onTextUpdate tc state = do
  -- obtain cursor coordinates
  coord <- textCtrlGetXYInsertionPoint tc

  -- update text
  old <- get tc text
  set tc [ text := formatForMainBuffer old ]

  -- set old cursor coordinates
  textCtrlSetXYInsertionPoint tc coord

  -- set state to changed
  modifyVar (\s -> s {unsavedChanges = True})

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
