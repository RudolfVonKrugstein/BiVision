{-- in this file internationalized (at present only English and German) strings are represented.
 --}
module Messages where

data Message = File
             | Open
             | Save
             | SaveAs
             | Quit
             | GoTo
             | EndOfRecentLine
             | EndOfDocument
             | Buffer
             | MainArea

render_en_US :: Message -> String
render_en_US m = case m of
  File             -> "&File"
  Open             -> "&Open\tCtrl+O"
  Save             -> "&Save\tCtrl+S"
  SaveAs           -> "Save &as"
  Quit             -> "&Quit\tCtrl+Q"
  GoTo             -> "&Go to"
  EndOfRecentLine  -> "End of recent line with \"&=\"\tCtrl+1"
  EndOfDocument    -> "&End of document\tCtrl+E"
  Buffer           -> "&Buffer\tCtrl+B"
  MainArea         -> "&Main Area\tCtrl+M"

render_de_DE :: Message -> String
render_de_DE m = case m of
  File             -> "&Datei"
  Open             -> "&Öffnen\tCtrl+O"
  Save             -> "&Speichern\tCtrl+S"
  SaveAs           -> "Speichern &als"
  Quit             -> "&Beenden\tCtrl+Q"
  GoTo             -> "&Gehe zu"
  EndOfRecentLine  -> "Ende der letzten Zeile mit \"&=\"\tCtrl+1"
  EndOfDocument    -> "&Ende des Dokuments\tCtrl+E"
  Buffer           -> "&Buffer\tCtrl+B"
  MainArea         -> "&Hauptfeld\tCtrl+M"

type Lang = String

render :: [Lang] -> Message -> String
render ("en":_) = render_en_US
render ("en_US":_) = render_en_US
render ("de":_) = render_de_DE
render ("de_DE":_) = render_de_DE
render (_:xs) = render xs
render _ = render_en_US
