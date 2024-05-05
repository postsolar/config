final: prev: {

  zsh = prev.zsh.overrideAttrs (o: rec {
    version = "5.9.0.1-dev";
    src = prev.pkgs.fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh";
      rev = "b727b74fe23c532050b959fe4ce0382c7213af6b";
      hash = "sha256-Kozmd6twYd5WitPvqi8izX1lpvOPcuTengnll7d6bEw=";
    };
    patches = [];
    preConfigure = "";
    # pcre was replaced with pcre2
    nativeBuildInputs = o.nativeBuildInputs ++ [ prev.pkgs.pcre2 ];

    # not sure why but the build fails without changing a couple lines in
    # the end of the original postInstall script
    postInstall = ''
      make install.info install.html
      mkdir -p $out/etc/
      cat > $out/etc/zshenv <<EOF
      if test -e /etc/NIXOS; then
        if test -r /etc/zshenv; then
          . /etc/zshenv
        else
          emulate bash
          alias shopt=false
          if [ -z "\$__NIXOS_SET_ENVIRONMENT_DONE" ]; then
            . /etc/set-environment
          fi
          unalias shopt
          emulate zsh
        fi
        if test -r /etc/zshenv.local; then
          . /etc/zshenv.local
        fi
      else
        # on non-nixos we just source the global /etc/zshenv as if we did
        # not use the configure flag
        if test -r /etc/zshenv; then
          . /etc/zshenv
        fi
      fi
      EOF

      rm $out/bin/zsh-${version}
      mkdir -p $out/share/doc/
      mv $out/share/zsh/htmldoc $out/share/doc/zsh-$version
      '';

  });

}

