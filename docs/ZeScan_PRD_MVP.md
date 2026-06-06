# ZeScan — MVP Product Requirements Document

**Tagline:** A fast, privacy-first PDF scanner and document toolkit.
**Website:** zescan.zeppelinlabs.digital
**Platform:** Android (Flutter)
**Version:** 1.0 MVP
**Owner:** Zeppelin Labs
**Status:** Approved for build
**Last updated:** June 2026

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Problem Statement](#2-problem-statement)
3. [Target Users](#3-target-users)
4. [Goals & Success Metrics](#4-goals--success-metrics)
5. [Non-Goals (MVP)](#5-non-goals-mvp)
6. [User Stories](#6-user-stories)
7. [Feature Specifications](#7-feature-specifications)
8. [Technical Architecture](#8-technical-architecture)
9. [Monetisation Model](#9-monetisation-model)
10. [Design Principles](#10-design-principles)
11. [Launch Scope & Timeline](#11-launch-scope--timeline)
12. [Risks & Mitigations](#12-risks--mitigations)
13. [Open Questions](#13-open-questions)

---

## 1. Product Overview

ZeScan is a privacy-first document scanner and PDF toolkit for Android. It enables users to scan physical documents using their phone camera, import images from their gallery, and export high-quality PDFs — entirely on-device, with no cloud dependency, no account requirement, and no watermarks on any tier.

ZeScan targets students, freelancers, and professionals in markets where existing tools (CamScanner, Adobe Scan) charge for basic features, watermark free output, or mandate cloud account creation.

**Positioning:** The scanner that respects you. No watermark. No cloud. No account.

**Distribution:** Google Play Store
**Website:** [zescan.zeppelinlabs.digital](https://zescan.zeppelinlabs.digital)

---

## 2. Problem Statement

### Validated pain points (from community research, Play Store reviews)

| # | Problem | Severity | Current workaround |
|---|---------|----------|--------------------|
| 1 | Too many steps: scan → crop → adjust → save → convert → share | Critical | None — users abandon |
| 2 | Per-page confirmation tap kills multi-page scan jobs (20–50 pages) | Critical | Rescan repeatedly |
| 3 | Exported PDFs are 20–30 MB — rejected by university and government portals | Critical | Compress with a second app |
| 4 | Watermarks on free tier appear on official documents | Critical | Pay subscription or use competitor |
| 5 | No direct share — must find PDF in file manager first | High | None |
| 6 | Documents uploaded to vendor cloud — privacy concern | High | No privacy-respecting alternative |
| 7 | Blurred page requires rescanning the entire document | High | Rescan everything |
| 8 | Gallery images cannot be batch-converted to PDF | High | Install second app |
| 9 | No built-in PDF toolkit — merge/split requires a separate app | Medium | iLovePDF (web/app) |
| 10 | Poor document organisation — filenames like Scan001.pdf | Medium | Manual file manager |

### Market gap

Top competitors (CamScanner, Adobe Scan, Microsoft Lens) share the same structural weakness: they monetise by gating watermark removal, compressing quality, or requiring cloud accounts. ZeScan exploits this gap with a **trust-first, offline-first** positioning.

---

## 3. Target Users

### Primary: The Student

- Age 16–24, Android device, South Asia / MENA / Southeast Asia primary markets
- Scans lecture notes, assignments, past papers
- Needs: fast multi-page scan, small PDFs for university portals, WhatsApp sharing
- Pain: watermarks on submitted assignments, 30 MB files rejected by LMS

### Secondary: The Freelancer / SME Professional

- Age 25–40, scans contracts, receipts, ID documents
- Needs: privacy (no cloud upload), clean output, folder organisation
- Pain: trust concerns uploading sensitive documents to CamScanner servers

### Tertiary: The General User

- Uses gallery import to batch-convert existing photos to PDF
- Shares via email or WhatsApp
- No scanner experience needed

---

## 4. Goals & Success Metrics

### Business goals

- Reach 10,000 installs within 60 days of launch
- Achieve 4.3+ Play Store rating within 90 days
- Reach 500 daily active users by end of month 3
- Monetise via AdMob (free tier) + one-time Pro unlock ($2.99)

### Product goals

| Goal | Metric | Target |
|------|--------|--------|
| Fast scan flow | Time from open app to PDF shared | Under 30 seconds |
| PDF size reduction | File size vs uncompressed baseline | 60–85% smaller at Medium quality |
| Retention | Day-7 retention | ≥ 25% |
| Crash-free rate | Sessions without crash | ≥ 99% |
| Privacy | Network calls during scan/export | Zero |

---

## 5. Non-Goals (MVP)

The following are explicitly out of scope for v1.0 and will be evaluated post-launch:

- iOS support (ML Kit Document Scanner is Android-only; iOS requires VisionKit — separate project)
- OCR / text recognition (post-MVP, adds significant complexity)
- Cloud sync or backup (contradicts privacy positioning)
- AI-powered document naming or categorisation
- Signature capture or form filling
- Team / multi-user collaboration
- Web app or desktop client
- Subscription pricing (one-time Pro unlock only for v1)

---

## 6. User Stories

### Core scan flow

> **US-01** — As a student, I want to open the app and scan multiple pages without confirming each one, so I can scan a 30-page assignment in under 2 minutes.

> **US-02** — As a user, I want the app to automatically detect document edges and correct perspective, so I don't need to manually crop every page.

> **US-03** — As a user, I want to choose Low / Medium / High export quality with a file size preview before generating the PDF, so I know if it will fit within a portal's upload limit.

> **US-04** — As a user, I want to share the PDF directly to WhatsApp, Gmail, or Telegram immediately after it's generated, without navigating to the file manager.

### Gallery & batch

> **US-05** — As a student, I want to select 50 existing photos from my gallery and convert them into a single ordered PDF, so I can compile lecture images I already have.

> **US-06** — As a user, I want to reorder pages by dragging before generating the PDF, so the final output is in the correct sequence.

### Per-page control

> **US-07** — As a user, I want to retake or replace a single blurred page without rescanning the entire document.

> **US-08** — As a user, I want to delete individual pages from the preview before export.

### Organisation

> **US-09** — As a returning user, I want to save documents into named folders (Assignments, Receipts, Personal, Office), so I can find them 3 months later.

> **US-10** — As a user, I want to search documents by filename and mark frequently used documents as favourites.

### PDF toolkit

> **US-11** — As a user, I want to merge two existing PDFs into one without installing a second app.

> **US-12** — As a user, I want to split a PDF by page range, rotate pages, and delete unwanted pages from an existing PDF.

> **US-13** — As a user, I want to compress an existing PDF with a quality/size preview before saving.

### Privacy & trust

> **US-14** — As a privacy-conscious user, I want confirmation that the app never uploads my documents to any server, so I can scan sensitive documents (ID, contracts) with confidence.

---

## 7. Feature Specifications

### F-01 — Camera Scan (Single & Continuous)

**Description:** Launch ML Kit Document Scanner. Auto-detect edges, apply perspective correction and enhancement. Support single-page and continuous (multi-page) modes.

**Behaviour:**
- Single mode: scan one page → go to preview
- Continuous mode: scan page → auto-capture → continue scanning → user taps Done → go to preview
- ML Kit handles auto-crop, perspective warp, and brightness enhancement natively
- Hard limit: 50 pages per document (memory safety)
- If ML Kit model not yet downloaded, show inline download progress (one-time, ~4 MB)

**Acceptance criteria:**
- App opens camera in ≤ 1.5 seconds on mid-range Android
- Continuous mode captures pages without any confirmation tap between pages
- Perspective-corrected output is saved as JPEG per page

---

### F-02 — Gallery Import & Batch Convert

**Description:** Select one or more images from device gallery. Convert directly to PDF without rescanning.

**Behaviour:**
- Native multi-image picker (Android Photo Picker API on API 33+, legacy on older)
- Images presented in selection order on preview screen
- User can reorder, delete, or replace any image before export
- No limit on image count enforced at picker; 50-image recommended limit shown as soft warning

**Acceptance criteria:**
- 50-image import completes preview render in ≤ 3 seconds on mid-range device
- Images appear in the same order as selected

---

### F-03 — Preview & Page Management

**Description:** After scanning or importing, user sees a horizontal scrollable page strip before export.

**Controls per page:**
- Tap edit icon → bottom sheet with: Retake (camera), Replace (gallery), Delete
- Long-press → same bottom sheet
- Drag to reorder (ReorderableListView)

**Acceptance criteria:**
- Page reorder reflects immediately without re-rendering the PDF
- Retaking page 7 in a 20-page document does not affect pages 1–6 or 8–20
- Deleted pages are removed immediately with no confirmation dialog (undo not required in MVP)

---

### F-04 — PDF Generation with Compression

**Description:** Convert scanned/imported images to a single PDF with user-selected quality.

**Quality tiers:**

| Tier | JPEG quality | Target use case | Typical size (15 pages) |
|------|-------------|-----------------|-------------------------|
| Low | 40% | University portals, government forms | ~1–2 MB |
| Medium | 70% | Email, WhatsApp (default) | ~3–5 MB |
| High | 95% | Archiving, printing | ~10–15 MB |

**Behaviour:**
- Size estimates for all three tiers are computed concurrently in background while user is on preview screen
- Estimates displayed as "~X MB" alongside each quality option before user taps Generate
- Progress indicator (0–100%) shown during generation
- All processing is on-device — no network calls at any point
- Output saved to app private directory (no storage permission required)

**Acceptance criteria:**
- 15-page Medium-quality PDF generates in ≤ 8 seconds on mid-range Android
- Size estimates are within ±15% of actual output size
- Generated PDF opens correctly in Google Drive, WPS, and Adobe Reader

---

### F-05 — Direct Share Sheet

**Description:** Immediately after PDF generation, present share options without requiring file manager navigation.

**Share targets shown as quick buttons:**
- WhatsApp
- Gmail
- Google Drive
- Telegram
- "More…" → native Android share sheet

**Behaviour:**
- All four quick-share buttons invoke the native share intent with the PDF pre-attached as `application/pdf`
- "More…" opens the full native share sheet
- User can also share from the document library at any time

**Acceptance criteria:**
- WhatsApp receives the PDF as a file attachment (not a link)
- Share sheet appears in ≤ 500 ms after PDF generation completes

---

### F-06 — No Watermark (All Tiers)

**Description:** ZeScan does not watermark any PDF output on any pricing tier, ever.

**This is a positioning commitment, not a feature toggle.** The codebase must not contain any watermark injection logic. This must be stated explicitly on the Play Store listing and the website.

---

### F-07 — 100% On-Device Processing

**Description:** All scanning, image processing, and PDF generation happens locally on the device.

**Requirements:**
- No network calls during scan, processing, or export
- No user account required to use any core feature
- No analytics SDKs that transmit document content
- AdMob (if integrated) fetches ad creatives only — document data never leaves the device
- Privacy policy (hosted at zescan.zeppelinlabs.digital/privacy) must explicitly state: "ZeScan does not transmit, store, or process your documents on any server."

**Acceptance criteria:**
- Charles Proxy or Network inspector shows zero document-related outbound requests during a full scan-to-share flow

---

### F-08 — Per-Page Retake & Replace

**Description:** Replace any single page in a document without rescanning the full document.

**Behaviour:**
- Available from preview screen (edit icon per page)
- Two replacement sources: camera (opens ML Kit single-page scan) or gallery (opens image picker for one image)
- Replaced page takes the same position in the sequence

**Acceptance criteria:**
- Replacing page 7 of 20 preserves pages 1–6 and 8–20 unchanged
- Retake from camera applies same auto-crop and perspective correction as original scan

---

### F-09 — Document Library & Organisation

**Description:** Persistent local storage of all generated PDFs with basic organisation.

**Features:**
- Document list: name, date, file size, page count, folder badge
- Default folders: Assignments, Receipts, Personal, Office
- Custom folder creation (rename, delete)
- Favourites (star) — shown in a Favourites filter
- Recents — last 10 opened documents, always visible at top
- Search by filename (local, instant, no server)
- Rename document inline
- Delete document (with confirmation dialog)
- Long-press multi-select for bulk delete or bulk move to folder

**Data model:** Hive local database. Stores metadata only (path, name, folder, size, dates). PDF files stored in app private directory.

**Acceptance criteria:**
- Search returns results as user types with ≤ 100 ms latency
- Document survives app restart (persisted to Hive)
- Deleting a document removes both the Hive record and the PDF file from storage

---

### F-10 — PDF Toolkit

**Description:** Post-generation PDF manipulation. Covers the tools users currently install iLovePDF for.

**Tools included in MVP:**

| Tool | Description |
|------|-------------|
| Merge | Combine two or more PDFs from the library into one |
| Split | Extract a page range from a PDF into a new file |
| Compress | Re-compress an existing PDF with quality/size preview |
| Rotate pages | Rotate individual or all pages 90°/180°/270° |
| Delete pages | Remove specific pages from an existing PDF |
| Reorder pages | Drag-and-drop page reordering in an existing PDF |

**Behaviour:**
- All toolkit operations are on-device (syncfusion_flutter_pdf)
- Output saved as a new file — original is never overwritten unless user explicitly confirms
- Compress tool shows the same Low / Medium / High picker with size estimates

**Acceptance criteria:**
- Merge of two 10-page PDFs completes in ≤ 3 seconds
- Split preserves original document in library
- All operations produce valid PDF output confirmed by Adobe Reader

---

## 8. Technical Architecture

### Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter  |
| Scanner | google_mlkit_document_scanner  |
| PDF generation & toolkit | syncfusion_flutter_pdf  |
| Image processing | image  |
| Local database | hive_flutter  + hive  |
| File sharing | share_plus  |
| Gallery picker | image_picker  |
| Permissions | permission_handler  |
| Ads (free tier) | google_mobile_ads |
| In-app purchase | in_app_purchase  |
| Unique IDs | uuid  |
| File paths | path_provider  |

### Architecture pattern

Feature-based folder structure with `ChangeNotifier` state management (no Riverpod or Bloc required for MVP scope).

```
lib/
├── core/
│   ├── models/         # Document, Folder (Hive models)
│   ├── db/             # HiveService
│   └── permissions.dart
├── features/
│   ├── scanner/
│   │   ├── scanner_service.dart      # ML Kit + PDF gen
│   │   ├── scanner_controller.dart   # ChangeNotifier
│   │   ├── scanner_screen.dart       # Entry point
│   │   └── preview_screen.dart       # Page management + export
│   ├── library/
│   │   ├── library_screen.dart
│   │   └── library_controller.dart
│   └── toolkit/
│       ├── toolkit_screen.dart
│       └── toolkit_service.dart
└── main.dart
```

### Android requirements

- `minSdkVersion 21` (ML Kit requirement)
- `targetSdkVersion 34`
- Permissions: `CAMERA`, `READ_MEDIA_IMAGES` (API 33+), `READ_EXTERNAL_STORAGE` (API ≤ 32)
- FileProvider configured for share_plus PDF sharing
- ML Kit scanner Activity declared in `AndroidManifest.xml`
- No `google-services.json` required (ML Kit standalone, no Firebase)

### Data storage

- PDFs: App private directory (`getApplicationDocumentsDirectory()`) — no storage permission needed
- Metadata: Hive box (`documents`) — name, path, folder, size, pageCount, createdAt, isFavorite
- No cloud sync. No remote backup.

### Privacy architecture

- Zero outbound network requests for any document operation
- AdMob fetches only ad creatives (standard, no document data)
- No analytics SDK with document access
- Privacy policy URL: `zescan.zeppelinlabs.digital/privacy`

---

## 9. Monetisation Model

### Free tier (default)

- All 10 core features fully functional
- No watermark
- No account required
- Scan limit: 5 scans per day
- AdMob banner ad on library screen and home screen
- PDF toolkit: merge and compress only

### Pro tier — $2.99 one-time purchase

- Unlimited scans
- All PDF toolkit tools (split, rotate, delete pages, reorder)
- Remove all ads
- Priority processing (no artificial delay)
- Continuous scan mode unlocked (free tier: 10-page cap)

### Revenue model (projections at 500 DAU)

| Source | Estimate |
|--------|----------|
| AdMob (banner, ~$0.50 eCPM) | ~$75/month |
| Pro conversions (2% of installs @ $2.99) | Variable |
| Combined target at 5,000 installs | ~$225/month |

### Pricing rationale

One-time purchase outperforms subscription for utility apps in target markets (South Asia, MENA). Subscription fatigue is measurable in review sentiment for competing apps. $2.99 price point is below the psychological barrier in primary markets while sustainable per conversion.

---

## 10. Design Principles

1. **Speed first.** Open app → share PDF in under 30 seconds. Every extra tap is a failure.
2. **Dark, clean, minimal.** Dark background (#0D0D0D). Purple accent (#5B4FE8). No decorative noise.
3. **Trust through transparency.** Privacy badge visible on home screen. No hidden permissions.
4. **No punishment for free users.** Ads only — no degraded output, no watermarks, no nagging paywalls during core workflows.
5. **On-device is the feature.** "100% On-Device" is hero copy, not fine print.

---

## 11. Launch Scope & Timeline

### Week 1–2 — Core MVP

- [ ] ML Kit camera scan (single + continuous mode)
- [ ] Auto-crop and perspective correction (ML Kit native)
- [ ] Gallery import (multi-image picker)
- [ ] PDF generation with Low / Medium / High quality
- [ ] Size estimation with preview before export
- [ ] Direct share sheet (WhatsApp, Gmail, Drive, Telegram, More)
- [ ] No watermark — confirmed in code review
- [ ] Zero network calls during scan/export — confirmed via proxy test

### Week 3 — Preview & Organisation

- [ ] Preview screen with page thumbnails
- [ ] Per-page retake (camera + gallery)
- [ ] Per-page delete
- [ ] Drag-to-reorder pages
- [ ] Document library (Hive)
- [ ] Folder organisation (4 default + custom)
- [ ] Favourites and Recents
- [ ] Filename search

### Week 4 — Toolkit, Monetisation & Launch

- [ ] PDF merge
- [ ] PDF split
- [ ] PDF compress (with size preview)
- [ ] Page rotate, delete, reorder on existing PDFs
- [ ] AdMob integration (free tier)
- [ ] In-app purchase (Pro unlock, $2.99)
- [ ] Play Store listing (screenshots, description, keywords)
- [ ] Privacy policy page live at zescan.zeppelinlabs.digital/privacy
- [ ] Internal beta (10 testers) → public launch

### Post-launch backlog (not MVP)

- iOS support (VisionKit)
- OCR / searchable PDF
- Document renaming suggestions
- PDF password protection
- iCloud / Google Drive backup (opt-in)
- Batch share (multiple PDFs in one operation)
- Widget (quick-scan shortcut)

---

## 12. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| ML Kit model download fails on first launch | Medium | High | Show friendly error with retry; cache model aggressively after first download |
| syncfusion_flutter_pdf license cost | Low | Medium | Community (free) license covers distribution; verify terms before launch |
| Play Store rejection (permissions) | Low | High | Only request permissions at point of use; document rationale in Play Console |
| Performance on low-RAM devices (1–2 GB) | Medium | High | Test on Redmi 9 class device; cap image resolution before PDF processing |
| AdMob account rejection | Low | Medium | Apply for AdMob early (week 1); fallback: launch without ads, add later |
| CamScanner complaint (branding) | Very low | Low | ZeScan name and branding is fully original |
| Large PDF crashes app on low-memory devices | Medium | High | Process pages in batches; dispose image objects after each page render |

---

## 13. Open Questions

| # | Question | Owner | Due |
|---|----------|-------|-----|
| Q1 | Does the syncfusion_flutter_pdf free (community) licence permit commercial distribution without royalty? | Dev | Week 1 |
| Q2 | What is the Play Store listing keyword strategy — "scanner", "PDF maker", "document scanner"? | Marketing | Week 3 |
| Q3 | Should the 5-scan/day free limit reset at midnight local time or on a rolling 24-hour window? | Product | Week 2 |
| Q4 | Is the privacy policy required before submitting to Play Store, or can it be added post-submission? | Legal/Dev | Week 1 |
| Q5 | Do we ship a web landing page at launch or after first 1,000 installs? | Zeppelin Labs | Week 2 |
| Q6 | Should continuous scan mode be free or Pro-only? Current decision: Pro-only (10-page cap on free). | Product | Decided — confirm before build |

---

*ZeScan is a Zeppelin Labs product. zescan.zeppelinlabs.digital*
