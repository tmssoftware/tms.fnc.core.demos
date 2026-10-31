unit UContextMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, VCL.TMSFNCUtils,
  VCL.TMSFNCTypes, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser.Win, VCL.TMSFNCEdgeWebBrowser, Generics.Collections,
  VCL.TMSFNCWebBrowser, Vcl.ExtCtrls, VCL.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    AddressBar: TPanel;
    NormalRadioRow: TPanel;
    CustomRadioRow: TPanel;
    DefaultRadioRow: TPanel;
    NativeRadioRow: TPanel;
    NormalRadioLabel: TLabel;
    CustomRadioLabel: TLabel;
    DefaultRadioLabel: TLabel;
    NativeRadioLabel: TLabel;
    URLEdit: TEdit;
    NavigationBtn: TButton;
    Label1: TLabel;
    SelectedMemo: TMemo;
    NativeRadio: TRadioButton;
    NormalRadio: TRadioButton;
    DefaultRadio: TRadioButton;
    CustomRadio: TRadioButton;
    ContextMenu: TPopupMenu;
    Youtube1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Light1: TMenuItem;
    Light2: TMenuItem;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    Label2: TLabel;
    Label3: TLabel;
    procedure Youtube1Click(Sender: TObject);
    procedure DefaultRadioClick(Sender: TObject);
    procedure NativeRadioClick(Sender: TObject);
    procedure NormalRadioClick(Sender: TObject);
    procedure CustomRadioClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1CustomContextMenuItemSelected(Sender: TObject;
      ASelectedItem: TTMSFNCWebBrowserCustomContextMenuItem);
    procedure TMSFNCEdgeWebBrowser1GetContextMenu(Sender: TObject;
      ATarget: TTMSFNCWebBrowserTargetItem;
      AContextMenu: TObjectList<VCL.TMSFNCWebBrowser.TTMSFNCWebBrowserContextMenuItem>);
    procedure TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
    procedure NavigationBtnClick(Sender: TObject);
    procedure OptionLabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.CustomRadioClick(Sender: TObject);
begin
  if CustomRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NativeRadio.Checked := False;
    NormalRadio.Checked := False;

    TMSFNCEdgeWebBrowser1.PopupMenu := nil;
  end;
end;

procedure TForm2.DefaultRadioClick(Sender: TObject);
begin
  if DefaultRadio.Checked then
  begin
    NativeRadio.Checked := False;
    NormalRadio.Checked := False;
    CustomRadio.Checked := False;

    TMSFNCEdgeWebBrowser1.PopupMenu := ContextMenu;
    TMSFNCEdgeWebBrowser1.Settings.UsePopupMenuAsContextMenu := False;
  end;
end;

procedure TForm2.NativeRadioClick(Sender: TObject);
begin
  if NativeRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NormalRadio.Checked := False;
    CustomRadio.Checked := False;

    TMSFNCEdgeWebBrowser1.PopupMenu := ContextMenu;
    TMSFNCEdgeWebBrowser1.Settings.UsePopupMenuAsContextMenu := True;
  end;
end;

procedure TForm2.NormalRadioClick(Sender: TObject);
begin
  if NormalRadio.Checked then
  begin
    DefaultRadio.Checked := False;
    NativeRadio.Checked := False;
    CustomRadio.Checked := False;

    TMSFNCEdgeWebBrowser1.PopupMenu := nil;
  end;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1CustomContextMenuItemSelected(Sender: TObject; ASelectedItem: TTMSFNCWebBrowserCustomContextMenuItem);
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

procedure TForm2.TMSFNCEdgeWebBrowser1GetContextMenu(Sender: TObject; ATarget: TTMSFNCWebBrowserTargetItem;
  AContextMenu: TObjectList<VCL.TMSFNCWebBrowser.TTMSFNCWebBrowserContextMenuItem>);
var
  I: Integer;
  mi: TTMSFNCWebBrowserCustomContextMenuItem;
begin
  if ATarget.SelectionText <> '' then
    SelectedMemo.Lines.Add('Selected Text: ' + ATarget.SelectionText);

  if CustomRadio.Checked then
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

procedure TForm2.TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', TMSFNCEdgeWebBrowser1.URL) > 0 then
    URLEdit.Text := TMSFNCEdgeWebBrowser1.URL;
end;

procedure TForm2.Youtube1Click(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.youtube.com/@tmssoftwareTV')
end;

procedure TForm2.NavigationBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(URLEdit.Text);
end;

{ Themed VCL radio buttons draw their caption in the system colour, unreadable on a dark form: the
  caption is a label that follows the theme, and clicking it selects its radio button. }
procedure TForm2.OptionLabelClick(Sender: TObject);
begin
  if (Sender as TLabel).FocusControl is TRadioButton then
    TRadioButton(TLabel(Sender).FocusControl).Checked := True;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits, lists and
  memos keep the platform look, which is readable on a light and on a dark form. The page in the
  browser is not themed. }
procedure TForm2.ThemeChanged(Sender: TObject);
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
  Label1.Font.Color := txt;
  Label2.Font.Color := txt;
  Label3.Font.Color := txt;
  NormalRadioLabel.Font.Color := txt;
  CustomRadioLabel.Font.Color := txt;
  DefaultRadioLabel.Font.Color := txt;
  NativeRadioLabel.Font.Color := txt;
  DemoDescription.Font.Color := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
