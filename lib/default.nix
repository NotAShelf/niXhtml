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
      # Handle special _text, _raw, _comment, _fragment keys
      # Statix is providing false positives here, do not lint
      if content ? _text
      then content._text
      else if content ? _raw
      then content._raw
      else if content ? _comment
      then "<!--${content._comment}-->"
      else if content ? _fragment # Handle fragments containing lists or mixed content
      then processMixedContent content._fragment # Recurse on fragment content
      else formatElements content # Treat as regular element set
    else if builtins.isList content
    then builtins.concatStringsSep "\n" (map processMixedContent content) # Process each item in the list
    else builtins.toString content; # Handle plain strings/numbers

  # Format a single element with its content and attributes
  formatElement = tagName: value: let
    # Handle void elements
    isVoid = isVoidElement tagName;

    # Direct string/number value as content
    simple =
      if builtins.isString value || builtins.isInt value
      then
        if isVoid
        then "<${tagName} />" # Void element, no content or closing tag
        else "<${tagName}>${builtins.toString value}</${tagName}>" # Simple content
      else null;

    # Handle attribute sets (complex elements with attributes and/or nested content)
    complex =
      if builtins.isAttrs value
      then let
        attrs = formatAttributes value;

        # Extract content keys (non-attribute, non-special keys)
        contentKeys = builtins.filter (
          k:
            (builtins.substring 0 1 k != "@") # Not an attribute
            && (k != "_text")
            && (k != "_raw")
            && (k != "_comment")
            && (k != "_fragment") # Handled separately
        ) (builtins.attrNames value);

        # Handle special content keys (_text, _raw, _comment, _fragment)
        # Statix false positive here.
        specialContent =
          if value ? _text
          then value._text
          else if value ? _raw
          then value._raw
          else if value ? _comment
          then "<!--${value._comment}-->"
          else if value ? _fragment # Use processMixedContent for fragments
          then processMixedContent value._fragment
          else null;

        # Process nested elements defined by standard keys
        nestedContent =
          if contentKeys == []
          then ""
          else
            formatElements (builtins.listToAttrs
              (map (k: {
                  name = k;
                  value = value.${k}; # Recursively format nested elements
                })
                contentKeys));

        # Combine special and nested content
        content =
          if specialContent != null
          then
            (
              if nestedContent == ""
              then specialContent
              else "${specialContent}\n${nestedContent}" # Combine if both exist
            )
          else nestedContent;
      in
        if isVoid
        # Void element with attributes
        then "<${tagName}${attrs} />"
        # Render tag with content, handles empty content correctly
        else "<${tagName}${attrs}>${content}</${tagName}>"
      else null;

    # Process a list value directly associated with a tag name
    # Example: ul = [ { li = "Item 1"; } { li = "Item 2"; } ];
    listContent =
      if builtins.isList value
      then let
        # Recursively format each item in the list using formatElements
        contents = builtins.concatStringsSep "\n" (map formatElements value);
      in
        # If the tag itself is a void element, it cannot contain list content.
        if isVoid
        then "<${tagName} />"
        # Otherwise, embed the formatted list content within the start and end tags.
        else "<${tagName}>${contents}</${tagName}>"
      else null;
  in
    # Determine the correct handler based on the value type
    if simple != null
    then simple
    else if complex != null
    then complex
    else if listContent != null # Check for list content
    then listContent
    # Fallback for null or empty {} value
    else if isVoid
    then "<${tagName} />"
    else "<${tagName}></${tagName}>";

  # Format all elements in an attribute set or list
  formatElements = data:
    if builtins.isAttrs data
    then let
      keys = builtins.attrNames data;
      # Special handling for top-level fragment (avoids wrapping element)
      isFragment = data ? _fragment;
    in
      if isFragment
      # Process fragment content directly
      then processMixedContent data._fragment
      # Format each key-value pair as an element
      else builtins.concatStringsSep "\n" (map (k: formatElement k data.${k}) keys)
    else if builtins.isList data
    # If data is a list, format each item in the list
    then builtins.concatStringsSep "\n" (map formatElements data)
    # Otherwise, treat as plain text
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

    # Generate head content structure as a list of element definitions
    headContentList =
      [{inherit title;}] # <title>title content</title>
      ++ (map (k: {
        meta = {
          "@name" = k;
          "@content" = meta.${k};
        };
      }) (builtins.attrNames meta)) # <meta ... />
      ++ (map (href: {
          link = {
            "@rel" = "stylesheet";
            "@type" = "text/css";
            "@href" = href;
          };
        })
        stylesheets) # <link ... />
      ++ (map (src: {
          script = {
            "@type" = "text/javascript";
            "@src" = src;
          };
        })
        scripts) # <script ...></script>
      ++ (
        if favicon != null
        then [
          {
            link = {
              "@rel" = "shortcut icon";
              "@href" = favicon;
              "@type" = "image/x-icon";
            };
          }
        ]
        else []
      ); # <link ... />

    # Define the head element using _fragment to render the list of tags inside it
    headElement = {head = {_fragment = headContentList;};};

    # Define HTML attributes based on doctype
    htmlAttrs =
      (
        if doctype == "xhtml"
        then {"@xmlns" = "http://www.w3.org/1999/xhtml";}
        else {}
      )
      // {
        "@lang" = lang;
      };

    # Define the complete page structure as a Nix attribute set
    pageStructure = {
      # The top-level key is the tag name 'html'
      html =
        htmlAttrs
        // headElement
        // {
          # The body content is passed directly
          inherit body;
        };
    };

    # Generate the HTML content using formatElements
    pageContent = formatElements pageStructure;
  in
    # Combine XML declaration, DOCTYPE, and the generated HTML content
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

  makeSite = {
    pages, # Attribute set of page specifications
    siteConfig ? {}, # Optional site-wide configurations
    assets ? {}, # Optional asset files to include
    pkgs ? null, # Optional nixpkgs reference for advanced functionality
  }: let
    defaultSiteConfig = {
      siteName = "My Site";
      baseUrl = "";
      lang = "en";
      doctype = "xhtml";
      commonMeta = {
        viewport = "width=device-width, initial-scale=1.0";
      };
      commonStylesheets = [];
      commonScripts = [];
      favicon = null;
    };

    config = defaultSiteConfig // siteConfig;

    # Generate an individual page
    generatePage = name: spec: let
      # Combine common site config with page-specific config
      fullSpec = {
        title = spec.title or "${config.siteName} - ${name}";
        lang = spec.lang or config.lang;
        doctype = spec.doctype or config.doctype;
        stylesheets = (config.commonStylesheets or []) ++ (spec.stylesheets or []);
        scripts = (config.commonScripts or []) ++ (spec.scripts or []);
        meta = (config.commonMeta or {}) // (spec.meta or {});
        favicon = spec.favicon or config.favicon;
        body = spec.body; # Pass the body structure directly
      };

      # Create the page content
      pageContent = makePage fullSpec;

      # Determine file extension based on doctype
      extension =
        if (fullSpec.doctype == "xhtml")
        then ".xhtml"
        else ".html";
    in
      builtins.toFile "${name}${extension}" pageContent;

    # Generate all pages
    pageFiles = builtins.mapAttrs generatePage pages;

    # Handle assets if pkgs is provided
    assetFiles =
      if pkgs != null && assets != {}
      then
        pkgs.runCommandLocal "site-assets" {} (
          let
            copyCommands =
              builtins.mapAttrs (
                name: path: "mkdir -p $out/$(dirname ${name}) && cp -r ${path} $out/${name}"
              )
              assets;
          in
            builtins.concatStringsSep "\n" (builtins.attrValues copyCommands)
        )
      else {};

    # Final result includes pages and optionally assets
    result =
      pageFiles
      // (
        if pkgs != null && assets != {}
        then {_assets = assetFiles;}
        else {}
      );
  in
    result;
in {
  inherit makePage makeSite;
}
