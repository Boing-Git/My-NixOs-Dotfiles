{ config, pkgs, ... }:

{
  hardware.maccel = {
    enable = true;
    enableCli = true; # Enables command-line tool for runtime parameter adjustment
    parameters = {
      mode = "linear";          # Maccel doesn't have a "jump" mode, but we can simulate it in linear mode with a very high acceleration
      sensMultiplier = 1.0;     # Your baseline sensitivity (Low Sense)
      acceleration = 1000.0;    # Extremely high acceleration to create an instant "jump"
      offset = 15.0;            # Your custom offset (speed before the jump). Adjust this to 10.0 or 15.0 as needed.
      outputCap = 1.5;          # The limit (High Sense) it jumps to
    };
  };
}
