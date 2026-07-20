{ theme }: /* kdl */ ''
  layout {
      gaps 2
      center-focused-column "never"
      background-color "#00330000"

      preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
          proportion 1.0
      }
      default-column-width { proportion 1.0; }

      focus-ring { off; }

      border {
          width 3
          urgent-color "#${theme.textRed}"
          active-gradient from="#${theme.lightMain}" to="#${theme.lightHighlight}" angle=45
          inactive-color "#${theme.darkMain}"
      }

      shadow {
          on
          softness 0
          spread 0
          offset x=0 y=6
          color "#${theme.lightBase}"
          inactive-color "#${theme.darkBase}"
      }

      struts {
          left 6
          right 6
          top 10
          bottom 10
      }
  }
''
