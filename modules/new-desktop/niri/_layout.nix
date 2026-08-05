{ theme }: /* kdl */ ''
  layout {
      gaps 6
      center-focused-column "never"
      background-color "#00330000"

      preset-column-widths {
          proportion 0.5
          proportion 1.0
      }
      default-column-width { proportion 1.0; }

      focus-ring { off; }

      border {
          width 3
          urgent-color "#${theme.textEmph0}"
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
          top 6
          bottom 10
      }

      insert-hint {
          // off
          on
          gradient from="#${theme.lightMain}30" to="#${theme.lightHighlight}30" angle=45 relative-to="workspace-view"
      }
  }
''
