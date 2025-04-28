{makePage}:
builtins.toFile "index.html" (makePage {
  title = "niXhtml Feature Showcase";
  doctype = "html5";
  lang = "en";
  meta = {
    viewport = "width=device-width, initial-scale=1.0";
    description = "A single-page demonstration for niXhtml static site generator";
    author = "NotAShelf";
    keywords = "nix, static site, generator, ssg, single page";
  };
  stylesheets = ["style.css"];
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
                      {
                        p = ''
                          niXhtml is a pure, reproducible Nix library for generating static documents using Nix and nothing
                          but Nix; no Bash, no hacks and not even a dependency on nixpkgs.lib.

                          The HTML documents (including in-line styles) can be created using ONLY Nix. The helper functions
                          also allow using a stylesheet path if you wish to do yourself a favor and use a stylesheet written
                          in CSS and not Nix. Though, the point remains that niXhtml is created using ONLY Nix builtins and
                          allows for PURE nix websites. No takesies backsies.
                        '';
                      }
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
                          {
                            ul = [
                              {li = "This is a nested list item";}
                              {
                                li._fragment = [
                                  {code = {_raw = "<em>Raw HTML inside a nested list!</em>";};}
                                ];
                              }
                            ];
                          }
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
                      {
                        p = ''
                          HTML attributes are added using keys prefixed with '@'. Styling is primarily handled via CSS classes linked externally.
                        '';
                      }
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
                      "© 2025 NotAShelf"
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
