unit UContextMenuDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCEdgeWebBrowser,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.Edit,
  FMX.ScrollBox, FMX.Memo, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.Menus, Generics.Collections, FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TContextMenuForm = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    NativeCaption: TLabel;
    PopupCaption: TLabel;
    AddressBar: TLayout;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    SelectedMemo: TMemo;
    NavigateBtn: TButton;
    URIEdit: TEdit;
    DefaultRadio: TRadioButton;
    NativeRadio: TRadioButton;
    CustomRadio: TRadioButton;
    Label1: TLabel;
    ContextMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    NormalRadio: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure NavigateBtnClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure DefaultRadioChange(Sender: TObject);
    procedure NativeRadioChange(Sender: TObject);
    procedure CustomRadioChange(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetContextMenu(Sender: TObject; ATarget: TTMSFNCWebBrowserTargetItem;
      AContextMenu: TObjectList<FMX.TMSFNCWebBrowser.TTMSFNCWebBrowserContextMenuItem>);
    procedure TMSFNCEdgeWebBrowser1CustomContextMenuItemSelected(Sender: TObject;
      ASelectedItem: TTMSFNCWebBrowserCustomContextMenuItem);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  ContextMenuForm: TContextMenuForm;

implementation

{$R *.fmx}

//When the context menu is retrieved
procedure TContextMenuForm.TMSFNCEdgeWebBrowser1GetContextMenu(Sender: TObject; ATarget: TTMSFNCWebBrowserTargetItem;
  AContextMenu: TObjectList<FMX.TMSFNCWebBrowser.TTMSFNCWebBrowserContextMenuItem>);
var
  I: Integer;
  mi: TTMSFNCWebBrowserCustomContextMenuItem;
begin
  if ATarget.SelectionText <> '' then
    SelectedMemo.Lines.Add('Selected Text: ' + ATarget.SelectionText);

  if CustomRadio.IsChecked then
  begin
    I := 0;

    while I < AContextMenu.Count do
    begin
      if AContextMenu[I].AsSystem.Name.ToLower <> 'reload' then
      begin
        AContextMenu.Delete(I);
      end
      else
        Inc(I);
    end;

    mi := TTMSFNCWebBrowserCustomContextMenuItem.Create;
    mi.Name := 'Go to TMS';
    mi.DataInteger := 1;

    AContextMenu.Add(mi);
  end;
end;

// CUSTOM Item Selected
procedure TContextMenuForm.TMSFNCEdgeWebBrowser1CustomContextMenuItemSelected(Sender: TObject; ASelectedItem: TTMSFNCWebBrowserCustomContextMenuItem);
var
  s: string;
begin
  if (ASelectedItem.DataInteger > 0) or Assigned(TMSFNCEdgeWebBrowser1.PopupMenu) then
  begin
    s := ASelectedItem.Name;
    if Assigned(ASelectedItem.ParentItem) then
      s := s + ' (' + ASelectedItem.ParentItem.AsCustom.Name + ')';
    SelectedMemo.Lines.Add(s);

    if ASelectedItem.AsCustom.Name = 'Go to TMS' then
    begin
      TMSFNCEdgeWebBrowser1.Navigate('https://www.tmssoftware.com');
    end;
  end;
end;

procedure TContextMenuForm.MenuItem1Click(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.youtube.com/@tmssoftwareTV')
end;

procedure TContextMenuForm.MenuItem4Click(Sender: TObject);
begin
  MenuItem4.IsChecked := True;
  MenuItem5.IsChecked := False;
end;

procedure TContextMenuForm.MenuItem5Click(Sender: TObject);
begin
  MenuItem4.IsChecked := False;
  MenuItem5.IsChecked := True;
end;

procedure TContextMenuForm.NativeRadioChange(Sender: TObject);
begin
  if NativeRadio.IsChecked then
  begin
    TMSFNCEdgeWebBrowser1.PopupMenu := ContextMenu;
    TMSFNCEdgeWebBrowser1.Settings.UsePopupMenuAsContextMenu := True;
  end;
end;

procedure TContextMenuForm.NavigateBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(URIEdit.Text);
end;

procedure TContextMenuForm.TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', TMSFNCEdgeWebBrowser1.URL) > 0 then
    URIEdit.Text := TMSFNCEdgeWebBrowser1.URL;
end;

procedure TContextMenuForm.CustomRadioChange(Sender: TObject);
begin
  if CustomRadio.IsChecked then
  begin
    TMSFNCEdgeWebBrowser1.PopupMenu := nil;
  end;
end;

procedure TContextMenuForm.DefaultRadioChange(Sender: TObject);
begin
  if DefaultRadio.IsChecked then
  begin
    TMSFNCEdgeWebBrowser1.PopupMenu := ContextMenu;
    TMSFNCEdgeWebBrowser1.Settings.UsePopupMenuAsContextMenu := False;
  end;
end;

procedure TContextMenuForm.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TContextMenuForm.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits, lists and
  memos keep the platform look, which is readable on a light and on a dark form. The page in the
  browser is not themed. }
procedure TContextMenuForm.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TAlphaColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := TAlphaColorRec.Black;
    sec := $FF5B6470;
  end;
  DemoTitle.FontColor := txt;
  NativeCaption.FontColor := txt;
  PopupCaption.FontColor := txt;
  Label1.FontColor := txt;
  NormalRadio.FontColor := txt;
  CustomRadio.FontColor := txt;
  DefaultRadio.FontColor := txt;
  NativeRadio.FontColor := txt;
  DemoDescription.FontColor := sec;
end;

procedure TContextMenuForm.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
