{ theme }: /* kdl */ ''
  window-rule {
      geometry-corner-radius 10
      clip-to-geometry true

      background-effect {
          blur true
      }
  }

  layer-rule {
      match namespace="backdrop"
      place-within-backdrop true
  }

  layer-rule {
      match namespace="^waybar$"

      shadow {
          on
          // off
          softness 40
          spread 5
          offset x=0 y=5
          draw-behind-window true
          color "#${theme.darkBase}30"
          // inactive-color "#00000064"
      }

      // geometry-corner-radius 0 0 12 12
      place-within-backdrop true
      // funny hehe 
      // baba-is-float true

      background-effect {
          xray false
          blur true
          // noise 0.05
          // saturation 3
      }

      popups {
          geometry-corner-radius 12

          background-effect {
              xray false
              blur true
              // noise 0.05
              // saturation 3
          }
      }
  }
''
