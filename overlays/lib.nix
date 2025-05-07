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


  /*
   *  Wrap a package with a function from a package's path to a script to be executed.
   *
   *  Usage example:
   *
   *  ```nix
   *  package = pkgs.wrapPackage pkgs.kitty (kitty:
   *    ''
   *    #! ${pkgs.stdenv.shell}
   *      if [[ "\$1" == "-e" ]]; then
   *        shift
   *        exec ${kitty} --session=none "\$@"
   *      else
   *        exec ${kitty} "\$@"
   *      fi
   *    ''
   *  );
   *  ```
  */
  wrapPackage = package: f:
    let
      binary =
        package.meta.mainProgram
          or (final.lib.warn ''wrapPackage: package "${package.name}" does not have the meta.mainProgram attribute.''
            (builtins.parseDrvName package.name).name)
          ;
    in
      final.pkgs.symlinkJoin {
        name = "${package.name}-wrapped";
        paths = [ package ];
        postBuild = ''
          printf "Wrapping %s\n" "${package.name}"
          rm -- "$out/bin/${binary}"
          cat << '_EOF' > "$out/bin/${binary}"
          ${ f "${package}/bin/${binary}" }
          _EOF
          chmod 555 "$out/bin/${binary}"
        '';
      };

  functions = {
    apply = f: a: f a;
  };

  writers = prev.writers // {

    /**
      Same as `pkgs.writers.writeJSBin`, but allows TypeScript and uses Bun as the interpreter.
    */
    writeTS =
      name:
      {
        libraries ? [ ],
      }:
      content:
      let
        bun-env = final.pkgs.buildEnv {
          name = "bun-env";
          paths = libraries;
          pathsToLink = [ "/lib/node_modules" ];
        };
      in
      final.writers.writeDash name ''
        export NODE_PATH=${bun-env}/lib/node_modules
        exec ${final.lib.getExe final.pkgs.bun} ${final.pkgs.writeText "ts" content} "$@"
      '';

    /**
      writeTSBin takes the same arguments as writeTS but outputs a directory (like writeScriptBin)
    */
    writeTSBin =
      name: final.writers.writeTS "/bin/${name}";

  };

}

