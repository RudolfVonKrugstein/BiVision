
#include "MainFrame.h"
#include <vector>
#include <wx/filedlg.h>
#include <wx/msgdlg.h>
#include <wx/tokenzr.h>
#include <wx/textfile.h>

MainFrame::MainFrame(const wxString& title)
    : BuilderMainFrame(NULL,-1, title, wxDefaultPosition, wxDefaultSize, wxDEFAULT_FRAME_STYLE) {

}

void MainFrame::OnQuit( wxCommandEvent& event ) {
    Hide();
}

bool MainFrame::loadFile() {
    wxTextFile tFile;
    if (!tFile.Open(m_fileName.GetFullPath())) {
        return false;
    }

    wxString contents;
    contents += tFile.GetFirstLine();
    while(!tFile.Eof()) {
        contents += tFile.GetNextLine();
    }
    tFile.Close();
    m_mainText->SetValue(contents);
    m_unsavedChanges = false;
    return true;
}

bool MainFrame::saveFile() {
    wxTextFile tFile(m_fileName.GetFullPath());
    if (!tFile.Open(m_fileName.GetFullPath())) {
        return false;
    }
    tFile.Clear();
    std::vector<wxString> contents = getMainAreaLines();
    for (wxString line : contents) {
        line.Trim();
        tFile.AddLine(line);
    }
    tFile.Write();
    tFile.Close();
}

size_t lastNonSpaceCharacterPos(wxString f_str) {
    f_str.Trim();
    return f_str.length();
}

bool isEmptyLine(const wxString& fcr_str) {
    for (wxChar c : fcr_str) {
        if (c != ' ') {
            return false;
        }
    }
    return true;
}


std::vector<wxString> MainFrame::getMainAreaLines()
{
    wxString val = m_mainText->GetValue();

    // Split into lines
    std::vector<wxString> lines;
    wxStringTokenizer tkz(val, wxT("\n"));
    while ( tkz.HasMoreTokens() )
    {
        lines.push_back(tkz.GetNextToken());
    }

    return lines;
}

void MainFrame::GotoEndOfDocument(wxCommandEvent &event) {
    std::vector<wxString> lines = getMainAreaLines();
    if (lines.empty()) {
        return;
    }
    // Find last line which is not empty
    long y;
    for (y = lines.size()-1; y > 0; --y) {
        if (!isEmptyLine(lines[y])) {
            break;
        }
    }
    // Found something?
    if (y < 0) {
        return;
    }
    // Get correct positio in this line
    long x = lastNonSpaceCharacterPos(lines[y]);
    m_mainText->SetInsertionPoint(m_mainText->XYToPosition(x,y));
}

void MainFrame::GotoEndOfFirstLine( wxCommandEvent& event ) {
    //Store cursor
    long x,y;
    m_mainText->PositionToXY(m_mainText->GetInsertionPoint(), &x, &y);
    if (x > 40) {
        x = 40;
    }
    std::vector<wxString> lines = getMainAreaLines();
    if (lines.empty()) {
        return;
    }
    // Get the correct line
    for (y; y > 0; --y) {
        if (lines[y].Find('=') != wxNOT_FOUND) {
            break;
        }
    }
    // Get correct positio in first line
    x = lastNonSpaceCharacterPos(lines[y]);
    m_mainText->SetInsertionPoint(m_mainText->XYToPosition(x,y));
}

void MainFrame::FocusBuffer( wxCommandEvent& event ) {
   m_textBuffer->SetFocus();
}

void MainFrame::FocusMainTextArea( wxCommandEvent& event ) {
    m_mainText->SetFocus();
}

void MainFrame::OnOpen(wxCommandEvent &event)
{
    if (m_unsavedChanges) {
        wxMessageDialog m_dialog(this, _("You have unsaved changes, do you want to save them?"), _("Open File ..."), wxYES | wxNO | wxCANCEL);
        int res = m_dialog.ShowModal();
        if (res == wxCANCEL) {
            return;
        }
        if (res == wxYES) {
            if (!trySave()) {
                return;
            }
        }
    }

    wxFileDialog openFileDialog(this, _("Open BiVision txt file"), m_fileName.GetPath(), _(""), _("TXT files (*.txt)|*.txt"), wxFD_OPEN);

    if (openFileDialog.ShowModal() == wxID_CANCEL) {
        return;
    }
    // The the new filename
    m_fileName = openFileDialog.GetFilename();
    m_unsavedChanges = false;
    if (!loadFile()) {
        wxMessageBox(_("Unable to open file"), _("Error"));
    }
}

void MainFrame::OnSave(wxCommandEvent &event) {
    // TODO
    event.Skip();
}

void MainFrame::OnSaveAs(wxCommandEvent &event) {
    // TODO
    event.Skip();
}

void MainFrame::updateTitleString() {
    wxString l_title = m_unsavedChanges?_("*"):_("");
    if (m_fileName.GetFullName().Length()) {
        l_title += _("untitled");
    } else {
        l_title+=m_fileName.GetFullName();
    }
    SetTitle(l_title);
}

bool MainFrame::trySave()
{
    if (!m_unsavedChanges) {
        return true; // Nothing to do, everything is already saved
    }
    if (m_fileName.GetFullName().Length()) {
        return trySaveAs();
    }
    // Ok, just save it
    saveFile();
    return true;
}

bool MainFrame::trySaveAs()
{
    if (!m_unsavedChanges) {
        return true; // Nothing to do, everything is already saved
    }
    // Save file dialog
    wxFileDialog saveFileDialog(this, _("Save BiVision txt file"), m_fileName.GetPath(), _(""), _("TXT files (*.txt)|*.txt"), wxFD_SAVE | wxFD_OVERWRITE_PROMPT);

    if (saveFileDialog.ShowModal() == wxID_CANCEL) {
        return false;
    }
    // Save the conent
    m_fileName = saveFileDialog.GetFilename();
    saveFile();
    return true;
}

void MainFrame::ensureTextValidity(wxCommandEvent &event) {
    BuilderMainFrame::ensureTextValidity(event);

    //Store cursor
    long x,y;
    m_mainText->PositionToXY(m_mainText->GetInsertionPoint(), &x, &y);
    if (x > 40) {
        x = 40;
    }

    wxString val = m_mainText->GetValue();

    // Split into lines
    std::vector<wxString> lines;
    wxStringTokenizer tkz(val, wxT("\n"));
    while ( tkz.HasMoreTokens() )
    {
        lines.push_back(tkz.GetNextToken());
    }
    if (lines.empty()) {
        return;
    }

    // At least always 2 empty lines at end!
    int linesToAdd = 0;
    if (lines.size() < 2) {
        linesToAdd = 2;
    } else {
        if (!isEmptyLine(lines.back())) {
            linesToAdd = 2;
        } else {
        if (!isEmptyLine(lines[lines.size()-2])) {
            linesToAdd = 1;
            }
        }
    }
    for (int i = 0; i < linesToAdd; ++i) {
        lines.push_back(wxT(""));
        lines.push_back(wxT(""));
    }

    // Test lines for length
    for (wxString& line : lines) {
        while (line.length() > 40) {
            line = line.SubString(0, 39);
        }
        while (line.length() < 40) {
            line.Append(_(" "));
            }
    }

    //Unsplit
    wxString newVal = lines[0];
    for (size_t i = 1; i < lines.size(); ++i) {
        newVal += _("\n");
        newVal += lines[i];
    }

    m_mainText->ChangeValue(newVal);
    // Restore cursor
    m_mainText->SetInsertionPoint(m_mainText->XYToPosition(x,y));
}
