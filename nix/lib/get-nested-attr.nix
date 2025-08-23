{ ... }: rec {
  get-nested-attr = path: obj:
    if path == [ ] then obj
    else if obj == null || !(builtins.isAttrs obj) then null
    else
      let
        key = builtins.head path;
        remainingPath = builtins.tail path;
      in
      if builtins.hasAttr key obj
      then get-nested-attr remainingPath (builtins.getAttr key obj)
      else null;
}


