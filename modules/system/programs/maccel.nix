{ config, pkgs, ... }:

{
  hardware.maccel = {
    enable = true;
    enableCli = true; # Enables command-line tool for runtime parameter adjustment
    parameters = {
      mode = "linear";          # "linear" or other RawAccel-like curves
      sensMultiplier = 1.0;     # Your baseline sensitivity modifier
      acceleration = 0.3;       # Acceleration rate
      offset = 2.0;             # Input offset in raw counts
      outputCap = 2.0;          # Cap on the final acceleration multiplier
    };
  };
}
