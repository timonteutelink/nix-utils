{ lib, ... }:
let
  import-folders =
    { path ? null }:
    let
      entries = builtins.readDir path;
      directoryEntries = lib.filterAttrs (name: type: type == "directory") entries;
      directoryNames = lib.attrNames directoryEntries;
    in
    directoryNames;
in
{
  inherit import-folders;
}

