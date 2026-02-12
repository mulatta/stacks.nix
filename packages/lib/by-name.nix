# Resolve a package name to its by-name path.
# e.g. "paper-qa" -> ../by-name/pa/paper-qa/package.nix
name:
let
  firstTwo = builtins.substring 0 2 name;
in
../by-name + "/${firstTwo}/${name}/package.nix"
