unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, JSON,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSFNCCloudBase, FMX.TMSFNCUtils,
  FMX.Layouts, FMX.ListBox, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, Generics.Collections,
  FMX.Objects, FMX.TMSFNCTheme;

type
  TMovie = class(TPersistent)
  private
    FName: string;
    FImageUrl: string;
  published
    property Name: string read FName write FName;
    property ImageUrl: string read FImageUrl write FImageUrl;
  end;

  TMovies = class(TObjectList<TMovie>);

  TForm3 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    SearchCaption: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ListBox1: TListBox;
    Image1: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    cb: TTMSFNCCloudBase;
    movies: TMovies;
    procedure ThemeChanged(Sender: TObject);
    procedure UpdateList;
    procedure DoGetMovies(const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoGetMovieImage(const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    { Public declarations }
  end;
var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
  //http://www.tvmaze.com/api

  movies.Clear;

  cb.Request.Clear;
  cb.Request.Host := 'http://api.tvmaze.com';
  cb.Request.Path := '/search/shows';
  cb.Request.Query := 'q=' + Edit1.Text;

  cb.ExecuteRequest(DoGetMovies);
end;

procedure TForm3.DoGetMovieImage(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  ms: TMemoryStream;
begin
  if ARequestResult.Success then
  begin
    ms := TMemoryStream.Create;
    try
      ms.CopyFrom(ARequestResult.ResultStream, ARequestResult.ResultStream.Size);
      Image1.Bitmap.LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;
end;

procedure TForm3.DoGetMovies(
  const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  o, fo: TJSONValue;
  jv, jvv, jvvv: TJSONValue;
  ja: TJSONArray;
  I: Integer;
  m: TMovie;
begin
  if ARequestResult.ResultString <> '' then
  begin
    o := TTMSFNCUtils.ParseJSON(ARequestResult.ResultString);

    if Assigned(o) then
    begin
      try
        ja := o as TJSONArray;
        for i := 0 to TTMSFNCUtils.GetJSONArraySize(ja) - 1 do
        begin
          fo := TTMSFNCUtils.GetJSONArrayItem(ja, i);

          m := TMovie.Create;

          jv := TTMSFNCUtils.GetJSONValue(fo, 'show');
          if Assigned(jv) then
          begin
            jvv := TTMSFNCUtils.GetJSONValue(jv, 'name');
            if Assigned(jvv) then
              m.Name := TTMSFNCUtils.GetJSONProp(jv, 'name');

            jvv := TTMSFNCUtils.GetJSONValue(jv, 'image');
            if Assigned(jvv) then
            begin
              jvvv := TTMSFNCUtils.GetJSONValue(jvv, 'medium');
              if Assigned(jvvv) then
                m.ImageUrl := TTMSFNCUtils.GetJSONProp(jvv, 'medium');
            end;
          end;

          movies.Add(m);
        end;
      finally
        o.Free;
      end;
    end;
  end;

  UpdateList;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);

  cb := TTMSFNCCloudBase.Create;

  movies := TMovies.Create;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
  movies.Free;
  cb.Free;
end;

procedure TForm3.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  cb.Request.Clear;
  cb.Request.Method := rmGET;
  cb.Request.ResultType := rrtStream;
  cb.Request.Host := (Item.Data as TMovie).ImageUrl;

  cb.ExecuteRequest(DoGetMovieImage);
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits and lists
  keep the platform look, which is readable on a light and on a dark form. }
procedure TForm3.ThemeChanged(Sender: TObject);
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
  SearchCaption.FontColor := txt;
  DemoDescription.FontColor := sec;
  Label1.FontColor := sec;
end;

procedure TForm3.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

procedure TForm3.UpdateList;
var
  I: Integer;
begin
  ListBox1.Items.Clear;
  ListBox1.BeginUpdate;
  for I := 0 to movies.Count - 1 do
  begin
    ListBox1.Items.AddObject(movies[I].Name, movies[I]);
  end;
  ListBox1.EndUpdate;
end;

end.
