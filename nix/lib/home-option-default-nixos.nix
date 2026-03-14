{ lib, ... }:
let
  homeOptionDefaultNixos =
    { description ? "No description provided"
    , inputs ? { }
    , mirror ? null
    , type ? null
    , fallback ? null
    }: (
      let
        osConfig =
          if (builtins.hasAttr "osConfig" inputs && inputs.osConfig != null)
          then inputs.osConfig else null;

        optionDefault = (import ./get-nested-attr.nix { inherit lib; }).get-nested-attr (lib.splitString "." mirror) osConfig;
        fallbackDefault =
          if type == null then
            null
          else if type.check false then
            false
          else if type.check "" then
            ""
          else if type.check [ ] then
            [ ]
          else if type.check { } then
            { }
          else
            null;
      in
      lib.mkOption {
        inherit description type;
        default =
          if optionDefault != null then
            optionDefault
          else if fallback != null then
            fallback
          else
            fallbackDefault;
      }
    );
in
{
  inherit homeOptionDefaultNixos;
}
