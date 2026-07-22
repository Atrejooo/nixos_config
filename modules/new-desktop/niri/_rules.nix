/* kdl */ ''
  window-rule {
      geometry-corner-radius 10
      clip-to-geometry true
  }

  window-rule {
      match app-id="^Alacritty$"
      background-effect { blur true; }
  }

  layer-rule {
      match namespace="backdrop"
      place-within-backdrop true
  }

  layer-rule {
      match namespace="^waybar$"
      background-effect { blur true; }
  }
''
