unit UHTMLSamples;

{ The markup of the HTML engine demo, shared by the FMX and the VCL project. }

interface

const
  SampleNames: array[0..6] of string = ('All samples', '4.x markup', 'CSS styling', 'Tables', 'Lists', 'Floats',
    'Theme colours');

function SampleHTML(AIndex: Integer): string;

implementation

const
  S_4X =
    '<b>4.x Mini HTML</b> renders as it always did: <i>italic</i>, <u>underline</u>, ' +
    '<font color="#C00000" size="14">red 14 pt</font>, H<sub>2</sub>O and x<sup>2</sup>, ' +
    '<a href="https://www.tmssoftware.com" title="TMS Software home page">a link</a>.' +
    '<ul><li>first bullet<li>second bullet</ul>';

  S_CSS =
    '<style>.note{color:#1B1B1B;background:#FFF4CE;border:1px solid #E0B000;border-radius:4px;padding:6px;margin:4px 0}' +
    '.note b{color:#8A5A00} h3{margin:2px 0}</style>' +
    '<h3>CSS styling</h3>' +
    '<div class="note"><b>Style sheet:</b> a class selector styles this block, <code>code</code> is monospaced, ' +
    '<mark>mark</mark> highlights.</div>' +
    '<p style="text-align:justify;line-height:1.4">Inline <span style="color:#0F6CBD;font-weight:bold">style</span> ' +
    'attributes, <span style="letter-spacing:2px;text-transform:uppercase">letter spacing</span>, ' +
    '<span style="text-decoration:underline wavy #C00000">wavy underline</span> and a ' +
    '<span style="color:#1B1B1B;background:linear-gradient(90deg,#B3D4FF,#FFD6E0);padding:0 6px">gradient</span>.</p>' +
    '<div style="width:140px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden">A long text that is cut with an ellipsis</div>';

  S_TABLE =
    '<h3>Tables</h3>' +
    '<table border="1" cellpadding="3" cellspacing="0">' +
    '<tr><th>Product<th>Qty<th style="text-align:right">Price' +
    '<tr><td>TMS FNC Core<td align="center">2<td align="right">$199' +
    '<tr><td>TMS FNC UI Pack<td align="center">1<td align="right">$349' +
    '<tr><td colspan="2" style="color:#1B1B1B;background:#E8F0FE"><b>Total</b><td align="right" style="color:#1B1B1B;background:#E8F0FE"><b>$747</b>' +
    '</table>';

  S_LIST =
    '<h3>Lists</h3>' +
    '<ol><li>Numbered<li>Second<ol type="a"><li>nested a<li>nested b</ol><li>Third</ol>' +
    '<ul style="list-style-type:square"><li>Square bullets<li>Another one</ul>' +
    '<dl><dt><b>Term</b><dd>Definition of the term</dl>';

  S_FLOAT =
    '<h3>Floats</h3>' +
    '<div style="float:right;width:90px;color:#1B1B1B;background:#DCEBFF;border:1px solid #6AA0E0;padding:4px;margin:0 0 4px 8px">' +
    'Floated right box</div>' +
    'Text flows around a floated box: the box sits at the right edge and the following lines wrap beside it ' +
    'until the box ends, after which the text uses the full width again.' +
    '<div style="clear:both"></div>';

  S_THEME =
    '<h3>Theme colours</h3>' +
    '<span style="color:theme:accent">Accent</span>, <span style="color:var(--text-secondary)">secondary text</span>, ' +
    '<span style="color:var(--success)">success</span>, <span style="color:var(--warning)">warning</span>, ' +
    '<span style="color:var(--error)">error</span>' +
    '<div style="background:var(--surface-alt);border:1px solid var(--border);padding:6px;margin-top:4px">' +
    'A card on <b>surface-alt</b> with a themed border. Switch the theme and the colours follow.</div>';

function SampleHTML(AIndex: Integer): string;
begin
  case AIndex of
    1: Result := S_4X;
    2: Result := S_CSS;
    3: Result := S_TABLE;
    4: Result := S_LIST;
    5: Result := S_FLOAT;
    6: Result := S_THEME;
  else
    Result := S_4X + S_CSS + S_TABLE + S_LIST + S_FLOAT + S_THEME;
  end;
end;

end.
