k:
let
  # make a section with no arguments to the command
  section = name: body: (sectionParam name [ ] body);
  # make a section with shared_except and a list of params
  sectionExcept = args: body: sectionParam "shared_except" args body;
  # make a section with shared_except and a list of params
  sectionAmong = args: body: sectionParam "shared_among" args body;
  # make a section from
  # name: section command name
  # args: the arguments to the section command
  # body: the list of binds
  sectionParam = name: args: body: {
    ${name} = _: {
      props = args;
      content = body;
    };
  };
  # make a bind from
  # the key (string)
  # a set of actions to perform
  bind = key: actions: {
    bind = _: {
      props = [ key ];
      content = actions;
    };
  };
  # make a bind that switches to normal mode in addition to the given actions
  bindn = key: actions: (bind key ({ SwitchToMode = [ "normal" ]; } // actions));
  # make
  bindLaunchOrFocusPlugin =
    key: plugin:
    (bind key {
      LaunchOrFocusPlugin = _: {
        props = [ plugin ];
        content = {
          floating = [ true ];
          move_to_focused_tab = [ true ];
        };
      };
      SwitchToMode = [ "normal" ];
    });
in
[
  (section "locked" [
    (bindn "Ctrl g" { })
  ])
  (section "pane" [
    (bind "left" { MoveFocus = [ "left" ]; })
    (bind "down" { MoveFocus = [ "down" ]; })
    (bind "up" { MoveFocus = [ "up" ]; })
    (bind "right" { MoveFocus = [ "right" ]; })
    (bind "c" {
      SwitchToMode = [ "renamepane" ];
      PaneNameInput = [ 0 ];
    })
    (bindn "d" { NewPane = [ "down" ]; })
    (bindn "${k.e}" { TogglePaneEmbedOrFloating = _: { }; })
    (bindn "f" { ToggleFocusFullscreen = _: { }; })
    (bindn "${k.i}" { TogglePanePinned = _: { }; })
    (bind "${k.h}" { MoveFocus = [ "left" ]; })
    (bind "${k.j}" { MoveFocus = [ "down" ]; })
    (bind "${k.k}" { MoveFocus = [ "up" ]; })
    (bind "${k.l}" { MoveFocus = [ "right" ]; })
    (bindn "${k.n}" { NewPane = _: { }; })
    (bind "p" { SwitchFocus = _: { }; })
    (bindn "Ctrl p" { })
    (bindn "r" { NewPane = [ "right" ]; })
    (bindn "s" { NewPane = [ "stacked" ]; })
    (bindn "w" { ToggleFloatingPanes = _: { }; })
    (bindn "z" { TogglePaneFrames = _: { }; })
  ])
  (section "tab" [
    (bind "left" { GoToPreviousTab = _: { }; })
    (bind "down" { GoToNextTab = _: { }; })
    (bind "up" { GoToPreviousTab = _: { }; })
    (bind "right" { GoToNextTab = _: { }; })
    (bindn "1" { GoToTab = [ 1 ]; })
    (bindn "2" { GoToTab = [ 2 ]; })
    (bindn "3" { GoToTab = [ 3 ]; })
    (bindn "4" { GoToTab = [ 4 ]; })
    (bindn "5" { GoToTab = [ 5 ]; })
    (bindn "6" { GoToTab = [ 6 ]; })
    (bindn "7" { GoToTab = [ 7 ]; })
    (bindn "8" { GoToTab = [ 8 ]; })
    (bindn "9" { GoToTab = [ 9 ]; })
    (bindn "[" { BreakPaneLeft = _: { }; })
    (bindn "]" { BreakPaneRight = _: { }; })
    (bindn "b" { BreakPane = _: { }; })
    (bind "${k.h}" { GoToPreviousTab = _: { }; })
    (bind "${k.j}" { GoToNextTab = _: { }; })
    (bind "${k.k}" { GoToPreviousTab = _: { }; })
    (bind "${k.l}" { GoToNextTab = _: { }; })
    (bindn "${k.n}" { NewTab = _: { }; })
    (bind "r" {
      SwitchToMode = [ "renametab" ];
      TabNameInput = [ 0 ];
    })
    (bindn "s" { ToggleActiveSyncTab = _: { }; })
    (bindn "Ctrl t" { })
    (bindn "x" { CloseTab = _: { }; })
    (bind "tab" { ToggleTab = _: { }; })
  ])
  (section "resize" [
    (bind "left" { Resize = [ "Increase left" ]; })
    (bind "down" { Resize = [ "Increase down" ]; })
    (bind "up" { Resize = [ "Increase up" ]; })
    (bind "right" { Resize = [ "Increase right" ]; })
    (bind "+" { Resize = [ "Increase" ]; })
    (bind "-" { Resize = [ "Decrease" ]; })
    (bind "=" { Resize = [ "Increase" ]; })
    (bind "${k.H}" { Resize = [ "Decrease left" ]; })
    (bind "${k.J}" { Resize = [ "Decrease down" ]; })
    (bind "${k.K}" { Resize = [ "Decrease up" ]; })
    (bind "${k.L}" { Resize = [ "Decrease right" ]; })
    (bind "${k.h}" { Resize = [ "Increase left" ]; })
    (bind "${k.j}" { Resize = [ "Increase down" ]; })
    (bind "${k.k}" { Resize = [ "Increase up" ]; })
    (bind "${k.l}" { Resize = [ "Increase right" ]; })
    (bindn "Ctrl ${k.n}" { })
  ])
  (section "move" [
    (bind "left" { MovePane = [ "left" ]; })
    (bind "down" { MovePane = [ "down" ]; })
    (bind "up" { MovePane = [ "up" ]; })
    (bind "right" { MovePane = [ "right" ]; })
    (bind "${k.h}" { MovePane = [ "left" ]; })
    (bind "Ctrl ${k.h}" { SwitchToMode = [ "normal" ]; })
    (bind "${k.j}" { MovePane = [ "down" ]; })
    (bind "${k.k}" { MovePane = [ "up" ]; })
    (bind "${k.l}" { MovePane = [ "right" ]; })
    (bind "${k.n}" { MovePane = _: { }; })
    (bind "p" { MovePaneBackwards = _: { }; })
    (bind "tab" { MovePane = _: { }; })
  ])
  (section "scroll" [
    (bindn "${k.e}" { EditScrollback = _: { }; })
    (bind "s" {
      SwitchToMode = [ "entersearch" ];
      SearchInput = [ 0 ];
    })
  ])
  (section "search" [
    (bind "c" { SearchToggleOption = [ "CaseSensitivity" ]; })
    (bind "${k.n}" { Search = [ "down" ]; })
    (bind "${k.o}" { SearchToggleOption = [ "WholeWord" ]; })
    (bind "p" { Search = [ "up" ]; })
    (bind "w" { SearchToggleOption = [ "Wrap" ]; })
  ])
  (section "session" [
    (bindLaunchOrFocusPlugin "a" "zellij:about")
    (bindLaunchOrFocusPlugin "c" "configuration")
    (bind "Ctrl o" { SwitchToMode = [ "normal" ]; })
    (bindLaunchOrFocusPlugin "p" "plugin-manager")
    (bindLaunchOrFocusPlugin "s" "zellij:share")
    (bindLaunchOrFocusPlugin "w" "session-manager")
  ])
  (sectionExcept
    [ "locked" ]
    [
      (bind "Alt left" { MoveFocusOrTab = [ "left" ]; })
      (bind "Alt down" { MoveFocus = [ "down" ]; })
      (bind "Alt up" { MoveFocus = [ "up" ]; })
      (bind "Alt right" { MoveFocusOrTab = [ "right" ]; })
      (bind "Alt +" { Resize = [ "Increase" ]; })
      (bind "Alt -" { Resize = [ "Decrease" ]; })
      (bind "Alt =" { Resize = [ "Increase" ]; })
      (bind "Alt [" { PreviousSwapLayout = _: { }; })
      (bind "Alt ]" { NextSwapLayout = _: { }; })
      (bind "Alt f" { ToggleFloatingPanes = _: { }; })
      (bind "Ctrl g" { SwitchToMode = [ "locked" ]; })
      (bind "Alt ${k.h}" { MoveFocusOrTab = [ "left" ]; })
      (bind "Alt ${k.j}" { MoveFocus = [ "down" ]; })
      (bind "Alt ${k.k}" { MoveFocus = [ "up" ]; })
      (bind "Alt ${k.l}" { MoveFocusOrTab = [ "right" ]; })
      (bind "Alt ${k.i}" { MoveTab = [ "left" ]; })
      (bind "Alt ${k.o}" { MoveTab = [ "right" ]; })
      (bind "Alt ${k.n}" { NewPane = _: { }; })
      (bind "Alt p" { TogglePaneInGroup = _: { }; })
      (bind "Alt Shift p" { ToggleGroupMarking = _: { }; })
      (bind "Ctrl q" { Quit = _: { }; })
    ]
  )
  (sectionExcept [ "locked" "move" ] [ (bind "Ctrl ${k.h}" { SwitchToMode = [ "move" ]; }) ])
  (sectionExcept [ "locked" "session" ] [ (bind "Ctrl ${k.e}" { SwitchToMode = [ "session" ]; }) ])
  (sectionExcept
    [ "locked" "scroll" "search" "tmux" ]
    [ (bind "Ctrl b" { SwitchToMode = [ "tmux" ]; }) ]
  )
  (sectionExcept [ "locked" "scroll" "search" ] [ (bind "Ctrl s" { SwitchToMode = [ "scroll" ]; }) ])
  (sectionExcept [ "locked" "tab" ] [ (bind "Ctrl t" { SwitchToMode = [ "tab" ]; }) ])
  (sectionExcept [ "locked" "pane" ] [ (bind "Ctrl z" { SwitchToMode = [ "pane" ]; }) ])
  (sectionExcept [ "locked" "resize" ] [ (bind "Ctrl Shift z" { SwitchToMode = [ "resize" ]; }) ])
  (sectionExcept [ "normal" "locked" "entersearch" ] [ (bindn "enter" { }) ])
  (sectionExcept [ "normal" "locked" "entersearch" "renametab" "renamepane" ] [ (bindn "esc" { }) ])
  (sectionAmong [ "pane" "tmux" ] [ (bindn "x" { CloseFocus = _: { }; }) ])
  (sectionAmong
    [ "scroll" "search" ]
    [
      (bind "PageDown" { PageScrollDown = _: { }; })
      (bind "PageUp" { PageScrollUp = _: { }; })
      (bind "left" { PageScrollUp = _: { }; })
      (bind "down" { ScrollDown = _: { }; })
      (bind "up" { ScrollUp = _: { }; })
      (bind "right" { PageScrollDown = _: { }; })
      (bind "Ctrl b" { PageScrollUp = _: { }; })
      (bindn "Ctrl c" { ScrollToBottom = _: { }; })
      (bind "d" { HalfPageScrollDown = _: { }; })
      (bind "Ctrl f" { PageScrollDown = _: { }; })
      (bind "h" { PageScrollUp = _: { }; })
      (bind "j" { ScrollDown = _: { }; })
      (bind "k" { ScrollUp = _: { }; })
      (bind "l" { PageScrollDown = _: { }; })
      (bindn "Ctrl s" { })
      (bind "u" { HalfPageScrollUp = _: { }; })
    ]
  )
  (section "entersearch" [
    (bind "Ctrl c" { SwitchToMode = [ "scroll" ]; })
    (bind "esc" { SwitchToMode = [ "scroll" ]; })
    (bind "enter" { SwitchToMode = [ "search" ]; })
  ])
  (section "renametab" [
    (bind "esc" {
      UndoRenameTab = _: { };
      SwitchToMode = [ "tab" ];
    })
  ])
  (sectionAmong [ "renametab" "renamepane" ] [ (bindn "Ctrl c" { }) ])
  (section "renamepane" [
    (bind "esc" {
      UndoRenamePane = _: { };
      SwitchToMode = [ "pane" ];
    })
  ])
  (sectionAmong [ "session" "tmux" ] [ (bind "d" { Detach = _: { }; }) ])
  (section "tmux" [
    (bindn "left" { MoveFocus = [ "left" ]; })
    (bindn "down" { MoveFocus = [ "down" ]; })
    (bindn "up" { MoveFocus = [ "up" ]; })
    (bindn "right" { MoveFocus = [ "right" ]; })
    (bind "space" { NextSwapLayout = _: { }; })
    (bindn "\"" { NewPane = [ "down" ]; })
    (bindn "%" { NewPane = [ "right" ]; })
    (bind "," { SwitchToMode = [ "renametab" ]; })
    (bind "[" { SwitchToMode = [ "scroll" ]; })
    (bindn "Ctrl b" { Write = [ 2 ]; })
    (bindn "c" { NewTab = _: { }; })
    (bindn "${k.h}" { MoveFocus = [ "left" ]; })
    (bindn "${k.j}" { MoveFocus = [ "down" ]; })
    (bindn "${k.k}" { MoveFocus = [ "up" ]; })
    (bindn "${k.l}" { MoveFocus = [ "right" ]; })
    (bindn "${k.n}" { GoToNextTab = _: { }; })
    (bind "${k.o}" { FocusNextPane = _: { }; })
    (bindn "p" { GoToPreviousTab = _: { }; })
    (bindn "z" { ToggleFocusFullscreen = _: { }; })
  ])
]
