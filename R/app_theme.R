#' Application color palette
#'
#' Central palette used both for the bslib theme and for the ggplot/plotly
#' color scales in the visual analytics module, so chrome and charts stay
#' visually consistent. A restrained, editorial palette: deep slate navy,
#' muted champagne gold, and warm neutrals.
#'
#' @return A named list of hex color strings.
#' @noRd
app_palette <- function() {
  list(
    primary   = "#4CAF50",
    secondary = "#A5D6A7",
    info      = "#6B8CAE",
    success   = "#5B8C6E",
    warning   = "#C9A227",
    danger    = "#A64B4B",
    light_bg      = "#FCFBF7",
    light_sidebar = "#C8E6C9",
    light_fg      = "#2f3a30",
    light_card    = "#FFFFFF"
  )
}

#' Build the application bslib theme
#'
#' A restrained, editorial theme (earthy greens) using Comic Neue for
#' all text (headings, sidebar menu, and body copy), except the page
#' title which keeps Permanent Marker, with soft shadows instead of
#' glows.
#'
#' @return A `bslib::bs_theme` object with extra CSS rules attached.
#' @import bslib
#' @noRd
app_theme <- function() {
  pal <- app_palette()
  # Matches the computed background of .bslib-page-title (the dark bar
  # at the top of the page), which bslib derives automatically and
  # isn't one of our own palette values.
  title_bar_hex <- "434D44"

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
    base_font = font_google("Comic Neue", wght = c(400, 700)),
    code_font = font_google("Permanent Marker"),
    "border-radius" = "0.6rem",
    "card-border-width" = "1px"
  )

  bs_add_rules(theme, sprintf("
    :root {
      --app-bg: %s;
      --app-sidebar-bg: %s;
      --app-fg: %s;
      --app-card: %s;
      --app-border: rgba(0, 0, 0, 0.08);
      --app-shadow: 0 1px 2px rgba(0, 0, 0, 0.04), 0 6px 16px rgba(0, 0, 0, 0.05);
    }

    body {
      background-color: var(--app-bg);
      color: var(--app-fg);
      transition: background-color 0.25s ease, color 0.25s ease;
    }

    .sidebar {
      background-color: var(--app-sidebar-bg) !important;
    }

    .card:not(.bslib-value-box) {
      background-color: var(--app-card) !important;
      border: 1px solid var(--app-border) !important;
      box-shadow: var(--app-shadow);
      transition: background-color 0.25s ease, border-color 0.25s ease;
    }

    .card-header:has(.nav-tabs) {
      background: var(--app-card) !important;
      border-bottom: 1px solid var(--app-border) !important;
      padding-top: 0.6rem;
    }
    .nav-tabs {
      border-bottom: none !important;
    }
    .bslib-page-title {
      font-family: 'Permanent Marker', cursive !important;
      letter-spacing: 0.03em;
    }
    .card-header, .nav-tabs .nav-link {
      font-family: 'Comic Neue', cursive;
      font-weight: 400;
    }

    .nav-tabs .nav-link {
      color: var(--app-fg);
      opacity: 0.55;
      letter-spacing: 0.01em;
      border: none !important;
      background: transparent !important;
      padding-bottom: 0.7rem;
      transition: opacity 0.15s ease;
    }
    .nav-tabs .nav-link:hover {
      opacity: 0.85;
    }
    .nav-tabs .nav-link.active {
      opacity: 1;
      color: %s !important;
      background: transparent !important;
      border-bottom: 2px solid %s !important;
    }

    .card-header {
      letter-spacing: 0.01em;
    }

    h4 {
      position: relative;
      display: inline-block;
      padding-bottom: 0.4rem;
      margin-bottom: 1.5rem;
    }
    h4::after {
      content: '';
      position: absolute;
      left: -2px;
      right: -12px;
      bottom: 0;
      height: 16px;
      pointer-events: none;
      background-image: url(\"data:image/svg+xml,%%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 300 26' preserveAspectRatio='none'%%3E%%3Cdefs%%3E%%3ClinearGradient id='penFade' x1='0' y1='0' x2='1' y2='0'%%3E%%3Cstop offset='0%%25' stop-color='%%23%s' stop-opacity='1'/%%3E%%3Cstop offset='65%%25' stop-color='%%23%s' stop-opacity='0.85'/%%3E%%3Cstop offset='100%%25' stop-color='%%23%s' stop-opacity='0.15'/%%3E%%3C/linearGradient%%3E%%3C/defs%%3E%%3Cpath d='M10,13 Q150,2 296,19 L296,20 Q150,4 10,19 A3,3 0 0 1 10,13 Z' fill='url(%%23penFade)'/%%3E%%3C/svg%%3E\");
      background-repeat: no-repeat;
      background-position: center bottom;
      background-size: 100%% 16px;
    }

    table.dataTable {
      border-collapse: separate !important;
      border-spacing: 0;
      border: 1px solid var(--app-border) !important;
      border-radius: 0.6rem;
      overflow: hidden;
    }
    table.dataTable tbody tr:hover > * {
      background-color: %s !important;
    }

    .bslib-value-box {
      background-color: var(--app-card) !important;
      box-shadow: var(--app-shadow);
      border: 1px solid var(--app-border) !important;
      border-left: 5px solid var(--app-border) !important;
    }
    .bslib-value-box.bg-success {
      background-color: var(--app-card) !important;
      border-left-color: %s !important;
      color: var(--app-fg) !important;
    }
    .bslib-value-box.bg-success .value-box-showcase {
      color: %s !important;
    }
    .bslib-value-box.bg-warning {
      background-color: var(--app-card) !important;
      border-left-color: %s !important;
      color: var(--app-fg) !important;
    }
    .bslib-value-box.bg-warning .value-box-showcase {
      color: %s !important;
    }

    .btn-primary {
      background-color: %s !important;
      border-color: %s !important;
      font-weight: 500;
      transition: filter 0.15s ease;
    }
    .btn-primary:hover {
      filter: brightness(1.12);
    }

    .app-side-nav {
      display: flex;
      flex-direction: column;
      gap: 0.2rem;
      margin-bottom: 0.5rem;
    }
    .app-nav-link {
      display: flex;
      align-items: center;
      gap: 0.6rem;
      padding: 0.6rem 0.9rem;
      border-radius: 0.5rem;
      color: var(--app-fg) !important;
      opacity: 0.65;
      text-decoration: none !important;
      font-family: 'Comic Neue', cursive;
      font-size: 1.1rem;
      font-weight: 400;
      transition: background-color 0.15s ease, opacity 0.15s ease;
    }
    .app-nav-link:hover {
      opacity: 1;
      background-color: var(--app-border);
    }
    .app-nav-link.active {
      opacity: 1;
      background-color: var(--app-border);
      color: %s !important;
    }

    .upload-page {
      display: flex;
      flex-direction: column;
      height: 100%%;
      gap: 1rem;
      padding-top: 1.5rem;
    }
    .upload-dropzone {
      width: 100%%;
      max-width: 900px;
      border: 2px dashed var(--app-border);
      border-radius: 0.75rem;
      padding: 3.25rem 1.5rem;
      text-align: center;
      background-color: var(--app-card);
      transition: border-color 0.15s ease;
      margin: 0 auto;
    }
    .upload-dropzone:hover {
      border-color: %s;
    }
    .upload-hint {
      opacity: 0.7;
      margin-bottom: 1rem;
    }
    .upload-columns-hint {
      margin-top: 1rem;
      width: 100%%;
      max-width: 900px;
      margin-left: auto;
      margin-right: auto;
      opacity: 0.6;
      font-size: 0.9rem;
      text-align: left;
      display: flex;
      align-items: center;
      gap: 0.4rem;
    }

    .upload-input-row {
      display: flex;
      align-items: stretch;
      max-width: 600px;
      margin: 0 auto;
    }
    .upload-input-row .form-group {
      flex: 1;
      margin-bottom: 0;
      position: relative;
    }
    .upload-input-row .input-group {
      height: 100%%;
    }
    .upload-input-row .input-group-btn,
    .upload-input-row .btn-file {
      height: 100%%;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 110px;
      box-sizing: border-box;
    }
    .upload-input-row .btn-file {
      border-top-right-radius: 0 !important;
      border-bottom-right-radius: 0 !important;
    }
    .upload-try-example {
      display: block;
      margin: 0.85rem auto 0;
      background: none !important;
      border: none !important;
      color: var(--app-fg) !important;
      opacity: 0.6;
      text-decoration: underline;
      font-weight: 400;
      padding: 0;
    }
    .upload-try-example:hover {
      opacity: 1;
    }
    .upload-input-row .input-group > .form-control {
      border-radius: 0 !important;
    }
    .upload-input-row > .btn.action-button {
      border-top-left-radius: 0 !important;
      border-bottom-left-radius: 0 !important;
      width: 110px;
      white-space: nowrap;
    }
    .upload-input-row .progress {
      display: none;
    }

    .upload-success-box {
      display: flex;
      align-items: center;
      gap: 0.9rem;
      max-width: 900px;
      margin: 1rem auto 0;
      padding: 1rem 1.25rem;
      background-color: var(--app-sidebar-bg);
      border-left: 4px solid %s;
      border-radius: 0.5rem;
    }
    .upload-success-icon {
      width: 1.8rem;
      height: 1.8rem;
      color: %s;
      flex-shrink: 0;
    }
    .upload-success-text {
      font-size: 1.15rem;
    }

    .app-nav-link.nav-disabled {
      opacity: 0.35;
      cursor: not-allowed;
    }

    .section-description {
      opacity: 0.75;
      margin-top: -0.75rem;
      margin-bottom: 1.5rem;
      max-width: 700px;
    }
  ",
    pal$light_bg, pal$light_sidebar, pal$light_fg, pal$light_card,
    pal$primary, pal$primary,
    title_bar_hex, title_bar_hex, title_bar_hex, pal$light_sidebar,
    pal$success, pal$success,
    pal$warning, pal$warning,
    pal$primary, pal$primary,
    pal$primary,
    pal$primary,
    pal$primary,
    pal$primary
  ))
}

