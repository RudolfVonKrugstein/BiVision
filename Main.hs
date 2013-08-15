import Graphics.UI.WX
import Graphics.UI.WX.Controls
import Graphics.UI.WXCore.Events

main = start mainFrame

mainFrame = do
  f        <- frame [text := "BiVision"]
  buffer   <- textEntry f []
  mainArea <- textCtrl  f []
  controlOnText mainArea (onTextUpdate mainArea)
  set f [layout := column 2 [hfill $ widget buffer, fill $ widget mainArea]]

onTextUpdate :: TextCtrl a -> IO ()
onTextUpdate tc = do
  set tc [ text := "Hello, World"]

