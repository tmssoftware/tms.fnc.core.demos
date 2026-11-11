unit UHTMLSamples;

{ The markup of the HTML engine demo, shared by the FMX, VCL and WEB projects. }

interface

const
  SampleNames: array[0..9] of string = ('All samples', '4.x markup', 'CSS styling', 'Tables', 'Lists', 'Floats',
    'Theme colours', 'RTL text', 'Inline image', 'Rowspan');

function SampleHTML(AIndex: Integer): string;

{ HTML for the cache section: live counts from the global HTML cache.
  ADocCount, ADocBytes, ADocHits, ADocMisses: values read from HTMLCache.Documents by the caller. }
function CacheHTML(ADocCount, ADocBytes, ADocHits, ADocMisses: Integer): string;

implementation

uses
  System.SysUtils;

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

  S_RTL =
    '<h3>RTL text</h3>' +
    '<div dir="rtl" style="border:1px solid #AAAAAA;border-radius:4px;padding:8px;margin-bottom:6px;line-height:1.6">' +
    '<p style="margin:0 0 4px 0"><b>&#x0639;&#x0646;&#x0648;&#x0627;&#x0646; &#x0628;&#x0627;&#x0644;&#x0639;&#x0631;&#x0628;&#x064A;&#x0629;</b></p>' +
    '&#x0647;&#x0630;&#x0627; &#x0646;&#x0635; &#x0628;&#x0627;&#x0644;&#x0644;&#x063A;&#x0629; &#x0627;&#x0644;&#x0639;&#x0631;&#x0628;&#x064A;&#x0629; ' +
    '&#x064A;&#x0633;&#x064A;&#x0631; &#x0645;&#x0646; &#x0627;&#x0644;&#x064A;&#x0645;&#x064A;&#x0646; &#x0625;&#x0644;&#x0649; &#x0627;&#x0644;&#x064A;&#x0633;&#x0627;&#x0631;.' +
    '</div>' +
    '<p style="font-size:11px;color:#606060">The HTML engine lays out right-to-left paragraphs (<code>dir="rtl"</code>) with ' +
    'correct Unicode bidi: Arabic text above, list markers on the right below.</p>' +
    '<ul dir="rtl">' +
    '<li>&#x0639;&#x0646;&#x0635;&#x0631; &#x0623;&#x0648;&#x0644;</li>' +
    '<li>&#x0639;&#x0646;&#x0635;&#x0631; &#x062B;&#x0627;&#x0646;&#x064A;</li>' +
    '<li>&#x0639;&#x0646;&#x0635;&#x0631; &#x062B;&#x0627;&#x0644;&#x062B;</li>' +
    '</ul>';

  { A 32x32 blue gradient circle as a data: PNG (base64). }
  IMG_DATA = 'data:image/png;base64,' +
    'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAACgUlEQVR42tXW2UtVURQG8PM3NUlRVDQH' +
    'EQ00CE3kWGmomWVCiCZqQVYUGUFBUQTRSwQ99ORT3q5ZalRipZg0R2JED0H+rhc2dgsa6Bzqsh72Wuv7' +
    '1rjPuSf6GvMv+icSTCm4PbWwc1pR5/TijDhQGf9CArHySlMzd6Zn7UrPLu8KQmXkAvjDBGrMK70j0Jzd' +
    'd+dVds+vureg+n4QKiMXABjw7yUwBwXiC7Rwb8/ifb1La/uW1z0IQmXkAgADRvnVBDNKUuqaW9Gt0iX7' +
    'e4VbcfDhyvpHqxoer27MiAOVkQsADBgF8ecJFAKq/UU1PcsO9Iki3Nqm/nXNAxtan2w8nBEHKiMXABgw' +
    'CuL3fUQ5c9eschBUp8w1h/rXtwzkH3m66eizLccGtx4fIg5URi4AMGAURPScfXyTwLoMVMuKQlOjesXa' +
    'dmKo4NRw0ennxe0jxIHKyAUABoyCiC7IjxO4cHq0NGPVuNKQN7cNbj85LOiOsy/Kzr0sP/+KOFAZuQDA' +
    'gFEQ0QWZfHejSeWn5Hcx9Gu42legECVnRkSsuPB6z6W31ZffEQcqIxcAGDAKIvpEE6ncBB5L47Mol08t' +
    'ujZiQ1CmQJUX39RceV979UPdtVHiQGXkAgADRkFEF0So8JxHYb3Z+bjgBuqSqMugjUKxwolbf32s4cZH' +
    '4kBl5AIAA0ZBRM9OKaw6CgvwArCl7HxcRFfFMtVoIEoWtOnmp9Zbn4kDlZELAAwYJTslQYQKa4jC9Q8J' +
    'PEr25jpq30oNXb0KF7qt4wtxoDJyAYABoyCGBOGBSCpB7COKfcmxX9PYH7QkXhWxv+ySeF3H/oeTxF9m' +
    'En/6SXy2JPHhldCn43/wdT0OJTDWnSRIQYAAAAAASUVORK5CYII=';

  S_IMAGE =
    '<h3>Inline image (<code>data:</code> URI)</h3>' +
    '<p style="margin-bottom:6px">The <code>&lt;img src="data:image/png;base64,..."&gt;</code> form embeds a raster ' +
    'image directly in the markup. The engine decodes it once and caches the result.</p>' +
    '<p><img src="' + IMG_DATA + '" width="32" height="32" alt="blue circle" style="vertical-align:middle"> ' +
    'A 32&times;32 blue gradient circle, inline next to this text. ' +
    '<img src="' + IMG_DATA + '" width="16" height="16" alt="small" style="vertical-align:middle"> ' +
    'The same image at 16&times;16 (the cache serves it again).</p>';

  S_ROWSPAN =
    '<h3>Rowspan and colspan</h3>' +
    '<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse">' +
    '<tr>' +
    '  <th rowspan="3" style="background:#E8F0FE;vertical-align:middle">FNC Core</th>' +
    '  <td><b>HTML engine</b></td>' +
    '  <td>Parse, layout, paint, hit-test, PDF export</td>' +
    '</tr>' +
    '<tr>' +
    '  <td><b>Theme engine</b></td>' +
    '  <td>Tokens, bindings, styles manager, theme-from-style</td>' +
    '</tr>' +
    '<tr>' +
    '  <td><b>Data links</b></td>' +
    '  <td>CSV, JSON, DB, master-detail, indexed paths</td>' +
    '</tr>' +
    '<tr>' +
    '  <th rowspan="2" style="background:#E8F0FE;vertical-align:middle">FNC UI Pack</th>' +
    '  <td><b>Controls</b></td>' +
    '  <td>Grid, TreeView, Planner, Chart, Calendar, &hellip;</td>' +
    '</tr>' +
    '<tr>' +
    '  <td><b>DataGrid</b></td>' +
    '  <td colspan="1">Virtualized, bound, editable, filtered, paged</td>' +
    '</tr>' +
    '</table>';

