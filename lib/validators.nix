_: let
  inherit
    (builtins)
    filter
    hasAttr
    ;
  ifTheyExist = config: groups: filter (group: hasAttr group config.users.groups) groups;
in {
  inherit ifTheyExist;
}
