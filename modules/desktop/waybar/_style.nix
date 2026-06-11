{ logo_url, theme }:
"
#custom-logo {
  background-image: url('${logo_url}');
  background-position: center;
  background-repeat: no-repeat;
  background-size: contain; 
}
@define-color dark_base #${theme.darkBase};
@define-color dark_main #${theme.darkMain};
@define-color light_base #${theme.lightBase};
@define-color light_highlight #${theme.lightHighlight};
@define-color light_main #${theme.lightMain};
@define-color txt_blue #${theme.textBlue};
@define-color txt_cyan #${theme.textCyan};
@define-color txt_dark #${theme.textDark};
@define-color txt_green #${theme.textGreen};
@define-color txt_highlight #${theme.textEmph0};
@define-color txt_main #${theme.textMain};
@define-color txt_orange #${theme.textOrange};
@define-color txt_pale #${theme.textPale};
@define-color txt_purple #${theme.textMagenta};
@define-color txt_red #${theme.textRed};
@define-color txt_sel #${theme.textSelect};
@define-color txt_white #${theme.textWhite};
@define-color txt_yellow #${theme.textYellow};
"
