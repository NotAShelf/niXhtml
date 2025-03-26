{
  description = "Static 'site generator' in pure Nix";
  outputs = {self, ...}: {
    lib = import ./lib;
    examples = {
      # TODO: more examples, ideally multi-page cases and examples
      # using nixpkgs library (or packages) to write pages with a given
      # structure.
      singlepage = import ./examples/single-page.nix {inherit (self.lib) makePage;};
    };
  };
}