#' Inline Lucide icon
#'
#' A handful of Lucide (lucide.dev) icons embedded as inline SVG, since
#' the app has no Lucide R package dependency. Path data taken verbatim
#' from the official `lucide-static` npm package (ISC licensed).
#'
#' @param name One of `"triangle-alert"`, `"badge-dollar-sign"`,
#'   `"shopping-basket"`.
#' @param class Optional CSS class for the returned `<svg>`.
#'
#' @return A `tags$svg`.
#' @noRd
lucide_icon <- function(name, class = NULL) {
  paths <- switch(name,
    "triangle-alert" = list(
      "m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3",
      "M12 9v4",
      "M12 17h.01"
    ),
    "badge-dollar-sign" = list(
      "M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z",
      "M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8",
      "M12 18V6"
    ),
    "shopping-basket" = list(
      "m15 11-1 9",
      "m19 11-4-7",
      "M2 11h20",
      "m3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.7-7.4",
      "M4.5 15.5h15",
      "m5 11 4-7",
      "m9 11 1 9"
    ),
    stop("Unknown lucide icon: ", name)
  )
  tags$svg(
    xmlns = "http://www.w3.org/2000/svg",
    viewBox = "0 0 24 24",
    style = "height:4rem;width:4rem;vertical-align:-0.125em;",
    fill = "none",
    stroke = "currentColor",
    `stroke-width` = "2",
    `stroke-linecap` = "round",
    `stroke-linejoin` = "round",
    class = class,
    lapply(paths, function(d) tags$path(d = d))
  )
}

