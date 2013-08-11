#include <wx/wx.h>
#include "MainFrame.h"

class MyApp : public wxApp
{
    virtual bool OnInit();
};

IMPLEMENT_APP(MyApp)

bool MyApp::OnInit() {
    MainFrame *frame = new MainFrame(_("BiVision"));
    frame->Show(true);
    SetTopWindow(frame);
    return true;
}
