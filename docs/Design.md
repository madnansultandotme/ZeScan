# ZeScan UI/UX Design System Specification

This document details the visual design system, styling, typography, assets, and design principles applied to the ZeScan application to deliver a premium, modern, and privacy-respecting document scanner and PDF toolkit.

---

## 1. Visual Design Philosophy & Theme
ZeScan follows a **Dark, Clean, and Minimal** aesthetic. By choosing a deep dark background, we reduce eye strain, conserve device battery, and create a premium feel that contrasts with the white background of document scans. The primary accent is a vibrant Neon Purple/Indigo that guides the user's focus through the scan-to-share workflow.

### Color Palette

| Token | Hex Value | Semantic / UI Role | Usage |
| :--- | :--- | :--- | :--- |
| `BgDark` | `#0D0D0D` | Base scaffold background | App background, primary screen wrapper |
| `SurfaceDark` | `#161616` | Container background | Cards, search bar, list items |
| `BorderDark` | `#262626` | Subtle dividers / outlines | Container borders, dividers |
| `Primary` | `#5B4FE8` | Neon Purple (Brand Accent) | Action buttons, primary tabs, active icons |
| `PrimaryLight` | `#7C72F2` | Accent hover / active glow | Selection states, gradient start |
| `PrimaryGlow` | `rgba(91, 79, 232, 0.15)` | Transparent overlay | Active page backgrounds, button glows |
| `TextPrimary` | `#FFFFFF` | Core readability | Headers, primary labels, card titles |
| `TextSecondary`| `#A3A3A3` | Auxiliary info | File size, date, page counts, descriptors |
| `TextMuted` | `#525252` | Low-priority text | Disabled options, placeholder text |
| `Success` | `#10B981` | Emerald Green | Completed actions, saved files, free badge |
| `Warning` | `#F59E0B` | Amber / Gold | Pro Features, star icon, limits reached |
| `Danger` | `#EF4444` | Crimson Red | Delete actions, error states, reset buttons |

---

## 2. Typography System
To maintain a high-end feel, ZeScan uses the **Inter** typeface (or system default sans-serif with optimized tracking and weight if offline).

- **Display Large**: 32sp / Bold / tracking -0.5 / Line Height 1.2 (Used in onboarding / welcome screens)
- **Title Large**: 22sp / Semi-Bold / tracking 0 / Line Height 1.3 (Screen headers)
- **Title Medium**: 18sp / Semi-Bold / tracking 0 / Line Height 1.4 (Folder headers, section headers)
- **Body Large**: 16sp / Regular / tracking +0.15 / Line Height 1.5 (Main copy, card titles)
- **Body Medium**: 14sp / Medium / tracking +0.1 / Line Height 1.4 (Secondary text, metadata)
- **Caption**: 12sp / Regular / tracking +0.4 / Line Height 1.3 (Time, dates, badge text)

---

## 3. UI Components & Elements

### A. Glassmorphic Action Cards
A transparent overlay card that creates depth against the pure dark background.
- **Background**: `#161616` with `80%` opacity
- **Border**: `1dp` solid `#262626`
- **Border Radius**: `16dp`
- **Shadow**: Subtle blur (`offset: Offset(0, 4), blurRadius: 12, color: Colors.black.withOpacity(0.4)`)

### B. Action Buttons
Buttons feature a smooth linear gradient and scale feedback on press.
- **Gradient**: `LinearGradient(colors: [#7C72F2, #5B4FE8], begin: Alignment.topLeft, end: Alignment.bottomRight)`
- **Radius**: `12dp` or `30dp` (pill-shaped)
- **Interactive feedback**: Pressing scales the button by `0.97` to feel highly responsive.

### C. Floating Scan Button
A prominent Floating Action Button centered or at the bottom-right.
- **Shape**: Rounded square / stadium (`borderRadius: 16dp`)
- **Visuals**: Neon Purple gradient with a soft shadow/glow.
- **Micro-animation**: Soft pulsing outline when onboarding or empty state is shown.

### D. Privacy Indicator Badge
A dedicated, premium badge visible on the Home and Settings screens to enforce positioning.
- **Design**: Rounded pill in a green/purple gradient (`#10B981` to `#5B4FE8` or transparent green).
- **Text**: `"100% On-Device • Privacy Guaranteed"` with a Lock icon.

---

## 4. Asset & Illustration Mapping

ZeScan ships with pre-configured SVGs and images in the `assets/` directory.

### Onboarding & Splash
- `assets/images/dark_mode_logo.png`: Main logo for app boot and header branding.
- `assets/illustrations/Privacy policy-pana.svg`: Visualizing the offline-first commitment.

### Empty States & Fallbacks
- **Empty Library / No Files**: `assets/illustrations/undraw_empty_4zx0.svg` (or `undraw_my-files_1xwx.svg`) showing a clean "No documents yet" illustration.
- **No Search Results**: `assets/illustrations/undraw_not-found_6bgl.svg` (or `File searching-pana.svg`) for empty queries.
- **Empty Folders**: `assets/illustrations/undraw_file-bundle_oaof.svg` when a folder is created but has no files.

### Toolkit Visuals
- **Merge/Compress/Split pages**: `assets/illustrations/Organizing projects-amico.svg` showing organizing and compiling files.

---

## 5. Micro-Animations & Transitions
To elevate the user experience from basic to premium, the app integrates:
1. **Interactive Tap Feedbacks**: Custom wrapper that animates scale changes (`AnimatedContainer` or custom controller) for list items and buttons.
2. **Hero Transitions**: Images morph smoothly from the Scanner/Gallery grid into the full Preview viewer.
3. **Circular Loading Indicators**: Custom gradient spinners showing progress of PDF size estimation and generation.
4. **List Reordering Animations**: Smooth sliding movement when dragging and dropping pages on the Preview screen.
