# fixes shell completion installation for zsh

final: prev:

{
  fd = prev.fd.overrideAttrs {
    postInstall = ''
      installManPage doc/fd.1
      installShellCompletion --cmd fd \
        --bash <($out/bin/fd --gen-completions bash) \
        --fish <($out/bin/fd --gen-completions fish) \
        --zsh  <($out/bin/fd --gen-completions zsh)
    '';
  };
}

