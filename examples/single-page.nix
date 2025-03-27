{makePage, ...}:
builtins.toFile "index.html" (makePage {
  title = "nsg";
  lang = "en";
  doctype = "xhtml";
  stylesheets = [./assets/styles.css];
  scripts = [];
  meta = {
    description = "nsg: nix site generator, or; not a site generator";
    keywords = "nix, static site, generator";
    author = "NotAShelf";
    viewport = "width=device-width, initial-scale=1.0";
  };
  favicon = "favicon.ico";
  body = {
    div = {
      "@class" = "site-wrapper";

      div = {
        "@class" = "container";

        _fragment = [
          {
            header = {
              "@class" = "site-header";
              h1 = {
                "@class" = "site-title";
                _text = "Welcome to the Nix Site";
              };
              nav = {
                "@class" = "main-nav";
                ul = [
                  {
                    li = {
                      a = {
                        "@href" = "index.xhtml";
                        "@class" = "active";
                        _text = "Home";
                      };
                    };
                  }
                  {
                    li = {
                      a = {
                        "@href" = "about.xhtml";
                        _text = "About";
                      };
                    };
                  }
                  {
                    li = {
                      a = {
                        "@href" = "contact.xhtml";
                        _text = "Contact";
                      };
                    };
                  }
                ];
              };
            };
          }

          {
            main = {
              "@class" = "site-content";
              _fragment = [
                {
                  div = {
                    "@class" = "intro-section";
                    p = ''
                      This page was generated purely in Nix. I didn't know that was possible, but now <em>you</em> do.

                      Honestly, you might even be able to <i>inline some HTML here</i>
                    '';
                  };
                }
                {_comment = "This is an HTML comment. You should see this in the site source";}
                {
                  section = {
                    "@class" = "features-section";
                    h2 = "Features";
                    ul = [
                      {
                        li = {
                          "@class" = "feature-item";
                          _text = "Fast (lie)";
                        };
                      }
                      {
                        li = {
                          "@class" = "feature-item";
                          _text = "Reproducible";
                        };
                      }
                      {
                        li = {
                          "@class" = "feature-item";
                          _text = "Minimalist";
                        };
                      }
                    ];
                  };
                }
                {
                  div = {
                    "@class" = "logo-container";
                    img = {
                      "@src" = "nix-logo.png";
                      "@alt" = "Nix Logo";
                      "@width" = "200";
                      "@height" = "100";
                    };
                  };
                }
              ];
            };
          }

          {
            footer = {
              "@class" = "site-footer";
              p = {
                _text = "© 2025 nsg";
              };
            };
          }
        ];
      };
    };
  };
})
