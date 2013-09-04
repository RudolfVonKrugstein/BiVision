#include <wx/frame.h>

#undef TClass
#define TClass(tp) tp*
#define TRect(x,y,w,h)    int x,  int y,  int w,  int h


#ifdef __WATCOMC__
  #include <windows.h>
  #define EWXWEXPORT(TYPE,FUNC_NAME) TYPE __export __cdecl FUNC_NAME
#else
  #ifdef _WIN32
    #define EWXWEXPORT(TYPE,FUNC_NAME) __declspec(dllexport) TYPE __cdecl FUNC_NAME
    #undef EXPORT
    #define EXPORT extern "C" __declspec(dllexport) 
  #else
    #define EWXWEXPORT(TYPE,FUNC_NAME) TYPE FUNC_NAME
  #endif
  #ifndef _cdecl
    #define _cdecl
  #endif
#endif

extern "C" {
TClass(wxFrame) wxFrameWithProcessEvent_Create( TClass(wxWindow) _prt, int _id, TClass(wxString) _txt, TRect(_lft,_top,_wdt,_hgt), int _stl );
}
