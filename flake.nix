
{
  description = "Personal overlay";

  outputs = { self }: {
    overlays.default = import ./default.nix;
  };
}