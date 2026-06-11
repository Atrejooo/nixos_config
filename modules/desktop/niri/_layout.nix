theme: {
  gaps = 2;
  center-focused-column = "never";

  preset-column-widths = [
    { proportion = 0.33333; }
    { proportion = 0.5; }
    { proportion = 0.66667; }
    { proportion = 1.0; }
  ];
  default-column-width = {
    proportion = 1.0;
  };

  focus-ring.off = _: { };

  border = {
    width = 2;
    urgent-color = "#${theme.textRed}";
    active-gradient = _: {
      props = [
        { from = "#${theme.lightMain}"; }
        { to = "#${theme.lightHighlight}"; }
        { angle = 45; }
      ];
    };
    inactive-color = "#${theme.darkMain}";
  };

  shadow = {
    on = _: { };
    softness = 30;
    spread = 5;
    offset = _: {
      props = [
        { x = 0; }
        { y = 8; }
      ];
    };
    color = "#${theme.darkBase}";
  };
  struts = {
    left = 6;
    right = 6;
    top = 12;
    bottom = 12;
  };
}