#' Sidebar navigation menu
#'
#' A vertical list of links that drives which page is shown in the main
#' panel. Pure client-side click handling (`Shiny.setInputValue`) so no
#' extra input widget is needed; the app server reads `input$main_nav`
#' and syncs it to the hidden `tabsetPanel` in `app_ui.R`.
#'
#' @param choices Character vector of page names, in display order.
#' @param icons Character vector of `bsicons::bs_icon()` names, parallel
#'   to `choices`. `NULL` (the default) renders no icons.
#' @param requires_data Logical vector, parallel to `choices`, marking
#'   which pages start dimmed with an "Upload first!" tooltip and can't
#'   be clicked until data has been uploaded (see the
#'   `toggle_nav_data` custom message handler, driven from
#'   `app_server.R`). `NULL` (the default) leaves every page enabled.
#' @param selected Which choice is active on first load.
#'
#' @return A `tagList` with the nav links.
#' @import shiny
#' @noRd
app_nav_menu <- function(choices, icons = NULL, requires_data = NULL, selected = choices[1]) {
  if (is.null(icons)) icons <- rep(NA_character_, length(choices))
  if (is.null(requires_data)) requires_data <- rep(FALSE, length(choices))

  tagList(
    tags$div(
      class = "app-side-nav",
      Map(function(choice, icon, needs_data) {
        tags$a(
          href = "#",
          class = paste("app-nav-link",
                         if (identical(choice, selected)) "active" else "",
                         if (needs_data) "nav-disabled" else ""),
          `data-value` = choice,
          title = if (needs_data) "Upload first!" else NULL,
          onclick = sprintf(
            "if (this.classList.contains('nav-disabled')) { return false; }
             Shiny.setInputValue('main_nav', '%s');
             document.querySelectorAll('.app-nav-link').forEach(function(el) { el.classList.remove('active'); });
             this.classList.add('active');
             return false;",
            choice
          ),
          if (!is.na(icon)) bsicons::bs_icon(icon),
          choice
        )
      }, choices, icons, requires_data)
    ),
    tags$script(HTML("
      Shiny.addCustomMessageHandler('toggle_nav_data', function(hasData) {
        document.querySelectorAll('.app-nav-link').forEach(function(el) {
          if (el.getAttribute('data-value') === 'Upload') { return; }
          if (hasData) {
            el.classList.remove('nav-disabled');
            el.removeAttribute('title');
          } else {
            el.classList.add('nav-disabled');
            el.setAttribute('title', 'Upload first!');
          }
        });
      });
    "))
  )
}
