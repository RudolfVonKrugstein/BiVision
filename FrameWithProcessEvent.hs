module FrameWithProcessEvent (
  frameWithProcessEvent
) where


import Graphics.UI.WXCore

import Graphics.UI.WX.Types
import Graphics.UI.WX.Attributes
import Graphics.UI.WX.Layout
import Graphics.UI.WX.Classes
import Graphics.UI.WX.Window
import Graphics.UI.WX.TopLevelWindow
import Graphics.UI.WX.Events
import Graphics.UI.WX.Frame
import Graphics.UI.WXCore.WxcClassesAL
import qualified Data.ByteString as B (ByteString, useAsCStringLen)
import qualified Data.ByteString.Lazy as LB (ByteString, length, unpack)
import System.IO.Unsafe( unsafePerformIO )
import Foreign.C.Types(CInt(..), CWchar(..), CChar(..), CDouble(..))
import Graphics.UI.WXCore.WxcTypes
import Graphics.UI.WXCore.WxcClassTypes

-- this is basicly copied from wxHaskell.
-- Only difference is, that not a wxFrame but a frameWithProcessEvents is created.
-- See frameWithProcessEvent.cpp for details.

-- | Create a top-level frame window.
frameWithProcessEvent :: [Prop (Frame ())]  -> IO (Frame ())
frameWithProcessEvent props
  = frameWithProcessEventEx frameDefaultStyle props objectNull

-- | Create a top-level frame window in a custom style.
frameWithProcessEventEx :: Style -> [Prop (Frame ())]  -> Window a -> IO (Frame ())
frameWithProcessEventEx style props parent
  = feed2 props style $
    initialFrame $ \id rect txt -> \props style ->
    do f <- frameWithProcessEventCreate parent id txt rect style
       let initProps = (if (containsProperty visible props)
                        then [] else [visible := True]) ++
                       (if (containsProperty bgcolor props)
                        then [] else [bgcolor := colorSystem Color3DFace])
       set f initProps
       set f props
       return f

-- | usage: (@frameWithProcessEventCreate prt id txt lfttopwdthgt stl@).
frameWithProcessEventCreate :: Window  a -> Id -> String -> Rect -> Style ->  IO (Frame  ())
frameWithProcessEventCreate _prt _id _txt _lfttopwdthgt _stl 
  = withObjectResult $
    withObjectPtr _prt $ \cobj__prt -> 
    withStringPtr _txt $ \cobj__txt -> 
    wxFrameWithProcessEvent_Create cobj__prt  (toCInt _id)  cobj__txt  (toCIntRectX _lfttopwdthgt) (toCIntRectY _lfttopwdthgt)(toCIntRectW _lfttopwdthgt) (toCIntRectH _lfttopwdthgt)  (toCInt _stl)  
foreign import ccall "frameWithProcessEvent.h wxFrameWithProcessEvent_Create" wxFrameWithProcessEvent_Create :: Ptr (TWindow a) -> CInt -> Ptr (TWxString c) -> CInt -> CInt -> CInt -> CInt -> CInt -> IO (Ptr (TFrame ()))