function SampleHTML(AIndex: Integer): string;
begin
  case AIndex of
    1: Result := S_4X;
    2: Result := S_CSS;
    3: Result := S_TABLE;
    4: Result := S_LIST;
    5: Result := S_FLOAT;
    6: Result := S_THEME;
    7: Result := S_RTL;
    8: Result := S_IMAGE;
    9: Result := S_ROWSPAN;
  else
    Result := S_4X + S_CSS + S_TABLE + S_LIST + S_FLOAT + S_THEME + S_RTL + S_IMAGE + S_ROWSPAN;
  end;
end;

function CacheHTML(ADocCount, ADocBytes, ADocHits, ADocMisses: Integer): string;
begin
  Result :=
    '<h3>HTML engine cache</h3>' +
    '<p style="font-size:11px;color:#606060;margin-bottom:6px">' +
    'The global LRU cache keeps parsed documents, styled trees, layouts, fonts and images. ' +
    'Counts update each time you switch to this sample.</p>' +
    '<table border="0" cellpadding="3" cellspacing="0" style="border-collapse:collapse;font-size:12px">' +
    '<tr><td style="color:#606060">Documents cached</td>' +
      '<td style="font-weight:bold;padding-left:12px">' + IntToStr(ADocCount) + '</td></tr>' +
    '<tr><td style="color:#606060">Document bytes used</td>' +
      '<td style="font-weight:bold;padding-left:12px">' + IntToStr(ADocBytes) + '</td></tr>' +
    '<tr><td style="color:#606060">Cache hits</td>' +
      '<td style="font-weight:bold;padding-left:12px;color:var(--success)">' + IntToStr(ADocHits) + '</td></tr>' +
    '<tr><td style="color:#606060">Cache misses</td>' +
      '<td style="font-weight:bold;padding-left:12px;color:var(--warning)">' + IntToStr(ADocMisses) + '</td></tr>' +
    '</table>' +
    '<p style="font-size:11px;color:#606060;margin-top:6px">' +
    'Press <b>Clear cache</b> above to call <code>ClearHTMLCache</code> and watch the counts reset.</p>';
end;

end.
