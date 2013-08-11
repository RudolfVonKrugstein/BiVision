
#include "MainFrame.h"
#include <vector>
#include <wx/tokenzr.h>

MainFrame::MainFrame(const wxString& title)
    : BuilderMainFrame(NULL,-1, title, wxDefaultPosition, wxDefaultSize, wxDEFAULT_FRAME_STYLE) {

}

void MainFrame::OnQuit( wxCommandEvent& event ) {
    Hide();
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
