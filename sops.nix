{ config, ... }:

{
  sops = {
    age.keyFile = "/home/alice/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.api_keys = {
      sopsFile = ./secrets/api_keys.env;
      format = "dotenv";
      key = "";
      mode = "0444";
      # idk where to put it, really has to be ported to HM instead
      # alternatively, could pass nixos config to hm config as `extraSpecialArgs`
      # path = "${config.users.users.alice.home}/...";
    };
  };
}

