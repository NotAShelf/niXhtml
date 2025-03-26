let
  # List of void elements that shouldn't have closing tags
  voidElements = [
    "area"
    "base"
    "br"
    "col"
    "embed"
    "hr"
    "img"
    "input"
    "link"
    "meta"
    "param"
    "source"
    "track"
    "wbr"
  ];

  # Check if an element is a void element
  isVoidElement = name: builtins.elem name voidElements;

  # Format attributes for an element
  formatAttributes = attrs: let
    # Handle normal attrs (prefixed with @)
    attrKeys =
      builtins.filter (k: builtins.substring 0 1 k == "@")
      (builtins.attrNames attrs);

    # Special handling for style attributes as objects
    styleAttr =
      if attrs ? "@style" && builtins.isAttrs attrs."@style"
      then let
        styleKeys = builtins.attrNames attrs."@style";
        formatStyle = k: "${k}: ${attrs."@style".${k}}";
        styleString = builtins.concatStringsSep "; " (map formatStyle styleKeys);
      in [" style=\"${styleString}\""]
      else [];

    # Format regular atts
    regularAttrs =
      map (
        k: let
          name = builtins.substring 1 (builtins.stringLength k) k;
          value = attrs.${k};

          # Skip style if it's handled as an object
          skipStyle = name == "style" && builtins.isAttrs value;
        in
          if skipStyle
          then ""
          else " ${name}=\"${builtins.toString value}\""
      )
      attrKeys;

    # Combine all attribute strings
    allAttrs = regularAttrs ++ styleAttr;
  in
    builtins.concatStringsSep "" allAttrs;

  # Process mixed content (text and elements)
  processMixedContent = content:
    if builtins.isAttrs content
    then
      # Handle special _text and _raw keys
      # Statix is providing false positives here, do not lint
      if content ? _text
      then content._text
      else if content ? _raw
      then content._raw
      else if content ? _comment
      then "<!--${content._comment}-->"
      else formatElements content
    else if builtins.isList content
    then builtins.concatStringsSep "\n" (map processMixedContent content)
    else builtins.toString content;

  # Format a single element with its content and attributes
  formatElement = tagName: value: let
    # Handle void elements
    isVoid = isVoidElement tagName;

    # Direct string/number value
    simple =
      if builtins.isString value || builtins.isInt value
      then
        if isVoid
        then "<${tagName} />"
        else "<${tagName}>${builtins.toString value}</${tagName}>"
      else null;

    # Handle attributes and nested content
    complex =
      if builtins.isAttrs value
      then let
        attrs = formatAttributes value;

        # Extract content keys (non-attribute keys)
        contentKeys = builtins.filter (
          k:
            (builtins.substring 0 1 k != "@")
            && (k != "_text")
            && (k != "_raw")
            && (k != "_comment")
        ) (builtins.attrNames value);

        # Handle special content
        specialContent =
          if value ? _text
          then value._text
          else if value ? _raw
          then value._raw
          else if value ? _comment
          then "<!--${value._comment}-->"
          else null;

        # Process nested elements
        nestedContent =
          if contentKeys == []
          then ""
          else
            formatElements (builtins.listToAttrs
              (map (k: {
                  name = k;
                  value = value.${k};
                })
                contentKeys));

        # Combine special and nested content
        content =
          if specialContent != null
          then
            (
              if nestedContent == ""
              then specialContent
              else "${specialContent}\n${nestedContent}"
            )
          else nestedContent;
      in
        if isVoid
        then "<${tagName}${attrs} />"
        else if content == ""
        then "<${tagName}${attrs}></${tagName}>"
        else "<${tagName}${attrs}>${content}</${tagName}>"
      else null;

    # Process list of items
    list =
      if builtins.isList value
      then let
        contents =
          builtins.concatStringsSep "\n"
          (map formatElements value);
      in
        if isVoid
        then "<${tagName} />"
        else "<${tagName}>${contents}</${tagName}>"
      else null;
  in
    if simple != null
    then simple
    else if complex != null
    then complex
    else if list != null
    then list
    else if isVoid
    then "<${tagName} />"
    else "<${tagName}></${tagName}>";

  # Format all elements in an attribute set
  formatElements = data:
    if builtins.isAttrs data
    then let
      keys = builtins.attrNames data;

      # Special handling for fragment
      isFragment = data ? _fragment;
    in
      if isFragment
      then processMixedContent data._fragment
      else builtins.concatStringsSep "\n" (map (k: formatElement k data.${k}) keys)
    else if builtins.isList data
    then builtins.concatStringsSep "\n" (map formatElements data)
    else builtins.toString data;

  # Create a complete page
  makePage = {
    title,
    body,
    lang ? "en",
    doctype ? "xhtml",
    stylesheets ? [],
    scripts ? [],
    meta ? {},
    favicon ? null,
  }: let
    # DOCTYPE options
    doctypes = {
      xhtml = ''
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      '';
      html5 = "<!DOCTYPE html>";
    };

    # XML declaration
    xml =
      if doctype == "xhtml"
      then "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
      else "";

    # DOCTYPE declaration
    doctypeDecl = doctypes.${doctype} or doctypes.html5;

    # Handle meta tags
    metaTags = builtins.concatStringsSep "\n" (
      map (k: "<meta name=\"${k}\" content=\"${meta.${k}}\" />") (builtins.attrNames meta)
    );

    # Handle stylesheets
    stylesheetLinks = builtins.concatStringsSep "\n" (
      map (href: "<link rel=\"stylesheet\" type=\"text/css\" href=\"${href}\" />") stylesheets
    );

    # Handle scripts
    scriptTags = builtins.concatStringsSep "\n" (
      map (src: "<script type=\"text/javascript\" src=\"${src}\"></script>") scripts
    );

    # Handle favicon
    faviconTag =
      if favicon != null
      then "<link rel=\"shortcut icon\" href=\"${favicon}\" type=\"image/x-icon\" />"
      else "";

    # Additional head content
    headContent = builtins.concatStringsSep "\n" (
      builtins.filter (x: x != "") [
        "<title>${title}</title>"
        (
          if metaTags != ""
          then metaTags
          else ""
        )
        (
          if stylesheetLinks != ""
          then stylesheetLinks
          else ""
        )
        (
          if scriptTags != ""
          then scriptTags
          else ""
        )
        (
          if faviconTag != ""
          then faviconTag
          else ""
        )
      ]
    );

    # Generate HTML structure
    htmlAttrs =
      if doctype == "xhtml"
      then {
        "xmlns" = "http://www.w3.org/1999/xhtml";
        "lang" = lang;
      }
      else {"lang" = lang;};

    # FIXME: The entire poinnt was to *avoid* using string interpolation
    # to create the document. Sure this is *technically* not fully
    # interpolated (formatElements is not a large template)
    # it doesn't count, but I'd like to also pass this to
    # the formatElements (or a variation) to actually get
    # everything from Nix.
    pageContent = ''
      <html${formatAttributes (builtins.listToAttrs (map (k: {
        name = "@${k}";
        value = htmlAttrs.${k};
      }) (builtins.attrNames htmlAttrs)))}>
        <head>
          ${headContent}
        </head>
        <body>
          ${formatElements body}
        </body>
      </html>
    '';
  in
    builtins.concatStringsSep "\n" (
      builtins.filter (x: x != "") [
        (
          if xml != ""
          then xml
          else ""
        )
        doctypeDecl
        pageContent
      ]
    );

  # The pages cannot deal with relative paths, because they are
  # different store paths. If we had pkgs in scope, writeTextDir
  # would have helped, but we need a better way to calculate store
  # paths for each "input" to makeSite.
  # TODO: this should be removed, or adjusted to handle more
  # complex cases.
  makeSite = {pages}: let
    generatePage = name: spec:
      builtins.toFile "${name}.xhtml" (makePage spec);

    pageFiles = builtins.mapAttrs generatePage pages;
  in
    pageFiles;
in {
  inherit makePage;
}
