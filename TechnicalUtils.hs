module TechnicalUtils (
  textCtrlGetXYInsertionPoint
, textCtrlSetXYInsertionPoint
) where

import Foreign.Ptr
import Foreign.Marshal.Utils
import Foreign.C.Types
import Foreign.Storable
import Data.Functor
import Graphics.UI.WXCore
import Graphics.UI.WX

textCtrlGetXYInsertionPoint :: TextCtrl a -> IO Point
textCtrlGetXYInsertionPoint tc = do
  px <- new 0 :: IO (Ptr CInt)
  py <- new 0 :: IO (Ptr CInt)
  ip <- textCtrlGetInsertionPoint tc
  textCtrlPositionToXY tc ip px py
  x <- fromIntegral <$> peek px
  y <- fromIntegral <$> peek py
  return $ Point x y

textCtrlSetXYInsertionPoint :: TextCtrl a -> Point -> IO ()
textCtrlSetXYInsertionPoint tc p = textCtrlXYToPosition tc p >>= textCtrlSetInsertionPoint tc
