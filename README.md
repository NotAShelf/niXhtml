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
2. Pass it to the `makePage` function
3. Watch the fireworks (they're in your head)

The standard `toXML` doesn't really do what we want here, and XHTML doesn't
_appear_ to be fully structable using just that. For this reason, I've created a
standalone function (which doesn't depend on `nixpkgs.lib`) that takes a set and
creates structured XHTML. You can write the file somewhere with `toFile` (or
using `nixpkgs.lib`) to serve the created files, I recommend linking created
files in one directory to avoid messing up relative pages.

There is no need to use something like `callPackage`, because there is no
package. I tried really hard to avoid relying on nixpkgs, be it for packages or
for `lib` and thus it's unironically fast and minimal. Though the code is a bit
unmanagable.

```nix
# In the repl
> import ./pkgs/single-page.nix {inherit makePage;}
"/nix/store/8qcbh99c2v0d43zrpdd50wrhgd8k9yjq-index.html"
```

While I can list all possible arguments, I would encourage you to check out the
function sources in `./lib`. The API might be prone to change, though not too
likely. While you're there, perhaps help me with some documentation?

## Caveats

I created this while procrastinating on an important task. There are bugs that
make this unusable in a production environment, but you are more than welcome to
try. Two things I've noted to be broken are `makeSite`, which doesn't function
as intended because of `toFile` shenanigans and the element ordering. You are
welcome to try and fix those, maybe open a PR too?

## Contributing

Make your changes, and open a pull request. I am not too picky on styling, but
_please_ format your code with Alejandra.
