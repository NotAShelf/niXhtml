<h1 id="header" align="center">
  niXhtml
</h1>

Have you ever wanted to write your own website using Nix, and nothing but Nix?
Maybe some CSS and JS, but rest in full Nix. Have you?

If you have answered yes, I have good and bad news for you. Good news is that
this project is exactly that. It produces XHTML documents entirely from Nix code
with some degree of customization for your weirdest fantasies. Bad news, which I
am sorry to report, are that you are in dire need of some professional help.
What kind of a psycho wants to website in _Nix_? Just write HTML for heavens'
sake.

A very good question would be "why did you do this?" Well, honestly, I don't
really know but it sounded funny at the time. Now I'm debating if I can re-write
my own personal webpage using just Nix through **niXhtml**. Can I? Yeah,
probably.

## Usage

1. Write Nix
2. Pass it to `makePage` or `makeSite` functions
3. Watch the fireworks (they're in your head)

> [!NOTE] The standard `toXML` doesn't really do what we want here, and XHTML
> doesn't _appear_ to be fully structable using just that. For this reason, I've
> created a standalone function (which doesn't depend on `nixpkgs.lib`) that
> takes a set and creates structured XHTML. You can write the file somewhere
> with `toFile` (or using `nixpkgs.lib`) to serve the created files, I recommend
> linking created files in one directory to avoid messing up relative pages.

There is no need to use something like `callPackage`, because there is no
package. I tried really hard to avoid relying on nixpkgs, be it for packages or
for `lib` and thus it's unironically fast and minimal. Though the code is a bit
unmanagable. Oh well!

### Single-Page

A **makePage** function is provided to create _a single document_ from given Nix
code. You may evaluate it as you see fit.

In the REPL:

```nix
nix-repl> import ./examples/single-page.nix {inherit makePage;}
"/nix/store/8qcbh99c2v0d43zrpdd50wrhgd8k9yjq-index.html"
```

Using the example in the CLI:

```bash
$ nix eval .#examples.singlepage --raw
/nix/store/8qcbh99c2v0d43zrpdd50wrhgd8k9yjq-index.html
```

The example should serve to give you an idea how of you may create your own
static pages with niXhtml. CSS and JS are optional, although fully supported.

### Multi-Page

**makeSite** function is a convenient wrapper around `makePage` to reduce the
need for further wrappers.

In the REPL:

```nix
nix-repl> import ./examples/multi-page.nix {inherit makeSite;}
{
  about = "/nix/store/cp1y1190963vd7zz66r40hlzk75hpq86-about.xhtml";
  contact = "/nix/store/dgzgcm17kdf0mzs9zgw3b8mjpj8yyjll-contact.xhtml";
  index = "/nix/store/rm94f1msidxixa2slvp6dky12fcw6wv5-index.xhtml";
}
```

Using the example in the CLI:

```bash
$ nix eval .#examples.multipage --json | jq # use --json for a structured result
{
  "about": "/nix/store/cp1y1190963vd7zz66r40hlzk75hpq86-about.xhtml",
  "contact": "/nix/store/dgzgcm17kdf0mzs9zgw3b8mjpj8yyjll-contact.xhtml",
  "index": "/nix/store/rm94f1msidxixa2slvp6dky12fcw6wv5-index.xhtml"
}
```

Using `--json` is not necessary, but it should make your life easier while using
this in CI/CD situations. You can also use `toJSON` inside, e.g., a NixOS
configuration if you plan to deploy on baremetal.

### API

I would encourage you to check out the function sources in `./lib`. The API
might be prone to change, though not too likely. While you're there, perhaps
help me with some documentation?

#### makePage

```nix
makePage {
  title,             # Page title
  body,              # Page content structure
  lang ? "en",       # HTML language attribute
  doctype ? "xhtml", # Document type (xhtml or html5)
  stylesheets ? [],  # List of stylesheet paths
  scripts ? [],      # List of script paths
  meta ? {},         # Meta tags as attribute set
  favicon ? null,    # Path to favicon
}
```

A very basic example would be

```nix
makePage {
  title = "My Page";
  lang = "en";
  doctype = "xhtml";
  stylesheets = [./styles.cs];
  scripts = [./script.js];
  meta = {
    description = "A page generated with nsg";
    viewport = "width=device-width, initial-scale=1.0";
  };
  favicon = "favicon.ico";
  body = {
    div = {
      "@class" = "container";
      h1 = "Hello, world!";
      p = "This page was generated with Nix.";
    };
  };
}
```

#### makeSite

```nix
makeSite {
  pages,           # Attribute set of pages
  siteConfig ? {}, # Site-wide configurations
  assets ? {},     # Asset files to include
}
```

Which you can use as

```nix
makeSite {
  pages = {
    index = {
      title = "Home";
      body = { /* ... */ };
    };
    about = {
      title = "About";
      body = { /* ... */ };
    };
  };

  siteConfig = {
    siteName = "My Website";
    commonStylesheets = [./common.css];
    commonMeta = {
      author = "Site Author";
      viewport = "width=device-width, initial-scale=1.0";
    };
  };

  assets = {
    "styles.css" = ./path/to/styles.css;
    "favicon.ico" = ./path/to/favicon.ico;
  };
}
```

#### HTML Structure Specification

```nix
{
  # Simple tag with text content
  tag = "content";

  # Tag with attributes
  div = {
    "@class" = "container";  # Attribute with @ prefix
    p = "Paragraph text";    # Nested element
  };

  # List of items
  ul = [
    { li = "Item 1"; }
    { li = "Item 2"; }
  ];
}
```

#### Special Keys

- `"@attribute"`: Any key starting with @ defines an HTML attribute
- `_text`: Raw text content
- `_raw`: Raw HTML content (unescaped)
- `_comment`: HTML comment
- `_fragment`: List of elements to be rendered in sequence

An example of special keys

```nix
{
  div = {
    "@class" = "content";
    # Object style attributes
    "@style" = {
      "color" = "red";
      "font-size" = "16px";
    };

    # Ordered sequence of elements
    _fragment = [
      { h2 = "Section Title"; }
      { p = { _text = "Text with <em>emphasis</em>"; }; }
      { _comment = "This is an HTML comment"; }
    ];
  };
}
```

## FAQ

1. Why?

Funny.

2. Buttons won't work if you're serving a file from the store!

Unfortunately. Since we are doing this without `pkgs` (and I'd like to keep it
that way) we cannot easily patch files to be able to reference each other. You
can easily solve this by linking files in a target directory, where you _know_
they will be able to refer to each other through, e.g., `/about.xhtml`.

## Contributing

Changes are welcome. This is mostly a self-imposed code-golf challenge, but I
appreciate new ideas nevertheless.

Make your changes, and open a pull request. I am not too picky on styling, but
_please_ format your code with Alejandra. I find nixfmt (both variants) to be
incredibly ugly and will not accept anything else.
