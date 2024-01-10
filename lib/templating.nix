{ pkgs }:

with builtins;
with pkgs.lib.tidbits.yants;

let
  inherit (pkgs) lib;

  values = struct "values" {
    data = option any;
    yaml = option path;
  };

  yamlFormat = pkgs.formats.yaml { };

in
{

  writeGoTemplateFile =
    defun [ string path values drv ] (name: template: values:
      let
        valuesYaml =
          if hasAttr "yaml" values then values.yaml
          else yamlFormat.generate "${name}.values.yaml" values.data;
      in
      pkgs.runCommand name { }
        "cat \"${template}\" | ${pkgs.gotemplate}/bin/gotemplate -I -P --import \"${valuesYaml}\" > $out");

}
