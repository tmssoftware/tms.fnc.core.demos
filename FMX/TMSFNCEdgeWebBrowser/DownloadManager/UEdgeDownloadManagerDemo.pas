unit UEdgeDownloadManagerDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Layouts, FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCEdgeWebBrowser;

type
  TForm3 = class(TForm)
    DownloadPanel: TPanel;
    CancelBtn: TButton;
    DestEdit: TEdit;
    DownloadList: TListBox;
    Label1: TLabel;
    PauseBtn: TButton;
    ResumeBtn: TButton;
    SilentCheck: TCheckBox;
    Splitter1: TSplitter;
    Panel1: TPanel;
    NavBtn: TButton;
    NavEdit: TEdit;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    procedure TMSFNCEdgeWebBrowser1DownloadBytesReceivedChanged(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload; ABytesReceived: Int64; var APause,
      AResume, ACancel: Boolean);
    procedure TMSFNCEdgeWebBrowser1DownloadStarted(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload; var ASilent, APause, AResume,
      ACancel: Boolean);
    procedure TMSFNCEdgeWebBrowser1DownloadStateChanged(Sender: TObject;
      ADownload: TTMSFNCWebBrowserDownload;
      AState: TTMSFNCWebBrowserDownloadState; var APause, AResume,
      ACancel: Boolean);
    procedure DownloadListItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
    procedure NavBtnClick(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
    procedure ResumeBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDownloadList;
    procedure UpdateButtons;
    function ExtractURLFileName(AFileName: string): string;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

//Download started
procedure TForm3.TMSFNCEdgeWebBrowser1DownloadStarted(Sender: TObject; ADownload: TTMSFNCWebBrowserDownload; var ASilent, APause, AResume, ACancel: Boolean);
var
  dir: string;
begin
  ASilent := SilentCheck.IsChecked;

  if DestEdit.Text <> '' then
  begin
    dir := DestEdit.Text;
    if dir[Length(dir)] <> '\' then
      dir := dir + '\';
    ADownload.ResultFilePath := dir + ExtractFileNameEx(ADownload.ResultFilePath);
  end;

  UpdateDownloadList;
end;

// Cancel download
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

// Pause Download
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

// Resume Download
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

//Events triggered when download is updated
procedure TForm3.TMSFNCEdgeWebBrowser1DownloadBytesReceivedChanged(Sender: TObject; ADownload: TTMSFNCWebBrowserDownload; ABytesReceived: Int64;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DownloadStateChanged(Sender: TObject; ADownload: TTMSFNCWebBrowserDownload; AState: TTMSFNCWebBrowserDownloadState;
  var APause, AResume, ACancel: Boolean);
begin
  UpdateDownloadList;
end;

//Other Functions
procedure TForm3.NavBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(NavEdit.Text);
end;

procedure TForm3.DownloadListItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  UpdateButtons;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  PauseBtn.Enabled := False;
  ResumeBtn.Enabled := False;
  CancelBtn.Enabled := False;
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

end.
