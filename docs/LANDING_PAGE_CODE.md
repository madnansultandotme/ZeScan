# ZeScan Landing Page - Next.js Implementation

## 1. Copy Assets from Flutter Project

Copy these folders from the Flutter project to Next.js:

```bash
# From d:\zescan\assets\images\ to d:\zescan-web\public\images\
# Copy all icon files:
- light_mode_icon.png
- dark_mode_icon.png
- light_mode_logo.png
- dark_mode_logo.png
- splash_icon.png

# From d:\zescan\assets\illustrations\ to d:\zescan-web\public\illustrations\
# Copy all SVG files:
- Privacy policy-pana.svg
- undraw_file-bundle_oaof.svg
- undraw_my-files_1xwx.svg
- File searching-pana.svg
- Organizing projects-amico.svg
```

## 2. Install Dependencies

```bash
cd d:\zescan-web
npm install framer-motion lucide-react
```

## 3. Landing Page Component

Create `app/page.tsx`:

```tsx
'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  Shield, 
  Ban, 
  Key, 
  FileText, 
  Minimize2, 
  Split, 
  Search,
  Smartphone,
  Download,
  Menu,
  X,
  ChevronRight
} from 'lucide-react';
import Image from 'next/image';

export default function LandingPage() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [isDark, setIsDark] = useState(true);

  useEffect(() => {
    // Check system preference
    const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    setIsDark(darkModeMediaQuery.matches);
  }, []);

  const features = [
    {
      icon: <Shield className="w-8 h-8" />,
      title: 'Privacy First',
      description: 'Your documents stay secure and private',
      image: '/illustrations/Privacy policy-pana.svg'
    },
    {
      icon: <FileText className="w-8 h-8" />,
      title: 'Powerful PDF Tools',
      description: 'Merge, compress, and split PDFs easily',
      image: '/illustrations/undraw_file-bundle_oaof.svg'
    },
    {
      icon: <Search className="w-8 h-8" />,
      title: 'Organize Documents',
      description: 'Keep all your scans in one place',
      image: '/illustrations/undraw_my-files_1xwx.svg'
    },
    {
      icon: <Ban className="w-8 h-8" />,
      title: 'No Watermarks',
      description: 'Clean, professional documents every time',
      image: '/illustrations/File searching-pana.svg'
    }
  ];

  const pdfTools = [
    {
      icon: <FileText className="w-6 h-6" />,
      title: 'Merge PDFs',
      description: 'Combine multiple files into one document'
    },
    {
      icon: <Minimize2 className="w-6 h-6" />,
      title: 'Compress PDF',
      description: 'Reduce document file size'
    },
    {
      icon: <Split className="w-6 h-6" />,
      title: 'Split PDF',
      description: 'Extract specific pages from document'
    }
  ];

  return (
    <div className={`min-h-screen ${isDark ? 'bg-gray-900 text-white' : 'bg-gray-50 text-gray-900'}`}>
      {/* Navigation */}
      <nav className="fixed top-0 w-full z-50 backdrop-blur-lg bg-opacity-80 border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
              <Image 
                src={isDark ? "/images/dark_mode_icon.png" : "/images/light_mode_icon.png"}
                alt="ZeScan Logo" 
                width={40} 
                height={40}
              />
              <span className="text-2xl font-bold">ZeScan</span>
            </div>

            {/* Desktop Menu */}
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="hover:text-indigo-400 transition">Features</a>
              <a href="#tools" className="hover:text-indigo-400 transition">PDF Tools</a>
              <a href="#download" className="hover:text-indigo-400 transition">Download</a>
              <a 
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                className="bg-indigo-600 hover:bg-indigo-700 px-6 py-2 rounded-full transition flex items-center space-x-2"
              >
                <Download className="w-4 h-4" />
                <span>Get App</span>
              </a>
            </div>

            {/* Mobile Menu Button */}
            <button 
              className="md:hidden"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            >
              {mobileMenuOpen ? <X /> : <Menu />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {mobileMenuOpen && (
          <div className="md:hidden bg-gray-900 border-t border-gray-800">
            <div className="px-4 py-4 space-y-4">
              <a href="#features" className="block hover:text-indigo-400">Features</a>
              <a href="#tools" className="block hover:text-indigo-400">PDF Tools</a>
              <a href="#download" className="block hover:text-indigo-400">Download</a>
            </div>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section className="pt-32 pb-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-indigo-400 to-purple-600 text-transparent bg-clip-text">
              Document Scanning
              <br />
              Made Simple
            </h1>
            <p className="text-xl md:text-2xl text-gray-400 mb-8 max-w-3xl mx-auto">
              A privacy-first document scanner with powerful PDF tools. 
              Scan, organize, and manage documents without watermarks or accounts.
            </p>
            
            {/* Download Buttons */}
            <div className="flex flex-col sm:flex-row justify-center items-center gap-4">
              <a 
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-block"
              >
                <Image 
                  src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
                  alt="Get it on Google Play"
                  width={200}
                  height={60}
                  className="h-16 w-auto"
                />
              </a>
            </div>

            {/* App Preview */}
            <motion.div
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="mt-16 relative"
            >
              <div className="relative mx-auto max-w-sm md:max-w-md">
                <div className="absolute inset-0 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-3xl blur-3xl opacity-30"></div>
                <div className="relative bg-gray-800 rounded-3xl p-4 border border-gray-700">
                  <Image 
                    src={isDark ? "/images/dark_mode_logo.png" : "/images/light_mode_logo.png"}
                    alt="ZeScan App Preview" 
                    width={400} 
                    height={800}
                    className="rounded-2xl"
                  />
                </div>
              </div>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 px-4 sm:px-6 lg:px-8 bg-gray-800 bg-opacity-50">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Why Choose ZeScan?
            </h2>
            <p className="text-xl text-gray-400">
              Everything you need in a document scanner
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="bg-gray-900 bg-opacity-50 backdrop-blur-lg rounded-2xl p-6 border border-gray-700 hover:border-indigo-500 transition"
              >
                <div className="text-indigo-400 mb-4">{feature.icon}</div>
                <h3 className="text-xl font-bold mb-2">{feature.title}</h3>
                <p className="text-gray-400">{feature.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* PDF Tools Section */}
      <section id="tools" className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl md:text-5xl font-bold mb-4">
              Powerful PDF Toolkit
            </h2>
            <p className="text-xl text-gray-400">
              Professional PDF utilities built-in
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {pdfTools.map((tool, index) => (
              <motion.div
                key={tool.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="bg-gradient-to-br from-indigo-600 to-purple-600 rounded-2xl p-8"
              >
                <div className="text-white mb-4">{tool.icon}</div>
                <h3 className="text-2xl font-bold mb-2 text-white">{tool.title}</h3>
                <p className="text-indigo-100">{tool.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-r from-indigo-600 to-purple-600">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <Smartphone className="w-16 h-16 mx-auto mb-6 text-white" />
            <h2 className="text-4xl md:text-5xl font-bold mb-4 text-white">
              Ready to Get Started?
            </h2>
            <p className="text-xl text-indigo-100 mb-8">
              Download ZeScan now and experience document scanning like never before
            </p>
            
            <a 
              href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block"
            >
              <Image 
                src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
                alt="Get it on Google Play"
                width={250}
                height={75}
                className="h-20 w-auto"
              />
            </a>

            <div className="mt-8 flex flex-wrap justify-center gap-8 text-white">
              <div className="flex items-center space-x-2">
                <Shield className="w-5 h-5" />
                <span>Privacy First</span>
              </div>
              <div className="flex items-center space-x-2">
                <Ban className="w-5 h-5" />
                <span>No Watermarks</span>
              </div>
              <div className="flex items-center space-x-2">
                <Key className="w-5 h-5" />
                <span>No Account Required</span>
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-4 sm:px-6 lg:px-8 border-t border-gray-800">
        <div className="max-w-7xl mx-auto text-center text-gray-400">
          <div className="flex items-center justify-center space-x-3 mb-4">
            <Image 
              src={isDark ? "/images/dark_mode_icon.png" : "/images/light_mode_icon.png"}
              alt="ZeScan Logo" 
              width={32} 
              height={32}
            />
            <span className="text-xl font-bold text-white">ZeScan</span>
          </div>
          <p className="mb-4">
            A privacy-first document scanner and PDF toolkit
          </p>
          <p className="text-sm">
            © 2024 ZeScan. All rights reserved.
          </p>
        </div>
      </footer>
    </div>
  );
}
```

## 4. Update Tailwind Config

Make sure `tailwind.config.js` includes:

```js
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## 5. Update Global CSS

In `app/globals.css`:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

html {
  scroll-behavior: smooth;
}
```

## 6. Commands to Run

```bash
# Copy assets (run from d:\zescan directory)
xcopy assets\images d:\zescan-web\public\images /E /I
xcopy assets\illustrations d:\zescan-web\public\illustrations /E /I

# Install dependencies
cd d:\zescan-web
npm install framer-motion lucide-react

# Run development server
npm run dev

# Build for production
npm run build
```

## 7. Features Included

✅ Responsive navigation with mobile menu
✅ Hero section with app preview
✅ Features section (4 key features)
✅ PDF Tools showcase
✅ Download section with Play Store badge
✅ Footer with branding
✅ Smooth scroll animations
✅ Dark mode support
✅ Framer Motion animations
✅ SEO-friendly structure

## 8. Next Steps

1. Copy assets to Next.js project
2. Replace the code in `app/page.tsx`
3. Install dependencies
4. Run `npm run dev`
5. Deploy to Vercel or your hosting platform
