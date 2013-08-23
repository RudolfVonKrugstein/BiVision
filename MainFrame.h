#pragma once

#include "gui_builder/gui_builder.h"
#include <vector>
#include <wx/filename.h>

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
    virtual void OnOpen( wxCommandEvent& event ) override;
    virtual void OnSave( wxCommandEvent& event ) override;
    virtual void OnSaveAs( wxCommandEvent& event ) override;

    // Trys to save the current content, and returns if it succeded
    bool trySave();
    bool trySaveAs();
    // Saves the file assuming m_fileName is set
    bool saveFile();
    bool loadFile();

    // Connection to saved file
    bool m_unsavedChanges;
    wxFileName m_fileName;

    void updateTitleString();
};
