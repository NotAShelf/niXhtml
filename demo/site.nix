{makePage}:
builtins.toFile "index.html" (makePage {
  title = "Nix SSG Single-Page Feature Showcase";
  doctype = "html5";
  lang = "en";
  meta = {
    viewport = "width=device-width, initial-scale=1.0";
    description = "A single-page demonstration for the Nix Static Site Generator.";
    author = "NotAShelf";
    keywords = "nix, static site, generator, ssg, single page";
  };
  stylesheets = [./assets/style.css];
  scripts = [];
  favicon = null;

  body = {
    div = {
      "@class" = "site-wrapper";
      div = {
        "@class" = "container";
        _fragment = [
          {
            header = {
              "@class" = "site-header";
              "@id" = "top";
              _fragment = [
                {h1 = "niXhtml";}
                {p = "Feature showcase";}
              ];
            };
          }
          {
            main = {
              "@class" = "site-content";
              _fragment = [
                {
                  section = {
                    "@id" = "basics";
                    "@class" = "feature-section basic-elements";
                    _fragment = [
                      {h2 = "Basic Elements & Text";}
                      {p = "Standard HTML tags like paragraphs (p) and headings (h1-h6) are generated from Nix attribute keys.";}
                      {
                        p = {
                          _fragment = [
                            "Inline elements like "
                            {strong = "strong text";}
                            " and "
                            {em = "emphasized text";}
                            " can be nested using "
                            {code = "_fragment";}
                            "."
                          ];
                        };
                      }
                    ];
                  };
                }
                {
                  section = {
                    "@id" = "lists";
                    "@class" = "feature-section lists-section";
                    _fragment = [
                      {h2 = "Lists";}
                      {p = "Unordered (ul) and ordered (ol) lists are generated from Nix lists:";}
                      {
                        ul = [
                          {li = "List Item 1";}
                          {
                            li = {
                              _fragment = [
                                "List Item 2 with a "
                                {code = "code";}
                                " snippet."
                              ];
                            };
                          }
                          {li = "List Item 3";}
                        ];
                      }
                    ];
                  };
                }
                {
                  section = {
                    "@id" = "attributes";
                    "@class" = "feature-section attributes-styling";
                    _fragment = [
                      {h2 = "Attributes & Styling";}
                      {p = "HTML attributes are added using keys prefixed with '@'. Styling is primarily handled via CSS classes linked externally.";}
                      {
                        div = {
                          "@id" = "styled-div";
                          "@class" = "card";
                          _fragment = [
                            "This div uses the "
                            {code = ".card";}
                            " class for styling defined in "
                            {code = "style.css";}
                            "."
                          ];
                        };
                      }
                      {p = "Void elements like images are handled correctly:";}
                      {
                        img = {
                          "@src" = "https://via.placeholder.com/200x100/3498db/ffffff?text=Nix+SSG+Demo";
                          "@alt" = "Placeholder Image";
                        };
                      }
                    ];
                  };
                }
                {
                  section = {
                    "@id" = "special-keys";
                    "@class" = "feature-section special-keys";
                    _fragment = [
                      {h2 = "Special Keys";}
                      {
                        ul = [
                          {
                            li = {
                              _fragment = [
                                {code = "_text";}
                                ": For simple string content, e.g., "
                                {
                                  span = {
                                    "@style" = {color = "green";};
                                    _text = "this span";
                                  };
                                }
                                "."
                              ];
                            };
                          }
                          {
                            li = {
                              _fragment = [
                                {code = "_raw";}
                                ": Injects raw HTML without escaping: "
                                {code = {_raw = "<em>This is raw &amp; unescaped</em>";};}
                                "."
                              ];
                            };
                          }
                          {
                            li = {
                              _fragment = [
                                {code = "_comment";}
                                ": Adds an HTML comment: "
                                {_comment = " This is a generated HTML comment ";}
                                "(view source)."
                              ];
                            };
                          }
                          {
                            li = {
                              _fragment = [
                                {code = "_fragment";}
                                ": Allows mixing text nodes and sibling elements within a parent."
                              ];
                            };
                          }
                        ];
                      }
                    ];
                  };
                }
              ]; # End main _fragment
            }; # End main
          }
          {
            footer = {
              "@class" = "site-footer";
              _fragment = [
                {p = "Generated with niXhtml";}
                {
                  p = {
                    _fragment = [
                      "© "
                      (builtins.substring 0 4 "2025-04-23") # Static year
                      " NotAShelf"
                    ];
                  };
                }
              ];
            }; # End footer
          }
        ]; # End container _fragment
      }; # End container div
    }; # End site-wrapper div
  }; # End body
})
