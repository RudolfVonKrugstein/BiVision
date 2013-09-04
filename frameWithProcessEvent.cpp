#include "frameWithProcessEvent.h"

/** We want a slightly specialized class of wxFrame for the application.
 *  The ProcessEvent function is overwritten (and taken from the richtext example of wxWidgets).
 *  The new process as the advantages, that menu items with wxID_COPY/CUT/PASTE are automaticly updated and also have
 *  automaticly the desired effect (copying, cutting, pasting in the active buffer).*/
class FrameWithProcessEvent : public wxFrame {
public:

  FrameWithProcessEvent(wxWindow *parent,
                        wxWindowID id,
                        const wxString& title,
                        const wxPoint& pos = wxDefaultPosition,
                        const wxSize& size = wxDefaultSize,
                        long style = wxDEFAULT_FRAME_STYLE,
                        const wxString& name = wxFrameNameStr)
    : wxFrame(parent, id, title, pos, size, style, name)
  {}

  bool ProcessEvent(wxEvent& event) override
  {
    if (event.IsCommandEvent() && !event.IsKindOf(CLASSINFO(wxChildFocusEvent)))
    {
      // Problem: we can get infinite recursion because the events
      // climb back up to this frame, and repeat.
      // Assume that command events don't cause another command event
      // to be called, so we can rely on inCommand not being overwritten

      static int s_eventType = 0;
      static wxWindowID s_id = 0;

      if (s_id != event.GetId() && s_eventType != event.GetEventType())
      {
        s_eventType = event.GetEventType();
        s_id = event.GetId();

        wxWindow* focusWin = wxFindFocusDescendant(this);
        if (focusWin && focusWin->GetEventHandler()->ProcessEvent(event))
        {
          //s_command = NULL;
          s_eventType = 0;
          s_id = 0;
          return true;
        }

        s_eventType = 0;
        s_id = 0;
      }
      else
      {
        return false;
      }
    }

    return wxFrame::ProcessEvent(event);
  }
};

extern "C" {

EWXWEXPORT(wxFrame*,wxFrameWithProcessEvent_Create)(wxWindow* _prt,int _id,wxString* _txt,int _lft,int _top,int _wdt,int _hgt,int _stl)
{
	return new FrameWithProcessEvent (_prt, _id, *_txt, wxPoint(_lft, _top), wxSize(_wdt, _hgt), _stl);
}

}
