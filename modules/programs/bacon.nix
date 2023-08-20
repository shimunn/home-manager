{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.bacon;

  package = pkgs.bacon;
  settingsFormat = pkgs.formats.toml { };
in {
  meta.maintainers = [ maintainers.shimunn ];

  options.programs.bacon = {
    enable = mkEnableOption "background rust code check";

    preferences = mkOption {
      type = settingsFormat.type;
      example = {
        jobs.default = {
          command = [ "cargo" "build" "--all-features" "--color" "always" ];
          need_stdout = true;
        };
      };
      description = ''
        Bacon configuration.
        for available settings see https://dystroy.org/bacon/#global-preferences
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ package ];

    xdg.configFile."bacon/prefs.toml".source =
      settingsFormat.generate "prefs.toml" cfg.preferences;
  };
}
