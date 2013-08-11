#pragma once

#include "gui_builder/gui_builder.h"
#include <vector>

class MainFrame : public BuilderMainFrame {
public:
    MainFrame( const wxString& title );

    std::vector<wxString> getMainAreaLines();
protected:
    void ensureTextValidity(wxCommandEvent &event);
    virtual void OnQuit( wxCommandEvent& event ) override;
    virtual void GotoEndOfDocument( wxCommandEvent& event ) override;
    virtual void GotoEndOfFirstLine( wxCommandEvent& event ) override;
    virtual void FocusBuffer( wxCommandEvent& event ) override;
    virtual void FocusMainTextArea( wxCommandEvent& event ) override;
};
