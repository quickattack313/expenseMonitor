#' Application color palette
#'
#' Central palette used both for the bslib theme and for the ggplot/plotly
#' color scales in the visual analytics module, so chrome and charts stay
#' visually consistent.
#'
#' @return A named list of hex color strings.
#' @noRd
app_palette <- function() {
  list(
    primary   = "#FF2E9A",
    secondary = "#7B2FF7",
    info      = "#00E5FF",
    success   = "#39FF88",
    warning   = "#FFC93C",
    danger    = "#FF3860",
    light_bg    = "#FBF7FF",
    light_fg    = "#1A0F2E",
    light_card  = "#FFFFFF",
    dark_bg     = "#0D0716",
    dark_fg     = "#F4EEFF",
    dark_card   = "#1C1330"
  )
}

#' Build the application bslib theme
#'
#' A vivid, "extravagant" theme (hot pink / electric violet / cyan) with
#' playful Google fonts, gradient accents and a client-side light/dark
#' toggle. The toggle is pure CSS + a few lines of vanilla JS: it flips a
#' `data-theme` attribute on `<html>` and never round-trips to the server.
#'
#' @return A `bslib::bs_theme` object with extra CSS rules attached.
#' @import bslib
#' @noRd
app_theme <- function() {
  pal <- app_palette()

  theme <- bs_theme(
    version = 5,
    bg = pal$light_bg,
    fg = pal$light_fg,
    primary = pal$primary,
    secondary = pal$secondary,
    success = pal$success,
    warning = pal$warning,
    danger = pal$danger,
    info = pal$info,
    base_font = font_google("Poppins"),
    heading_font = font_google("Fredoka"),
    "border-radius" = "1rem",
    "card-border-width" = "0px"
  )

  bs_add_rules(theme, sprintf("
    :root {
      --app-bg: %s;
      --app-fg: %s;
      --app-card: %s;
      --app-shadow: 0 8px 30px rgba(123, 47, 247, 0.15);
    }
    html[data-theme='dark'] {
      --app-bg: %s;
      --app-fg: %s;
      --app-card: %s;
      --app-shadow: 0 8px 30px rgba(0, 229, 255, 0.25);
    }

    body {
      color: var(--app-fg);
      background: linear-gradient(-45deg, var(--app-bg), %s22, var(--app-bg), %s22);
      background-size: 400%% 400%%;
      animation: app-gradient-shift 18s ease infinite;
      transition: color 0.25s ease;
    }
    @keyframes app-gradient-shift {
      0%%   { background-position: 0%% 50%%; }
      50%%  { background-position: 100%% 50%%; }
      100%% { background-position: 0%% 50%%; }
    }

    .card {
      background-color: var(--app-card) !important;
      border-radius: 1.25rem !important;
      box-shadow: var(--app-shadow);
      transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.25s ease;
    }
    .card:hover {
      transform: translateY(-2px);
    }

    .card-header:has(.nav-tabs) {
      background: linear-gradient(120deg, %s, %s 60%%, %s);
      border-radius: 1.25rem 1.25rem 0 0 !important;
      padding-top: 0.25rem;
      border: none !important;
    }
    .nav-tabs .nav-link {
      color: #ffffffcc;
      font-family: 'Fredoka', sans-serif;
      font-weight: 600;
      letter-spacing: 0.02em;
      border: none !important;
      background: transparent !important;
    }
    .nav-tabs .nav-link.active {
      color: #ffffff !important;
      background: rgba(255,255,255,0.18) !important;
      border-radius: 0.75rem 0.75rem 0 0 !important;
      box-shadow: inset 0 -3px 0 #ffffff;
    }

    .value-box {
      border-radius: 1.25rem !important;
      box-shadow: var(--app-shadow);
      transition: transform 0.2s ease;
    }
    .value-box:hover { transform: translateY(-3px) scale(1.01); }
    .value-box.bg-success { background: linear-gradient(135deg, %s, #1fd67a) !important; }
    .value-box.bg-warning { background: linear-gradient(135deg, %s, #ff8a3c) !important; color: #1A0F2E !important; }
    .value-box.bg-danger  { background: linear-gradient(135deg, %s, #c81d55) !important; }

    .btn-primary {
      background: linear-gradient(135deg, %s, %s) !important;
      border: none !important;
      font-weight: 600;
      transition: transform 0.15s ease, box-shadow 0.15s ease;
    }
    .btn-primary:hover {
      transform: translateY(-1px) scale(1.03);
      box-shadow: 0 6px 18px rgba(255, 46, 154, 0.4);
    }

    #app_theme_toggle {
      position: fixed;
      top: 0.75rem;
      right: 1.25rem;
      z-index: 1050;
      background: var(--app-card);
      border-radius: 2rem;
      padding: 0.35rem 0.75rem;
      box-shadow: var(--app-shadow);
    }
  ",
    pal$light_bg, pal$light_fg, pal$light_card,
    pal$dark_bg, pal$dark_fg, pal$dark_card,
    pal$primary, pal$info,
    pal$primary, pal$secondary, pal$info,
    pal$success, pal$warning, pal$danger,
    pal$primary, pal$secondary
  ))
}

#' Light/dark toggle widget
#'
#' A small floating switch that flips `data-theme` on the root `<html>`
#' element. Pure client-side (vanilla JS) so it never needs a server
#' round-trip and works the same regardless of which module tab is open.
#'
#' @return A `tagList` with the switch and its JS handler.
#' @import shiny
#' @import bslib
#' @noRd
app_theme_toggle <- function() {
  tagList(
    div(
      id = "app_theme_toggle",
      input_switch("dark_mode", label = tags$span("\U0001F319"), value = FALSE)
    ),
    tags$script(HTML("
      $(document).on('change', '#dark_mode', function() {
        document.documentElement.setAttribute('data-theme', this.checked ? 'dark' : 'light');
      });
    "))
  )
}
