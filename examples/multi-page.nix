{makeSite}:
makeSite {
  pages = {
    index = {
      title = "Home";
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
    };

    about = {
      title = "About";
      doctype = "xhtml";
      stylesheets = [./assets/styles.css];
      meta = {
        description = "About nsg";
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
                    _text = "About nsg";
                  };
                  nav = {
                    "@class" = "main-nav";
                    ul = [
                      {
                        li = {
                          a = {
                            "@href" = "index.xhtml";
                            _text = "Home";
                          };
                        };
                      }
                      {
                        li = {
                          a = {
                            "@href" = "about.xhtml";
                            "@class" = "active";
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
                        "@class" = "about-content";
                        h2 = "About This Project";
                        p = ''
                          nsg is a minimal HTML generation library
                          written purely in Nix. It demonstrates how Nix's expression
                          language can be used beyond package management.
                        '';
                      };
                    }
                    {
                      div = {
                        "@class" = "tech-stack";
                        h3 = "Technology";
                        p = "Built with 100% pure Nix. No external dependencies.";
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
    };

    contact = {
      title = "Contact";
      doctype = "xhtml";
      stylesheets = [./assets/styles.css];
      meta = {
        description = "Contact nsg";
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
                    _text = "Contact Us";
                  };
                  nav = {
                    "@class" = "main-nav";
                    ul = [
                      {
                        li = {
                          a = {
                            "@href" = "index.xhtml";
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
                            "@class" = "active";
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
                        "@class" = "contact-form";
                        h2 = "Get In Touch";
                        form = {
                          "@action" = "#";
                          "@method" = "post";
                          _fragment = [
                            {
                              div = {
                                "@class" = "form-group";
                                label = {
                                  "@for" = "name";
                                  _text = "Name:";
                                };
                                input = {
                                  "@type" = "text";
                                  "@id" = "name";
                                  "@name" = "name";
                                  "@required" = "required";
                                };
                              };
                            }
                            {
                              div = {
                                "@class" = "form-group";
                                label = {
                                  "@for" = "email";
                                  _text = "Email:";
                                };
                                input = {
                                  "@type" = "email";
                                  "@id" = "email";
                                  "@name" = "email";
                                  "@required" = "required";
                                };
                              };
                            }
                            {
                              div = {
                                "@class" = "form-group";
                                label = {
                                  "@for" = "message";
                                  _text = "Message:";
                                };
                                textarea = {
                                  "@id" = "message";
                                  "@name" = "message";
                                  "@rows" = "5";
                                  "@required" = "required";
                                  _text = "";
                                };
                              };
                            }
                            {
                              button = {
                                "@type" = "submit";
                                _text = "Send Message";
                              };
                            }
                          ];
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
    };
  };
}
