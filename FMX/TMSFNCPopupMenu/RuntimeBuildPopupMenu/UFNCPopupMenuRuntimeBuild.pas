unit UFNCPopupMenuRuntimeBuild;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCPopupMenu, FMX.Edit,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    TMSFNCBitmapContainer: TTMSFNCBitmapContainer;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DoMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
    procedure DoMenuItemSelectable(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl; var AAllow: Boolean);
    procedure DoGetNumberOfPopupMenuItems(Sender: TObject; var ADisplayItemCount: Integer);
    procedure DoGetNumberOfSubMenuItems(Sender: TObject; AParentMenuItemControl: TTMSFNCMenuItemControl; var ADisplayItemCount: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
  private
    { Private declarations }
  public
    { Public declarations }
    pm: TTMSFNCPopupMenu;
    Selstrs: TArray<string>;
    Otherstrs: TArray<string>;
    procedure FillSelectionItemStrings;
    procedure FillOtherItemStrings;
    procedure DoOpenTextClick(Sender: TObject);
    procedure DoOpenURLClick(Sender: TObject);
    procedure DoSearchClick(Sender: TObject);
    function IsTextURL(AText: string): Boolean;
  end;

var
  Form1: TForm1;

implementation

uses
  FMX.TMSFNCUtils, FMX.Platform, Math;

{$R *.fmx}

procedure TForm1.FillOtherItemStrings;
begin
  SetLength(Otherstrs, 5);

  Otherstrs[0] := '&Paste';
  Otherstrs[1] := '-';
  Otherstrs[2] := 'Select &All';
  Otherstrs[3] := '-';
  Otherstrs[4] := '&Open';
end;

procedure TForm1.FillSelectionItemStrings;
begin
  SetLength(Selstrs, 5);

  Selstrs[0] := '&Cut';
  Selstrs[1] := 'C&opy';
  Selstrs[2] := '&Paste';
  Selstrs[3] := '-';
  Selstrs[4] := '&Open';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pm.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  pm := TTMSFNCPopupMenu.Create(Self);
  pm.Appearance.DefaultItemAppearance.ItemHeight := 30;

  pm.OnMenuItemControlAdded := DoMenuItemControlAdded;
  pm.OnGetNumberOfPopupMenuItems := DoGetNumberOfPopupMenuItems;
  pm.OnGetNumberOfSubMenuItems := DoGetNumberOfSubMenuItems;
  pm.OnMenuItemSelectable := DoMenuItemSelectable;
  pm.OnMenuItemClick := DoMenuItemClick;

  pm.BitmapContainer := TMSFNCBitmapContainer;

  FillSelectionItemStrings;
  FillOtherItemStrings;

  Edit1.PopupMenu := pm;
end;

function TForm1.IsTextURL(AText: string): Boolean;
begin
  Result := (AText.StartsWith('http://') or AText.StartsWith('https://')) and (AText.Length > 7) ;
end;

procedure TForm1.DoMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  txt: string;
  arr: TArray<string>;
begin
  if not Assigned(AMenuItemControl.ParentMenuControl) then
  begin
    if Edit1.HasSelection then
    begin
      arr := Selstrs;
      AMenuItemControl.DataInteger := 1;
    end
    else
      arr := Otherstrs;

    if arr[AMenuItemControl.Index] = '-'  then
    begin
      AMenuItemControl.ItemType := mitSeparator;
      AMenuItemControl.Appearance.ItemHeight := -1;
    end
    else
      AMenuItemControl.Text := arr[AMenuItemControl.Index];

    AMenuItemControl.BitmapName := arr[AMenuItemControl.Index].Replace('&','');

    if (Pos('Open', AMenuItemControl.Text) > 0) then
    begin
      AMenuItemControl.ItemType := mitDropDownButton;
      AMenuItemControl.OnClick := DoOpenTextClick;
      AMenuItemControl.HasSubItems := True;
      AMenuItemControl.DataInteger := 10;
    end;
  end
  else if AMenuItemControl.ParentMenuControl.DataInteger = 10 then
  begin
    if Edit1.HasSelection then
      txt := Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength);

    case AMenuItemControl.Index of
      0:
      begin
        AMenuItemControl.Text := 'Search for ' + txt.Substring(0, Max(4,Length(txt)));
        AMenuItemControl.Appearance.BitmapSize := 20;
        AMenuItemControl.BitmapName := 'Google';
        AMenuItemControl.Enabled := txt <> '';
        AMenuItemControl.OnClick := DoSearchClick;

      end;
      1:
      begin
        AMenuItemControl.Text := 'Open Link';
        AMenuItemControl.OnClick := DoOpenURLClick;
        AMenuItemControl.Enabled := IsTextURL(txt) or IsTextURL(Edit1.Text);
      end;
    end;
  end;
