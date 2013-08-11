///////////////////////////////////////////////////////////////////////////
// C++ code generated with wxFormBuilder (version Dec 21 2009)
// http://www.wxformbuilder.org/
//
// PLEASE DO "NOT" EDIT THIS FILE!
///////////////////////////////////////////////////////////////////////////

#ifndef __gui_builder__
#define __gui_builder__

#include <wx/string.h>
#include <wx/textctrl.h>
#include <wx/gdicmn.h>
#include <wx/font.h>
#include <wx/colour.h>
#include <wx/settings.h>
#include <wx/sizer.h>
#include <wx/bitmap.h>
#include <wx/image.h>
#include <wx/icon.h>
#include <wx/menu.h>
#include <wx/frame.h>

///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
/// Class BuilderMainFrame
///////////////////////////////////////////////////////////////////////////////
class BuilderMainFrame : public wxFrame 
{
	private:
	
	protected:
		wxTextCtrl* m_textBuffer;
		wxTextCtrl* m_mainText;
		wxMenuBar* m_menubar1;
		wxMenu* m_menu2;
		wxMenu* m_menu1;
		
		// Virtual event handlers, overide them in your derived class
		virtual void ensureTextValidity( wxCommandEvent& event ) { event.Skip(); }
		virtual void OnOpen( wxCommandEvent& event ) { event.Skip(); }
		virtual void OnSave( wxCommandEvent& event ) { event.Skip(); }
		virtual void OnSaveAs( wxCommandEvent& event ) { event.Skip(); }
		virtual void OnQuit( wxCommandEvent& event ) { event.Skip(); }
		virtual void GotoEndOfFirstLine( wxCommandEvent& event ) { event.Skip(); }
		virtual void GotoEndOfDocument( wxCommandEvent& event ) { event.Skip(); }
		virtual void FocusBuffer( wxCommandEvent& event ) { event.Skip(); }
		virtual void FocusMainTextArea( wxCommandEvent& event ) { event.Skip(); }
		
	
	public:
		
		BuilderMainFrame( wxWindow* parent, wxWindowID id = wxID_ANY, const wxString& title = wxT("BiVision"), const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxSize( 696,356 ), long style = wxCLOSE_BOX|wxDEFAULT_FRAME_STYLE|wxMAXIMIZE|wxMINIMIZE|wxRESIZE_BORDER|wxTAB_TRAVERSAL );
		~BuilderMainFrame();
	
};

#endif //__gui_builder__
