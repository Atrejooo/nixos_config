/*
  Yazi tokens (used in `run` and `shell` commands)

  Selected files
  - %s   - all selected files (space-separated, shell-escaped)
  - %s1  - 1st selected file
  - %s2  - 2nd selected file
  - %sN  - Nth selected file
  - %S   - all selected files as file:// URLs
  - %S1  - 1st selected file as URL

  Hovered file
  - %h   - hovered file path
  - %H   - hovered file as URL

  Directories
  - %d   - dirname of all selected files
  - %d1  - dirname of 1st selected file
  - %D   - dirname as URL

  Tab / Yank
  - %t   - switch to next tab context
  - %T   - switch to prev tab context
  - %y   - yanked files
  - %Y   - yanked URLs

  Misc
  - %%   - literal %

  NOTE: paths are shell-escaped automatically, no "$@" needed.
*/
{
  mgr = {
    ratio = [
      2
      4
      4
    ];
    sort_by = "natural";
    show_hidden = true;
    title_format = "Yazi: {cwd}";
  };
  preview = {
    image_delay = 0;
    max_width = 1200;
    max_height = 1800;
  };
  opener = {
    edit = [
      {
        run = "hx %s1";
        desc = "hx";
        block = true;
      }
    ];
    pdf-open = [
      {
        run = "zen-browser %s1";
        desc = "open firefox";
        block = false;
      }
    ];
    play = [
      {
        run = "mpv --force-window %s";
        orphan = true;
      }
    ];
    audio-open = [
      {
        run = "mpv %s";
        for = "unix";
      }
    ];
  };
  open = {
    rules = [
      # folder
      {
        url = "*/";
        use = [
          "edit"
          "open"
          "reveal"
        ];
      }
      # text
      {
        mime = "text/*";
        use = [
          "edit"
          "reveal"
        ];
      }
      # Pdf
      {
        mime = "application/pdf";
        use = [
          "pdf-open"
        ];
      }
      # Image
      {
        mime = "image/*";
        use = [
          "open"
          "reveal"
        ];
      }
      # Media
      {
        mime = "{video}/*";
        use = [
          "play"
          "reveal"
        ];
      }
      # Media
      {
        mime = "{audio}/*";
        use = [
          "audio-open"
          "reveal"
        ];
      }
      # Archive
      {
        mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
        use = [
          "extract"
          "reveal"
        ];
      }
      # JSON
      {
        mime = "application/{json,ndjson}";
        use = [
          "edit"
          "reveal"
        ];
      }
      {
        mime = "*/javascript";
        use = [
          "edit"
          "reveal"
        ];
      }
      # Empty file
      {
        mime = "inode/empty";
        use = [
          "edit"
          "reveal"
        ];
      }
      # Fallback
      {
        url = "*";
        use = [
          "open"
          "reveal"
        ];
      }
    ];
  };
}
