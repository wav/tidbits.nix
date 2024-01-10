# mergeLibsInOrder allows us to have lib.namespace.Z depend on lib.namespace.Y if lib.namespace.Y appears first
# in a list of builders:
# [
#   (pkgs: { Y = ... })
#   (pkgs: { Z = { a = pkgs.lib.namespace.Y })
# ]
namespace: prev: builders:
with builtins;
let
  final =
    foldl'
      (pkgs: builder:
        let
          namespacedLib = if hasAttr namespace pkgs.lib then pkgs.lib.${namespace} else { };
          libNoNamespacedLib = if hasAttr namespace pkgs.lib then removeAttrs pkgs.lib [ namespace ] else pkgs.lib;
          pkgsNoLib = removeAttrs pkgs [ "lib" ];
          updatedNamespacedLib = (namespacedLib // builder pkgs);
          lib = libNoNamespacedLib // { ${namespace} = updatedNamespacedLib; };
        in
        pkgsNoLib // { inherit lib; })
      prev
      builders;
in
assert (hasAttr namespace final.lib);
final.lib
