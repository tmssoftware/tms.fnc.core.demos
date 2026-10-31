unit UDownloadManagerDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser, VCL.TMSFNCEdgeWebBrowser, VCL.TMSFNCTheme;

type
  TForm3 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    DownloadCaption: TLabel;
    SilentCheckRow: TPanel;
    SilentCheckLabel: TLabel;
    DestLabel: TLabel;
    DownloadsCaption: TLabel;
    DownloadButtons: TPanel;
    AddressBar: TPanel;
    NavBtn: TButton;
    NavEdit: TEdit;
    SilentCheck: TCheckBox;
    DownloadList: TListBox;
    CancelBtn: TButton;
    ResumeBtn: TButton;
    PauseBtn: TButton;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    DestEdit: TEdit;
    procedure NavBtnClick(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure ResumeBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OptionLabelClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1DownloadStarted(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload; var ASilent, APause, AResume,
      ACancel: Boolean);
    procedure TMSFNCEdgeWebBrowser1DownloadBytesReceivedChanged(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload; ABytesReceived: Int64; var APause,
      AResume, ACancel: Boolean);
    procedure TMSFNCEdgeWebBrowser1DownloadStateChanged(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload;
      AState: TTMSFNCWebBrowserDownloadState; var APause, AResume,
      ACancel: Boolean);
    procedure DownloadListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDownloadList;
    procedure UpdateButtons;
    function ExtractURLFileName(AFileName: string): string;
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.CancelBtnClick(Sender: TObject);
var
  d: TTMSFNCWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < TMSFNCEdgeWebBrowser1.Downloads.Count) then
  begin
    d := TTMSFNCWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Cancel;
  end;
end;

procedure TForm3.DownloadListClick(Sender: TObject);
begin
  UpdateDownloadList;
end;

function TForm3.ExtractURLFileName(AFileName: string): string;
var
  FilN,fn, ext: string;
  slPos, extPos: Integer;
begin
  FilN := AFileName;
  Result := '';
  if FilN.Contains('://') then
  begin
    slPos := FilN.LastIndexOf('/') + 1;
    fn := AFileName.Substring(slPos);
    ext := ExtractFileExt(fn);

    if ext.IndexOfAny(['?','&',',','%',' ']) > 0 then
      ext := ext.Substring(0, ext.IndexOfAny(['?','&',',','%',' ']));

    extPos := fn.IndexOf(ext)+ Length(ext);
    Result := fn.Substring(0, extPos);
  end
  else
  begin
    {$IFDEF WEBLIB}
    fn := ExtractFileName(FilN);
    {$ENDIF}
    {$IFNDEF WEBLIB}
    fn := ExtractFileNameEx(FilN);
    {$ENDIF}
    if ExtractFileExt(fn) <> '' then
    begin
      Result := fn;
    end;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  PauseBtn.Enabled := False;
  ResumeBtn.Enabled := False;
  CancelBtn.Enabled := False;
end;

procedure TForm3.NavBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(NavEdit.Text);
end;

procedure TForm3.PauseBtnClick(Sender: TObject);
var
  d: TTMSFNCWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < TMSFNCEdgeWebBrowser1.Downloads.Count) then
  begin
    d := TTMSFNCWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Pause;
  end;
end;

procedure TForm3.ResumeBtnClick(Sender: TObject);
var
  d: TTMSFNCWebBrowserDownload;
begin
  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < TMSFNCEdgeWebBrowser1.Downloads.Count) then
  begin
    d := TTMSFNCWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    d.Resume;
  end;
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DownloadBytesReceivedChanged(
  Sender: TObject; ADownload: TTMSFNCWebBrowserDownload; ABytesReceived: Int64;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DownloadStarted(Sender: TObject; ADownload: TTMSFNCWebBrowserDownload; var ASilent, APause, AResume, ACancel: Boolean);
var
  dir: string;
begin
  ASilent := SilentCheck.Checked;

  if DestEdit.Text <> '' then
  begin
    dir := DestEdit.Text;
    if dir[Length(dir)] <> '\' then
      dir := dir + '\';
    ADownload.ResultFilePath := dir + ExtractFileNameEx(ADownload.ResultFilePath);
  end;

  UpdateDownloadList;
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DownloadStateChanged(Sender: TObject;
  ADownload: TTMSFNCWebBrowserDownload; AState: TTMSFNCWebBrowserDownloadState;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

procedure TForm3.UpdateButtons;
var
  d: TTMSFNCWebBrowserDownload;
  p,r,c: Boolean;
begin
  p := False;
  r := False;
  c := False;

  if (DownloadList.ItemIndex >= 0) and (DownloadList.ItemIndex < TMSFNCEdgeWebBrowser1.Downloads.Count) then
  begin
    d := TTMSFNCWebBrowserDownload(DownloadList.Items.Objects[DownloadList.ItemIndex]);

    if d.State = dsInProgress then
    begin
      p := True;
      c := True;
    end
    else if (d.State = dsInterrupted) then
    begin
      if d.CanResume then
        r := True;
      c := True;
    end;
  end;

  PauseBtn.Enabled := p;
  ResumeBtn.Enabled := r;
  CancelBtn.Enabled := c;
end;

procedure TForm3.UpdateDownloadList;
var
  I, idx: Integer;
  s: string;
begin
  idx := DownloadList.ItemIndex;
  DownloadList.Items.Clear;

  for I := TMSFNCEdgeWebBrowser1.Downloads.Count - 1 downto 0 do
  begin
    if TMSFNCEdgeWebBrowser1.Downloads[I].State = dsInterrupted then
      s:= ExtractURLFileName(TMSFNCEdgeWebBrowser1.Downloads[I].URI) + ': ' + TMSFNCEdgeWebBrowser1.GetDownloadInterruptReasonText(TMSFNCEdgeWebBrowser1.Downloads[I].InterruptReason)
    else
      s:= ExtractURLFileName(TMSFNCEdgeWebBrowser1.Downloads[I].URI) + ': ' + TMSFNCEdgeWebBrowser1.GetDownloadStateText(TMSFNCEdgeWebBrowser1.Downloads[I].State) + ' (' + IntToStr(TMSFNCEdgeWebBrowser1.Downloads[I].BytesReceived) + '/' + IntToStr(TMSFNCEdgeWebBrowser1.Downloads[I].TotalBytes) + ')';

    DownloadList.Items.AddObject(s, TMSFNCEdgeWebBrowser1.Downloads.Items[I]);
  end;

  DownloadList.ItemIndex := idx;
  UpdateButtons;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Themed VCL check boxes draw their caption in the system colour, unreadable on a dark form: the
  caption is a label that follows the theme, and clicking it toggles its check box. }
procedure TForm3.OptionLabelClick(Sender: TObject);
begin
  if (Sender as TLabel).FocusControl is TCheckBox then
    TCheckBox(TLabel(Sender).FocusControl).Checked := not TCheckBox(TLabel(Sender).FocusControl).Checked;
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits, lists and
  memos keep the platform look, which is readable on a light and on a dark form. The page in the
  browser is not themed. }
procedure TForm3.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := clWindowText;
    sec := clGrayText;
  end;
  DemoTitle.Font.Color := txt;
  DownloadCaption.Font.Color := txt;
  DownloadsCaption.Font.Color := txt;
  SilentCheckLabel.Font.Color := txt;
  DestLabel.Font.Color := txt;
  DemoDescription.Font.Color := sec;
end;

procedure TForm3.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
