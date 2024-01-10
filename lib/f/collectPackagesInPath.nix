# collect packages under a path into an attrset
lib: callPackage: packagePath:
with builtins;
let
  pkgNames =
    (filter
      (n: pathExists (packagePath + ("/" + n + "/default.nix")))
      (attrNames (readDir packagePath)));
in
foldl'
  (pathPkgs: n: pathPkgs // {
    "${n}" = callPackage (packagePath + ("/" + n)) { inherit lib; };
  })
{ }
  pkgNames
