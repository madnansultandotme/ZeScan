# ZeScan User Screens Specification

This document details the screens and user flows to be built for the ZeScan application, mapping functional requirements from the PRD to specific UI layouts.

---

## 1. Onboarding & Splash Screen
- **Layout**: Full-screen deep black scaffold. Large center logo (`dark_mode_logo.png`) fading in with a slide-up entrance animation.
- **Content**:
  - Hero illustration: `Privacy policy-pana.svg` or `Privacy policy-bro.svg`
  - Bold tagline: "The scanner that respects you."
  - Bullet-points highlighting core pillars:
    - `Icons.security` **100% On-Device:** No cloud upload, no data sharing.
    - `Icons.block` **No Watermarks:** Free files, professional output.
    - `Icons.vpn_key` **No Account Required:** Start scanning instantly.
  - Call to Action: Large pill-shaped Purple gradient button "Scan My First Document".

---

## 2. Main Shell (Bottom Navigation)
- **Layout**: Scaffold with bottom navigation bar, float-centered scan action, and screen-switch body.
- **Tabs**:
  - `Icons.home` **Library**: Primary document repository, folders, search, and recents.
  - `Icons.build` **PDF Toolkit**: Direct file action tools (Merge, Compress, Split, Rotate, etc.).
  - `Icons.settings` **Privacy & Settings**: Pro purchase unlock, privacy verification logs, storage stats, and documentation.
- **FAB**: Floating Neon-Purple scan button. Pulsates gently on first install when the library is empty.

---

## 3. Library / Home Screen
- **Layout**: Vertically scrolling view with persistent top-appbar, sticky filters, and section divisions.
- **Components**:
  1. **Branding Header**: "ZeScan" wordmark with the Privacy Pill Badge (`[100% On-Device]`).
  2. **Search Bar**: Sticky capsule bar (`Search documents...`) with filter icon.
  3. **Folder Carousels (Grid/Horizontal Scroll)**:
     - Pre-populated: `Assignments`, `Receipts`, `Personal`, `Office`.
     - Card styling: Folder Icon + Folder Name + Count of items.
     - "Create Custom Folder" (+) tile.
  4. **Recents Row**: Horizontal slider showing thumbnail, title, and page counts of the last 3 accessed files.
  5. **Main Files List**:
     - Column of file cards: PDF thumbnail icon + Title + Metadata (Size, Pages, Date) + Folder Badge + Star Icon + Overflow Button (⋮).
     - Empty State: When no files, shows `undraw_empty_4zx0.svg` with message "Tap the camera to start scanning".

---

## 4. Camera & Document Capture Screen (Mock + Native Integration)
- **Layout**: Full-screen camera view with custom overlay boundaries.
- **Key Features**:
  - **Camera Viewport**: Natively displays camera view. In mock mode (web/emulator), displays a simulated viewfinder showing a sample paper document, simulating edge detection overlays in real time.
  - **Capture Mode Toggles**: Slider at bottom: `Single Page` vs `Continuous Scan` (Continuous shows a warning that it has a page cap for free, unlocked for Pro).
  - **Controls Overlay**: Flash Toggle, Gallery Import Shortcut, Shutter Button, Done (Save) checkmark (for continuous mode).
  - **Page Counter Badge**: Tiny floating badge showing captured count (e.g. `[ 4 ]`).

---

## 5. Preview & Page Editor Screen
- **Layout**: Full-screen grid or horizontal carousel view showing all captured page frames.
- **Interactive Controls**:
  - **Drag-to-Reorder**: Reorder pages dynamically by pressing, dragging, and dropping thumbnails.
  - **Individual Page Card**: Shows Page Number Badge (`Page 1`, `Page 2`) and a corner edit button.
  - **Edit Options (Bottom Sheet)**: Tapping edit or long-pressing opens:
    - `Icons.camera_alt` **Retake Page**: Open camera scanner to replace *just* this page image.
    - `Icons.photo_library` **Replace from Gallery**: Open file picker to swap this page.
    - `Icons.delete` **Delete Page**: Remove immediately with a slide-out animation.
  - **Add Page Button**: Card at end of page strip to scan/import additional sheets.
  - **Export Footer**: Persistent bottom panel showing total page count and prominent "Next: Choose Quality" button.

---

## 6. Export Quality & Size Estimation Bottom Sheet
- **Layout**: Slide-up modal sheet with background dimming.
- **Features**:
  - **Title**: "Export PDF Document"
  - **Default File Name**: Pre-filled field with auto-generated name `ZeScan_YYYYMMDD_HHMMSS`. Allows inline typing.
  - **Quality Tiers**: Horizontal row of 3 select cards:
    - **Low Quality (40% compression)**: Smallest footprint (`~1.2 MB` estimate). Great for web uploads.
    - **Medium Quality (70% compression)**: Standard default (`~3.5 MB` estimate). Optimized for WhatsApp/Email sharing.
    - **High Quality (95% compression)**: Full resolution (`~11.8 MB` estimate). Best for print & archivism.
  - **Estimation Engine**: Concurrently calculates size in background and displays alongside tiers.
  - **Action Button**: "Generate Document" triggers circular progress modal overlay.

---

## 7. Success & Direct Share Screen
- **Layout**: Celebrating layout with confetti micro-animations.
- **Components**:
  - **Success Indicator**: Big green checkmark with status text: `"PDF Generated Successfully!"`.
  - **File Preview Card**: Show generated file name, actual final file size, and page count.
  - **Quick Share Panel**: Circular app icons for:
    - WhatsApp (app icon)
    - Gmail (app icon)
    - Google Drive (app icon)
    - Telegram (app icon)
    - `Icons.save_alt` Save to Files (Local downloads)
    - `Icons.add` More... (Standard native system share sheet)
  - **Dismiss Action**: "Back to Library" button.

---

## 8. PDF Toolkit Dashboard & Action Screens
- **Dashboard Layout**: Grid of 4 high-impact action cards with descriptive subtitles and icons:
  - `Icons.merge_type` **Merge PDFs**: Combine multiple documents.
  - `Icons.compress` **Compress PDF**: Reduce file size of an existing document.
  - `Icons.call_split` **Split PDF**: Extract ranges or specific pages.
  - `Icons.difference` **Manage Pages**: Rotate, delete, or reorder sheets in an existing PDF.
- **Interactive Flows**:
  - **Merge Screen**: Select multiple documents from the library or system storage, drag to set order, and tap Merge.
  - **Compress Screen**: Select file, view size estimation slider (adjust compression slider 0-100% and see real-time target size), tap Save.
  - **Split Screen**: Select file, displays visual grid of all pages with checkmarks, check pages to extract, tap Save As New.
  - **Manage Pages Screen**: Open PDF, select pages, tap Rotate (90/180/270), Delete, or drag to reorder, then save.

---

## 9. Privacy & Settings Screen
- **Layout**: Clean list groups grouped by category.
- **Main Options**:
  - **Go Pro Panel**: Gold/amber gradient banner showing lifetime Pro unlock features (Unlimited scans, full toolkit tools, no ads, continuous mode).
  - **100% On-Device Audit**: Interactive panel showing local files database count, network utilization check (always 0 bytes), and local storage usage.
  - **App Options**: Dark mode force toggle, scanner preferences, clear cache, and about section.
