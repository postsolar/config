{ colors, lib }:

let

  faces = {
    # ui
    Default            = "default,rgba:%opt{background}ff";
    PrimarySelection   = "default,rgba:%opt{color0}80";
    SecondarySelection = "default,rgba:%opt{color15}20";
    PrimaryCursor      = "default+r";
    SecondaryCursor    = "default,rgba:%opt{color8}90";
    PrimaryCursorEol   = "default+r";
    SecondaryCursorEol = "default,rgba:%opt{color8}90";
    MenuForeground     = "rgba:%opt{color5}ff,default";
    MenuBackground     = "default,default";
    MenuInfo           = "default,default";
    Information        = "rgba:%opt{color15}ff,default";
    InlineInformation  = "rgba:%opt{color15}ff,default";
    Error              = "rgba:%opt{color5}ff,default";
    DiagnosticError    = "rgba:%opt{color5}ff,default";
    DiagnosticHint     = "rgba:%opt{color5}ff,default";
    DiagnosticInfo     = "rgba:%opt{color5}ff,default";
    DiagnosticWarning  = "rgba:%opt{color3}ff,default";
    StatusLine         = "rgba:%opt{color15}ff,default";
    StatusLineMode     = "rgba:%opt{color15}ff,default";
    StatusLineInfo     = "rgba:%opt{color15}ff,default";
    StatusLineValue    = "rgba:%opt{color15}ff,default";
    StatusCursor       = "rgba:%opt{color7}ff,default+r";
    Prompt             = "rgba:%opt{color1}ff,default";
    BufferPadding      = "Whitespace";
    LineNumbers        = "rgba:%opt{color0}ff,default";
    LineNumberCursor   = "rgba:%opt{color9}ff,default";
    LineNumbersWrapped = "rgba:%opt{color0}ff,default";
    MatchingChar       = "rgba:%opt{color3}ff,default+r";
    Whitespace         = "rgba:%opt{color0}ff,default";
    WrapMarker         = "Whitespace";
    Search             = "default,rgba:%opt{color13}20+u";

    # code
    argument      = "rgba:%opt{color8}ff,default+i";
    attribute     = "rgba:%opt{color6}ff,default+i";
    bracket       = "rgba:%opt{color15}ff,default";
    builtin       = "attribute";
    class         = "rgba:%opt{color9}ff,default";
    comma         = "bracket";
    comment       = "rgba:%opt{color0}ff,default+i";
    constant      = "builtin";
    docstring     = "comment";
    documentation = "comment";
    error         = "rgba:%opt{color1}ff,rgba:%opt{color0}ff";
    enum          = "rgba:%opt{color1}ff,default";
    equal         = "operator";
    function      = "rgba:%opt{color2}ff,default";
    identifier    = "rgba:%opt{color1}ff,default+i";
    keyword       = "rgba:%opt{color5}ff,default";
    meta          = "identifier";
    module        = "rgba:%opt{color10}ff,default";
    operator      = "rgba:%opt{color1}ff,default";
    parameter     = "identifier";
    string        = "rgba:%opt{color9}ff,default";
    type          = "rgba:%opt{color3}ff,default+i";
    value         = "rgba:%opt{color5}ff,default";
    variable      = "identifier";

    # text
    block  = "rgba:%opt{color5}ff,default";
    bold   = "default,default+b";
    bullet = "rgba:%opt{color9}ff,default";
    header = "rgba:%opt{color2}ff,default";
    italic = "default,default+i";
    link   = "rgba:%opt{color2}ff,default+iu";
    list   = "rgba:%opt{color15}ff,default";
    mono   = "rgba:%opt{color14}ff,default";
    title  = "rgba:%opt{color8}ff,default+b";

  };

  declareColor = name: color:
    "try %{ declare-option str ${name} '${color}' }";

  inherit (lib.attrsets) mapAttrsToList;

  unlines = lib.strings.concatStringsSep "\n";

  toFace = f: v: "set-face global ${f} \"${v}\"";

  setFaces = fs: unlines (mapAttrsToList toFace fs);

in

  ''
  ${ unlines (mapAttrsToList declareColor colors) }

  ${ setFaces faces }
  ''

