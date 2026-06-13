{
  keyboard = {
    xkb = {
      layout = "en";
      options = "caps:escape";
    };
  };
  touchpad = {
    click-method = "clickfinger";
  };
  warp-mouse-to-focus = _: { content = false; };
  focus-follows-mouse = _: {
    props = {
      max-scroll-amount = "50%";
    };
  };
}
