#pragma once

#include "gui_builder/gui_builder.h"

class MainFrame : public BuilderMainFrame {
public:
    MainFrame( const wxString& title );

protected:
    void ensureTextValidity(wxCommandEvent &event);
    virtual void OnQuit( wxCommandEvent& event );
    virtual void GotoEndOfFirstLine( wxCommandEvent& event );
    virtual void FocusBuffer( wxCommandEvent& event );
    virtual void FocusMainTextArea( wxCommandEvent& event );
};
