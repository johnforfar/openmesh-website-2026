{ pkgs, lib, ... }:
let
  openmesh-website = pkgs.callPackage ./package.nix { };
in {
  users.groups.openmesh-website = { };
  users.users.openmesh-website = {
    isSystemUser = true;
    group = "openmesh-website";
  };

  systemd.services.openmesh-website = {
    description = "Openmesh marketing site";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      HOST = "0.0.0.0";
      PORT = "8080";
      NODE_ENV = "production";
    };
    serviceConfig = {
      ExecStart = "${lib.getExe openmesh-website}";
      User = "openmesh-website";
      Group = "openmesh-website";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
