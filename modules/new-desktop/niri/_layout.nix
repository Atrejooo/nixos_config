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
          width 2.7
          urgent-color "#${theme.textEmph0}cc"
          active-gradient from="#${theme.lightMain}cc" to="#${theme.lightHighlight}cc" angle=45
          inactive-color "#${theme.darkMain}cc"
      }

      shadow {
          on
          softness 20
          spread 10
          offset x=0 y=6
          color "#${theme.darkBase}a0"
          inactive-color "#${theme.darkBase}a0"
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
