# ZeScan Landing Page

Professional landing page for ZeScan - A privacy-first document scanner and PDF toolkit.

## Features

### Design
- ✅ **Modern gradient design** with ZeScan brand blue (#2196F3)
- ✅ **Fully responsive** - Mobile, tablet, and desktop optimized
- ✅ **Smooth animations** using Framer Motion
- ✅ **Interactive elements** - Hover effects, auto-rotating features
- ✅ **Custom scrollbar** matching brand colors
- ✅ **Dark theme** with gradient backgrounds

### Sections
1. **Hero Section**
   - Eye-catching headline with gradient text
   - Play Store download badge
   - Feature pills (No account, Free forever, etc.)
   - App preview mockup with glow effect

2. **Features Section** (#features)
   - 4 key features: Privacy First, PDF Tools, Organize, No Watermarks
   - Interactive cards with auto-rotation
   - Detailed descriptions on hover

3. **PDF Tools Section** (#tools)
   - 3 main tools: Merge, Compress, Split
   - Gradient cards with unique colors per tool
   - Hover scale effects

4. **Download CTA Section** (#download)
   - Blue gradient background
   - Large Play Store badge
   - Key benefits summary

5. **Footer**
   - Logo and branding
   - Quick links
   - Download badge
   - Copyright info

## Tech Stack

- **Framework**: Next.js 16.2.7
- **Styling**: Tailwind CSS 4
- **Animations**: Framer Motion
- **Icons**: Lucide React
- **Language**: TypeScript
- **Package Manager**: npm

## Brand Colors

```css
Primary Blue:   #2196F3  /* Main brand color */
Light Blue:     #42A5F5  /* Hover states */
Dark Blue:      #1E88E5  /* Pressed states */
Success Green:  #10B981
Warning Amber:  #F59E0B
Danger Red:     #EF4444
Background:     #0a0a0a  /* Near black */
```

## Project Structure

```
zescan-web/
├── app/
│   ├── favicon.ico
│   ├── globals.css          # Global styles with custom scrollbar
│   ├── layout.tsx           # Root layout with metadata
│   └── page.tsx             # Landing page component
├── public/
│   ├── images/              # Logo and icon assets
│   │   ├── dark_mode_icon.png
│   │   ├── dark_mode_logo.png
│   │   ├── light_mode_icon.png
│   │   ├── light_mode_logo.png
│   │   └── splash_icon.png
│   └── illustrations/       # SVG illustrations
│       ├── Privacy policy-pana.svg
│       ├── undraw_file-bundle_oaof.svg
│       ├── undraw_my-files_1xwx.svg
│       └── File searching-pana.svg
├── package.json
├── tailwind.config.ts
├── tsconfig.json
└── README.md
```

## Getting Started

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) to view the site.

### Build

```bash
npm run build
```

Creates an optimized production build in `.next/`.

### Start Production Server

```bash
npm start
```

Runs the production build locally.

## Deployment

### Vercel (Recommended)

1. Push code to GitHub repository
2. Import project in Vercel dashboard
3. Deploy automatically

```bash
# Or use Vercel CLI
vercel --prod
```

### Other Platforms

The site is a static Next.js app and can be deployed to:
- **Netlify**: `npm run build` then deploy `.next/` folder
- **AWS S3 + CloudFront**: Export static files
- **Any Node.js hosting**: Run `npm start`

## Configuration

### Update Play Store Link

In `app/page.tsx`, update the package ID:

```tsx
href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
```

### Update Metadata

In `app/layout.tsx`:

```tsx
export const metadata: Metadata = {
  title: "Your Title",
  description: "Your Description",
  // ... other metadata
};
```

### Update Brand Colors

Colors are defined inline using Tailwind classes. The main brand color classes used:

```
bg-blue-500      (#3B82F6)
bg-blue-600      (#2563EB)
text-blue-400    (#60A5FA)
from-blue-500    (gradient start)
to-blue-600      (gradient end)
```

To change, search and replace these Tailwind classes in `page.tsx`.

## Assets

### Images Required
Place in `public/images/`:
- `dark_mode_icon.png` - App icon for dark theme
- `dark_mode_logo.png` - Full logo for dark theme  
- `light_mode_icon.png` - App icon for light theme
- `light_mode_logo.png` - Full logo for light theme
- `splash_icon.png` - Splash screen icon

### Illustrations
Place in `public/illustrations/`:
- SVG files for feature sections
- Recommended size: 800x600px

## Performance

- ✅ **Static Generation**: Pre-rendered at build time
- ✅ **Optimized Images**: Next.js Image component
- ✅ **Code Splitting**: Automatic by Next.js
- ✅ **Lazy Loading**: Framer Motion viewport triggers
- ✅ **Fast Load**: < 1s First Contentful Paint

## SEO

- ✅ Semantic HTML structure
- ✅ Meta tags for social sharing (Open Graph)
- ✅ Descriptive page title and description
- ✅ Keywords for search engines
- ✅ Mobile-friendly design
- ✅ Fast loading times

## Browser Support

- ✅ Chrome/Edge (latest)
- ✅ Firefox (latest)
- ✅ Safari (latest)
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## License

© 2024 ZeScan. All rights reserved.

## Support

For issues or questions about the landing page, please contact the development team.
