{ footKeysAttrSet, lib }:

let
  writeKeyAndSequence = k: seq: "  ${k}  '${seq}'";

  # pre-escape the only apostrophe char
  footKeysAttrSet' = footKeysAttrSet // { a-apostrophe = "^[\\x27"; };

  keys =
    builtins.concatStringsSep "\n"
      ( lib.attrsets.mapAttrsToList
          writeKeyAndSequence
          footKeysAttrSet'
      );
in

''
typeset -gA keys=(
${keys}
)
''

