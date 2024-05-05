final: prev:

{

  /*
    Same as `pkgs.writeShellApplication`, but uses ZSH instead of Bash.
  */
  writeZshApplication =
    { name
    , text
    , runtimeInputs ? []
    , meta ? {}
    , checkPhase ? null
    }:
      final.writeTextFile {
        inherit name meta;
        executable = true;
        destination = "/bin/${name}";
        allowSubstitutes = true;
        preferLocalBuild = false;
        text =
          let
            ifHasDeps = final.lib.optionalString (runtimeInputs != []);
            deps = final.lib.makeBinPath runtimeInputs;
          in
          ''
          #! ${final.zsh}/bin/zsh

          setopt errexit nounset pipefail

          ${ ifHasDeps ''path+=(''${(s.:.)''${:-"${deps}"}})'' }

          ${text}
          '';

        checkPhase =
          if checkPhase == null then
            ''
            runHook preCheck
            ${final.zsh}/bin/zsh -n "$target"
            runHook postCheck
            ''
          else
            checkPhase;
      };

}