end;

procedure TForm1.DoMenuItemSelectable(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl; var AAllow: Boolean);
var
  uClipBoard : IFMXClipboardService;
begin
  if (Pos('Paste', AMenuItemControl.Text) > 0) then
  begin
    if SupportsPlatformService(IFMXClipboardService, uClipBoard) then
      AAllow := not (uClipBoard.GetClipboard.AsString = '');
  end;
end;

procedure TForm1.DoGetNumberOfPopupMenuItems(Sender: TObject; var ADisplayItemCount: Integer);
begin
  if Edit1.HasSelection then
    ADisplayItemCount := Length(Selstrs)
  else
    ADisplayItemCount := Length(Otherstrs);
end;

procedure TForm1.DoGetNumberOfSubMenuItems(Sender: TObject; AParentMenuItemControl: TTMSFNCMenuItemControl; var ADisplayItemCount: Integer);
begin
  if AParentMenuItemControl.DataInteger = 10 then
    ADisplayItemCount := 2;
end;

procedure TForm1.DoMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  uClipBoard : IFMXClipboardService;
  clipOk: Boolean;

  procedure CutText;
  var
    txt: string;
  begin
    txt := Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength);
    Edit1.Text := Copy(Edit1.Text, 1, Edit1.SelStart) + Copy(Edit1.Text, Edit1.SelStart + Edit1.SelLength + 1, MaxInt);
    if clipOk then
      uClipBoard.SetClipboard(txt);
  end;

  procedure CopyText;
  begin
    if clipOk then
      uClipBoard.SetClipboard(Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength));
  end;

  procedure PasteText;
  var
    PasteText: string;
    StartPos, SelLen: Integer;
  begin
    if not clipOk then
      Exit;

    PasteText := uClipboard.GetClipboard.AsString;
    if PasteText.IsEmpty then
      Exit;

    StartPos := Edit1.SelStart;
    SelLen := Edit1.SelLength;

    Edit1.Text :=
      Copy(Edit1.Text, 1, StartPos) +
      PasteText +
      Copy(Edit1.Text, StartPos + SelLen + 1, MaxInt);

    Edit1.SelStart := StartPos + PasteText.Length;
    Edit1.SelLength := 0;
  end;
begin
  //OnItemClick is not triggered for items that have their own OnClick event.

  if SupportsPlatformService(IFMXClipboardService, uClipBoard) then
    clipOk := True;

  //Via text
  if (Pos('Paste', AMenuItemControl.Text) > 0) then
    PasteText
  else if (Pos('Select', AMenuItemControl.Text) > 0) then
    Edit1.SelectAll(False)
  else if AMenuItemControl.DataInteger = 1 then //Via DataInteger and index
  begin
    case AMenuItemControl.Index of
      0: CutText;
      1: CopyText;
    end;
  end;
end;

procedure TForm1.DoOpenTextClick(Sender: TObject);
begin
  if IsTextURL(Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength)) or IsTextURL(Edit1.Text) then
    DoOpenURLClick(Self)
  else if Edit1.HasSelection then
    DoOpenTextClick(Self)
end;

procedure TForm1.DoOpenURLClick(Sender: TObject);
var
  txt: string;
begin
  txt := Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength);

  if not txt.StartsWith('http') then
    txt := Edit1.Text;

  TTMSFNCUtils.OpenURL(txt);
end;

procedure TForm1.DoSearchClick(Sender: TObject);
var
  txt: string;
begin
  txt := Edit1.Text.Substring(Edit1.SelStart, Edit1.SelLength);
  TTMSFNCUtils.OpenURL('https://www.google.com/search?q=' + txt);
end;

end.
