///////////////////////////////////////////////////////////////////////////
// C++ code generated with wxFormBuilder (version Dec 21 2009)
// http://www.wxformbuilder.org/
//
// PLEASE DO "NOT" EDIT THIS FILE!
///////////////////////////////////////////////////////////////////////////

#include "gui_builder.h"

///////////////////////////////////////////////////////////////////////////

BuilderMainFrame::BuilderMainFrame( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style ) : wxFrame( parent, id, title, pos, size, style )
{
	this->SetSizeHints( wxDefaultSize, wxDefaultSize );
	
	wxBoxSizer* bSizer1;
	bSizer1 = new wxBoxSizer( wxVERTICAL );
	
	m_textBuffer = new wxTextCtrl( this, wxID_ANY, wxEmptyString, wxDefaultPosition, wxDefaultSize, 0 );
	m_textBuffer->SetFont( wxFont( wxNORMAL_FONT->GetPointSize(), 76, 90, 90, false, wxEmptyString ) );
	
	bSizer1->Add( m_textBuffer, 0, wxALL|wxEXPAND, 7 );
	
	m_mainText = new wxTextCtrl( this, wxID_ANY, wxEmptyString, wxDefaultPosition, wxDefaultSize, wxTE_DONTWRAP|wxTE_MULTILINE );
	m_mainText->SetFont( wxFont( wxNORMAL_FONT->GetPointSize(), 76, 90, 90, false, wxEmptyString ) );
	
	bSizer1->Add( m_mainText, 1, wxALL|wxEXPAND, 7 );
	
	this->SetSizer( bSizer1 );
	this->Layout();
	m_menubar1 = new wxMenuBar( 0 );
	m_menu2 = new wxMenu();
	wxMenuItem* m_menuItemOpen;
	m_menuItemOpen = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("&Open ...") ) + wxT('\t') + wxT("Alt-O"), wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItemOpen );
	
	wxMenuItem* m_menuItemSave;
	m_menuItemSave = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("&Save") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItemSave );
	
	wxMenuItem* m_menuItemSaveAs;
	m_menuItemSaveAs = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("Save &As ...") ) , wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItemSaveAs );
	
	wxMenuItem* m_menuItemQuit;
	m_menuItemQuit = new wxMenuItem( m_menu2, wxID_ANY, wxString( wxT("&Quit") ) + wxT('\t') + wxT("Alt-Q"), wxEmptyString, wxITEM_NORMAL );
	m_menu2->Append( m_menuItemQuit );
	
	m_menubar1->Append( m_menu2, wxT("&File") );
	
	m_menu1 = new wxMenu();
	wxMenuItem* m_endOfFirstLine;
	m_endOfFirstLine = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("End of  recent line with \"&=\"") ) + wxT('\t') + wxT("Alt-1"), wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_endOfFirstLine );
	
	wxMenuItem* m_endOfDocument;
	m_endOfDocument = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("End of document") ) + wxT('\t') + wxT("Alt-E"), wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_endOfDocument );
	
	wxMenuItem* m_gotoBuffer;
	m_gotoBuffer = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("&Buffer") ) + wxT('\t') + wxT("Alt-B"), wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_gotoBuffer );
	
	wxMenuItem* m_gotoMain;
	m_gotoMain = new wxMenuItem( m_menu1, wxID_ANY, wxString( wxT("&Main Text Area") ) + wxT('\t') + wxT("Alt-M"), wxEmptyString, wxITEM_NORMAL );
	m_menu1->Append( m_gotoMain );
	
	m_menubar1->Append( m_menu1, wxT("&GoTo") );
	
	this->SetMenuBar( m_menubar1 );
	
	
	// Connect Events
	m_mainText->Connect( wxEVT_COMMAND_TEXT_UPDATED, wxCommandEventHandler( BuilderMainFrame::ensureTextValidity ), NULL, this );
	this->Connect( m_menuItemOpen->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnOpen ) );
	this->Connect( m_menuItemSave->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnSave ) );
	this->Connect( m_menuItemSaveAs->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnSaveAs ) );
	this->Connect( m_menuItemQuit->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnQuit ) );
	this->Connect( m_endOfFirstLine->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::GotoEndOfFirstLine ) );
	this->Connect( m_endOfDocument->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::GotoEndOfDocument ) );
	this->Connect( m_gotoBuffer->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::FocusBuffer ) );
	this->Connect( m_gotoMain->GetId(), wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::FocusMainTextArea ) );
}

BuilderMainFrame::~BuilderMainFrame()
{
	// Disconnect Events
	m_mainText->Disconnect( wxEVT_COMMAND_TEXT_UPDATED, wxCommandEventHandler( BuilderMainFrame::ensureTextValidity ), NULL, this );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnOpen ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnSave ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnSaveAs ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::OnQuit ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::GotoEndOfFirstLine ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::GotoEndOfDocument ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::FocusBuffer ) );
	this->Disconnect( wxID_ANY, wxEVT_COMMAND_MENU_SELECTED, wxCommandEventHandler( BuilderMainFrame::FocusMainTextArea ) );
}
