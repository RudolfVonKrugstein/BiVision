; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "BiVision"
#define MyAppVersion "0.1"
#define MyAppPublisher "Nathan H�sken"
#define MyAppURL "https://github.com/RudolfVonKrugstein/BiVision"
#define MyAppExeName "Main.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{68E8E7B2-8C08-4142-B7A1-AA2D80C625FF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=C:\BiVision\LICENSE
OutputBaseFilename=setup
SetupIconFile=C:\BiVision\icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\BiVision\Main.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxbase295u_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxbase295u_net_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxbase295u_xml_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxc.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_adv_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_aui_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_core_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_gl_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_html_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_media_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_propgrid_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_ribbon_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_richtext_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_stc_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_webview_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\wxmsw295u_xrc_gcc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\BiVision\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
