{ lib, ... }: {
  aggregate-objects = lib.lists.foldl' lib.recursiveUpdate { };
}


