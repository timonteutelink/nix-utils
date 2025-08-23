{ lib, ... }:
let
  import-files =
    { path ? null
    , paths ? [ ]
    , include ? [ ]
    , exclude ? [ ]
    , filenameRegex ? ".*\\.nix"
    , recursive ? false
    ,
    }:
      with lib;
      with fileset; let
        excludedFiles = filter (path: pathIsRegularFile path) exclude;
        excludedDirs = filter (path: pathIsDirectory path) exclude;
        isExcluded = path:
          if elem path excludedFiles
          then true
          else (filter (excludedDir: lib.path.hasPrefix excludedDir path) excludedDirs) != [ ];

        matchesRegex = path:
          let
            fileName = baseNameOf path;
          in
          builtins.match filenameRegex fileName != null;
      in
      unique (
        (
          filter
            (file: pathIsRegularFile file && matchesRegex file && !isExcluded file)
            (concatMap
              (
                _path:
                if recursive
                then toList _path
                else
                  mapAttrsToList
                    (
                      name: type:
                      _path
                      + (
                        if type == "directory"
                        then "/${name}/default.nix"
                        else "/${name}"
                      )
                    )
                    (builtins.readDir _path)
              )
              (unique (
                if path == null
                then paths
                else [ path ] ++ paths
              )))
        )
        ++ (
          if recursive
          then concatMap (path: toList path) (unique include)
          else unique include
        )
      );
in
{
  inherit import-files;
}

