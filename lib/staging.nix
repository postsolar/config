# wrapPackage :: Package -> (String -> String) -> Package
#
# Given a package and a function that takes a string and returns a string, override the package
# to wrap all the main program in the package with the string transformation function.
# The string argument to the inner function is the path to the unwrapped binary.
# Ex.
# wrapPackage hello (x: "echo $x")
wrapPackage = package: f:
  let
    binary = package.meta.mainProgram or
      (lib.warn ''wrapPackage: package "${package.name}" does not have the meta.mainProgram attribute.''
        (builtins.parseDrvName package.name).name);
  in
    pkgs.symlinkJoin {
      name = "${package.name}-wrapped";
      paths = [ package ];
      postBuild = ''
        echo "Wrapping ${package.name}"
        rm "$out/bin/${binary}"
        cat << _EOF > $out/bin/${binary}
        ${ f "${package}/bin/${binary}" }
        _EOF
        chmod 555 "$out/bin/${binary}"
      '';
    };

# usage example
package = pkgs.wrapPackage pkgs.kitty (kitty:
  ''
  #! ${pkgs.stdenv.shell}
    if [[ "\$1" == "-e" ]]; then
      shift
      exec ${kitty} --session=none "\$@"
    else
      exec ${kitty} "\$@"
    fi
  ''
);

# ...versus...
programs.kitty = {
  enable = true;
  # The -e flag doesn't work when a startup_session is specified.
  # This disgusting hack is needed to keep backwards compatibility with
  # xterm. i3-sensible-terminal uses the -e flag to execute a command.
  package = let
    kitty = pkgs.kitty;
  in pkgs.symlinkJoin {
    name = "kitty";
    paths = [ kitty ];
    postBuild = ''
      rm "$out/bin/kitty"
      cat << EOF > "$out/bin/kitty"
      #!${pkgs.stdenv.shell}

      if [[ "\$1" == "-e" ]]; then
        shift
        exec ${lib.getExe kitty} --session=none "\$@"
      else
        exec ${lib.getExe kitty} "\$@"
      fi

      EOF
      chmod +x "$out/bin/kitty"
    '';
  };

