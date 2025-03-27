{
  description = "Static 'site generator' in pure Nix";
  outputs = {self, ...}: {
    lib = import ./lib;
    examples = {
      # Single-page example containing one page with a minimal stylesheet.
      singlepage = import ./examples/single-page.nix {inherit (self.lib) makePage;};

      multipage = import ./examples/multi-page.nix {inherit (self.lib) makeSite;};
    };
  };
}
