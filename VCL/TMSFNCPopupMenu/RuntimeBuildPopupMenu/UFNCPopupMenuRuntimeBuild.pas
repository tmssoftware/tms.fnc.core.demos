unit UFNCPopupMenuRuntimeBuild;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.TMSFNCPopupMenu,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer;

type
  TForm4 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    TMSFNCBitmapContainer: TTMSFNCBitmapContainer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    pm: TTMSFNCPopupMenu;
    Selstrs: TArray<string>;
    Otherstrs: TArray<string>;
    procedure DoMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
    procedure DoMenuItemSelectable(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl; var AAllow: Boolean);
    procedure DoGetNumberOfPopupMenuItems(Sender: TObject; var ADisplayItemCount: Integer);
    procedure DoGetNumberOfSubMenuItems(Sender: TObject; AParentMenuItemControl: TTMSFNCMenuItemControl; var ADisplayItemCount: Integer);
    procedure DoMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
    procedure FillSelectionItemStrings;
    procedure FillOtherItemStrings;
    procedure DoOpenTextClick(Sender: TObject);
    procedure DoOpenURLClick(Sender: TObject);
    procedure DoSearchClick(Sender: TObject);
    function IsTextURL(AText: string): Boolean;
  end;

var
  Form4: TForm4;

implementation

uses
  VCL.TMSFNCUtils, Math, Clipbrd;

{$R *.dfm}


procedure TForm4.FillOtherItemStrings;
begin
  SetLength(Otherstrs, 5);

  Otherstrs[0] := '&Paste';
  Otherstrs[1] := '-';
  Otherstrs[2] := 'Select &All';
  Otherstrs[3] := '-';
  Otherstrs[4] := '&Open';
end;

procedure TForm4.FillSelectionItemStrings;
begin
  SetLength(Selstrs, 5);

  Selstrs[0] := '&Cut';
  Selstrs[1] := 'C&opy';
  Selstrs[2] := '&Paste';
  Selstrs[3] := '-';
  Selstrs[4] := '&Open';
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pm.Free;
end;

procedure TForm4.FormCreate(Sender: TObject);
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

function TForm4.IsTextURL(AText: string): Boolean;
begin
  Result := (AText.StartsWith('http://') or AText.StartsWith('https://')) and (AText.Length > 7) ;
end;

procedure TForm4.DoMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  txt: string;
  arr: TArray<string>;
begin
  if not Assigned(AMenuItemControl.ParentMenuControl) then
  begin
    if Edit1.SelText <> '' then
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
    if Edit1.SelText <> '' then
      txt := Edit1.SelText;

    case AMenuItemControl.Index of
      0:
      begin
        AMenuItemControl.Text := 'Search for ' + txt.Substring(0, Max(4,Length(txt)));
        AMenuItemControl.BitmapName := 'Google';
        AMenuItemControl.Appearance.BitmapSize := 20;
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

procedure TForm4.DoMenuItemSelectable(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl; var AAllow: Boolean);
begin
  if (Pos('Paste', AMenuItemControl.Text) > 0) then
  begin
      AAllow := not (Clipboard.AsText = '');
  end;
end;

procedure TForm4.DoGetNumberOfPopupMenuItems(Sender: TObject; var ADisplayItemCount: Integer);
begin
  if Edit1.SelText <> '' then
    ADisplayItemCount := Length(Selstrs)
  else
    ADisplayItemCount := Length(Otherstrs);
end;

procedure TForm4.DoGetNumberOfSubMenuItems(Sender: TObject; AParentMenuItemControl: TTMSFNCMenuItemControl; var ADisplayItemCount: Integer);
begin
  if AParentMenuItemControl.DataInteger = 10 then
    ADisplayItemCount := 2;
end;

procedure TForm4.DoMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
  procedure CutText;
  var
    txt: string;
  begin
    txt := Edit1.SelText;
    Edit1.Text := Copy(Edit1.Text, 1, Edit1.SelStart) + Copy(Edit1.Text, Edit1.SelStart + Edit1.SelLength + 1, MaxInt);
    Clipboard.AsText := txt;
  end;

  procedure CopyText;
  begin
    Clipboard.AsText := Edit1.SelText;
  end;

  procedure PasteText;
  var
    PasteText: string;
    StartPos, SelLen: Integer;
  begin
    PasteText := Clipboard.AsText;
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

  //Via text
  if (Pos('Paste', AMenuItemControl.Text) > 0) then
    PasteText
  else if (Pos('Select', AMenuItemControl.Text) > 0) then
    Edit1.SelectAll
  else if AMenuItemControl.DataInteger = 1 then //Via DataInteger and index
  begin
    case AMenuItemControl.Index of
      0: CutText;
      1: CopyText;
    end;
  end;
end;

procedure TForm4.DoOpenTextClick(Sender: TObject);
begin
  if IsTextURL(Edit1.SelText) or IsTextURL(Edit1.Text) then
    DoOpenURLClick(Self)
  else if Edit1.SelText <> '' then
    DoOpenTextClick(Self)
end;

procedure TForm4.DoOpenURLClick(Sender: TObject);
var
  txt: string;
begin
  txt := Edit1.SelText;

  if not txt.StartsWith('http') then
    txt := Edit1.Text;

  TTMSFNCUtils.OpenURL(txt);
end;

procedure TForm4.DoSearchClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://www.google.com/search?q=' + Edit1.SelText);
end;

end.
