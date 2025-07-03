{ config
, lib
, pkgs
, ...
}: let

  cfg = config.services.pimd;
  config_file_path = pkgs.writeText "pimd.conf"
    ( lib.strings.concatLines (
        ( lib.lists.forEach
          cfg.settings.interfaces
          (interface: if (builtins.match ".*([A-Z]).*" interface) == null
                      then "phyint ${interface} enable"
                      else throw ''
                        The network interface name `${interface}` is invalied.
                        `pimd` does not allow uppercase letters in the interface name.
                      '')
        ) ++ [
          "bsr-candidate priority 5"
          "rp-candidate time 30 priority 20"
          "spt-threshold packets 0 interval 100"
        ]
      )
    );

in (
  lib.mkIf cfg.enable {
    environment.etc."pimd.conf" = {
      enable = true;
      source = "${config_file_path}";
    };

    systemd.services."pimd" = {
      enable = true;

      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      description = '''';
      serviceConfig = {
        Type = "simple";
        ExecStart =
          ''${cfg.package}/bin/pimd --disable-vifs --foreground --config /etc/pimd.conf'' +
          ( lib.optionalString (lib.length cfg.debug > 0)
            " --debug=${lib.concatStringsSep "," cfg.debug}"
          );
        ExecReload = ''${cfg.package} --reload-config --config /etc/pimd.conf'';
        Restart = "always";
        RestartSec = 5;
      };
    };

    systemd.network.wait-online.ignoredInterfaces = [ "pimreg" ];
    networking.networkmanager.unmanaged = [ "pimreg" ];
  }
)
