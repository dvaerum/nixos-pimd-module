{ lib
, pkgs
, ...
}: let

  inherit (lib)
    mkEnableOption
    mkOption
    literalExpression
  ;

  inherit (lib.types)
    str
    path
    package
    enum
    listOf
    attrTag
  ;

in {
  imports = [];
  options = {
    services.pimd = {
      enable = mkEnableOption "PIMD";

      package = mkOption {
        type = package;
        default = pkgs.pimd;
        defaultText = literalExpression "pkgs.pimd";
        description = "The hello package to use.";
      };

      settings = mkOption {
        description = '''';
        default = {};
        type = attrTag {
          interfaces = mkOption {
            description = '''';
            default = {};
            # To-do move the uppercase change here, because PIMD does not suppport interface names using uppercase
            type = listOf str;
          };
        };
      };

      debug = mkOption {
        description = '''';
        default = [];
        type = listOf (enum [
          "dvmrp_detail" "dvmrp_prunes" "dvmrp_pruning" "dvmrp_routes"
          "dvmrp_routing" "dvmrp_mrt" "dvmrp_neighbors" "dvmrp_peers"
          "dvmrp_hello" "dvmrp_timers" "dvmrp" "igmp_proto" "igmp_timers"
          "igmp_members" "groups" "membership" "igmp" "trace" "mtrace"
          "traceroute" "timeout" "callout" "packets" "pkt" "interfaces"
          "vif" "kernel" "cache" "mfc" "k_cache" "k_mfc" "rsrr"
          "pim_detail" "pim_hello" "pim_neighbors" "pim_peers"
          "pim_register" "registers" "pim_join_prune" "pim_j_p" "pim_jp"
          "pim_bootstrap" "pim_bsr" "bsr" "bootstrap" "pim_asserts"
          "pim_cand_rp" "pim_c_rp" "pim_rp" "rp" "pim_routes"
          "pim_routing" "pim_mrt" "pim_timers" "pim_rpf" "rpf" "pim"
          "routes" "routing" "mrt" "neighbors" "routers" "mrouters"
          "peers" "timers" "asserts" "all" "3"
        ]);
      };
    };
  };
}
