unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  FMX.TMSFNCPDFLib, FMx.TMSFNCGraphicsTypes, UConsts;

{$R *.fmx}

procedure TForm4.Button1Click(Sender: TObject);
const
  cLeft = 40;
  cFieldLeft = 180;
  cHeight = 20;
  cGap = 15;
  cName = 80;
  cEmail = 110;
  cProduct = 150;
  cPurpose = 180;
  cSatisfaction = 220;
  cEaseOfUse = 250;
  cValueForMoney = 280;
  cSupport = 310;
  cLikes = 350;
  cImprove = 480;
  cContact = 620;
var
  p: TTMSFNCPDFLib;
  e: ITMSFNCCustomPDFFormFieldEdit;
  r: TRectF;
begin
  p := TTMSFNCPDFLib.Create;
  try
    p.Header := '';
    p.Footer := '';
    p.PageSize := psCustom;
    p.PageWidth := 595;
    p.PageHeight := 842;
    p.BeginDocument('Customer_Feedback.pdf');
    p.NewPage;

    p.Graphics.Font.Size := 16;
    p.Graphics.Font.Style := [TFontStyle.fsBold];
    p.Graphics.DrawText('Customer Feedback Form', PointF(cLeft, 40));

    p.Graphics.Font.Style := [];
    p.Graphics.Font.Size := 14;
    p.Graphics.DrawText('Customer name:', PointF(cLeft, cName));
    p.FormFields.AddEdit(cCustomerName, RectF(cFieldLeft, cName, cFieldLeft + 200, cName + cHeight));

    p.Graphics.DrawText('Email:', PointF(cLeft, cEmail));
    p.FormFields.AddEdit(cCustomerEmail, RectF(cFieldLeft, cEmail, cFieldLeft + 200, cEmail + cHeight));

    p.Graphics.DrawText('Product purchased:', PointF(cLeft, cProduct));
    p.FormFields.AddComboBox(cProductName, RectF(cFieldLeft, cProduct, cFieldLeft + 100, cProduct + cHeight), ['Product A', 'Product B']);

    p.Graphics.DrawText('Purpose of use:', PointF(cLeft, cPurpose));
    p.FormFields.AddComboBox(cProductPurpose, RectF(cFieldLeft, cPurpose, cFieldLeft + 100, cPurpose + cHeight), ['Business', 'Education', 'Personal', 'Other']);

    p.Graphics.DrawText('Overall satisfaction:', PointF(cLeft, cSatisfaction));
    p.Graphics.Font.Size := 7;
    p.Graphics.Alignment := gtaCenter;
    r := p.Graphics.DrawText('Very Dissatisfied', RectF(cFieldLeft, cSatisfaction, cFieldLeft + 40, cSatisfaction + cHeight));
    p.FormFields.AddRadioGroup(cSatisfactionOverall, 'SatisfactionGroup');
    p.FormFields.AddRadioButton('1', RectF(r.Right + cGap, cSatisFaction, r.Right + cGap + cHeight, cSatisFaction + cHeight), 'SatisfactionGroup');
    p.FormFields.AddRadioButton('2', RectF(r.Right + cGap + 25, cSatisFaction, r.Right + cGap + cHeight + 25, cSatisFaction + cHeight), 'SatisfactionGroup');
    p.FormFields.AddRadioButton('3', RectF(r.Right + cGap + 50, cSatisFaction, r.Right + cGap + cHeight + 50, cSatisFaction + cHeight), 'SatisfactionGroup');
    p.FormFields.AddRadioButton('4', RectF(r.Right + cGap + 75, cSatisFaction, r.Right + cGap + cHeight + 75, cSatisFaction + cHeight), 'SatisfactionGroup');
    p.FormFields.AddRadioButton('5', RectF(r.Right + cGap + 100, cSatisFaction, r.Right + cGap + cHeight + 100, cSatisFaction + cHeight), 'SatisfactionGroup');
    p.Graphics.DrawText('Very Satisfied', RectF(r.Right +  2 * cGap + cHeight + 100, cSatisfaction, r.Right + 2 * cGap + cHeight + 130, cSatisfaction + cHeight));

    p.Graphics.Font.Size := 14;
    p.Graphics.Alignment := gtaLeading;
    p.Graphics.DrawText('Ease of use:', PointF(cLeft, cEaseOfUse));
    p.Graphics.Font.Size := 7;
    p.Graphics.Alignment := gtaCenter;
    r := p.Graphics.DrawText('Very Dissatisfied', RectF(cFieldLeft, cEaseOfUse, cFieldLeft + 40, cEaseOfUse + cHeight));
    p.FormFields.AddRadioGroup(cSatisfactionEaseOfUse, 'EaseOfUseGroup');
    p.FormFields.AddRadioButton('1', RectF(r.Right + cGap, cEaseOfUse, r.Right + cGap + cHeight, cEaseOfUse + cHeight), 'EaseOfUseGroup');
    p.FormFields.AddRadioButton('2', RectF(r.Right + cGap + 25, cEaseOfUse, r.Right + cGap + cHeight + 25, cEaseOfUse + cHeight), 'EaseOfUseGroup');
    p.FormFields.AddRadioButton('3', RectF(r.Right + cGap + 50, cEaseOfUse, r.Right + cGap + cHeight + 50, cEaseOfUse + cHeight), 'EaseOfUseGroup');
    p.FormFields.AddRadioButton('4', RectF(r.Right + cGap + 75, cEaseOfUse, r.Right + cGap + cHeight + 75, cEaseOfUse + cHeight), 'EaseOfUseGroup');
    p.FormFields.AddRadioButton('5', RectF(r.Right + cGap + 100, cEaseOfUse, r.Right + cGap + cHeight + 100, cEaseOfUse + cHeight), 'EaseOfUseGroup');
    p.Graphics.DrawText('Very Satisfied', RectF(r.Right +  2 * cGap + cHeight + 100, cEaseOfUse, r.Right + 2 * cGap + cHeight + 130, cEaseOfUse + cHeight));

    p.Graphics.Font.Size := 14;
    p.Graphics.Alignment := gtaLeading;
    p.Graphics.DrawText('Value for money:', PointF(cLeft, cValueForMoney));
    p.Graphics.Font.Size := 7;
    p.Graphics.Alignment := gtaCenter;
    r := p.Graphics.DrawText('Very Dissatisfied', RectF(cFieldLeft, cValueForMoney, cFieldLeft + 40, cValueForMoney + cHeight));
    p.FormFields.AddRadioGroup(cSatisfactionValueForMoney, 'ValueForMoneyGroup');
    p.FormFields.AddRadioButton('1', RectF(r.Right + cGap, cValueForMoney, r.Right + cGap + cHeight, cValueForMoney + cHeight), 'ValueForMoneyGroup');
    p.FormFields.AddRadioButton('2', RectF(r.Right + cGap + 25, cValueForMoney, r.Right + cGap + cHeight + 25, cValueForMoney + cHeight), 'ValueForMoneyGroup');
    p.FormFields.AddRadioButton('3', RectF(r.Right + cGap + 50, cValueForMoney, r.Right + cGap + cHeight + 50, cValueForMoney + cHeight), 'ValueForMoneyGroup');
    p.FormFields.AddRadioButton('4', RectF(r.Right + cGap + 75, cValueForMoney, r.Right + cGap + cHeight + 75, cValueForMoney + cHeight), 'ValueForMoneyGroup');
    p.FormFields.AddRadioButton('5', RectF(r.Right + cGap + 100, cValueForMoney, r.Right + cGap + cHeight + 100, cValueForMoney + cHeight), 'ValueForMoneyGroup');
    p.Graphics.DrawText('Very Satisfied', RectF(r.Right +  2 * cGap + cHeight + 100, cValueForMoney, r.Right + 2 * cGap + cHeight + 130, cValueForMoney + cHeight));

    p.Graphics.Font.Size := 14;
    p.Graphics.Alignment := gtaLeading;
    p.Graphics.DrawText('Support experience:', PointF(cLeft, cSupport));
    p.Graphics.Font.Size := 7;
    p.Graphics.Alignment := gtaCenter;
    r := p.Graphics.DrawText('Very Dissatisfied', RectF(cFieldLeft, cSupport, cFieldLeft + 40, cSupport + cHeight));
    p.FormFields.AddRadioGroup(cSatisfactionSupport, 'SupportGroup');
    p.FormFields.AddRadioButton('1', RectF(r.Right + cGap, cSupport, r.Right + cGap + cHeight, cSupport + cHeight), 'SupportGroup');
    p.FormFields.AddRadioButton('2', RectF(r.Right + cGap + 25, cSupport, r.Right + cGap + cHeight + 25, cSupport + cHeight), 'SupportGroup');
    p.FormFields.AddRadioButton('3', RectF(r.Right + cGap + 50, cSupport, r.Right + cGap + cHeight + 50, cSupport + cHeight), 'SupportGroup');
    p.FormFields.AddRadioButton('4', RectF(r.Right + cGap + 75, cSupport, r.Right + cGap + cHeight + 75, cSupport + cHeight), 'SupportGroup');
    p.FormFields.AddRadioButton('5', RectF(r.Right + cGap + 100, cSupport, r.Right + cGap + cHeight + 100, cSupport + cHeight), 'SupportGroup');
    p.Graphics.DrawText('Very Satisfied', RectF(r.Right +  2 * cGap + cHeight + 100, cSupport, r.Right + 2 * cGap + cHeight + 130, cSupport + cHeight));

    p.Graphics.Font.Size := 14;
    p.Graphics.Alignment := gtaLeading;
    p.Graphics.DrawText('What did you like the most?', PointF(cLeft, cLikes));
    p.FormFields.AddMemo(cFeedbackPositive, RectF(cLeft, cLikes + 20, cLeft + 400, cLikes + 120));

    p.Graphics.DrawText('What could be improved?', PointF(cLeft, cImprove));
    p.FormFields.AddMemo(cFeedbackImprove, RectF(cLeft, cImprove + 20, cLeft + 400, cImprove + 120));

    p.FormFields.AddCheckBox(cCanContact, RectF(cLeft, cContact, cLeft + cHeight, cContact + cHeight), False);
    p.Graphics.DrawText('You may contact me about this feedback.', PointF(cLeft + cHeight + cGap, cContact));

    p.EndDocument(True);
  finally
    p.Free;
  end;
end;

end.
