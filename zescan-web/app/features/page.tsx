'use client';

import { motion } from 'framer-motion';
import { Shield, Ban, Key, FileText, Minimize2, Split, Search, Scan, Lock, Zap, Smartphone, HardDrive } from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';

export default function FeaturesPage() {
  const features = [
    {
      icon: <Shield className="w-12 h-12" />,
      title: 'Privacy First',
      description: 'Your documents stay on your device. No cloud uploads, no data collection, no tracking.',
      details: [
        'All processing happens locally',
        'No internet connection required for scanning',
        'Your data never leaves your device',
        'Zero telemetry or analytics'
      ]
    },
    {
      icon: <Scan className="w-12 h-12" />,
      title: 'Professional Scanning',
      description: 'High-quality document scanning with automatic edge detection and perspective correction.',
      details: [
        'Auto edge detection',
        'Perspective correction',
        'Multiple filters (B&W, Color, Grayscale)',
        'Batch scanning support'
      ]
    },
    {
      icon: <FileText className="w-12 h-12" />,
      title: 'PDF Toolkit',
      description: 'Powerful PDF manipulation tools built right into the app.',
      details: [
        'Merge multiple PDFs',
        'Compress large files',
        'Split and extract pages',
        'No file size limits'
      ]
    },
    {
      icon: <Ban className="w-12 h-12" />,
      title: 'No Watermarks',
      description: 'Clean, professional documents without any watermarks or branding.',
      details: [
        'Completely free forever',
        'No premium unlock needed',
        'Professional output',
        'Share-ready documents'
      ]
    },
    {
      icon: <Search className="w-12 h-12" />,
      title: 'Smart Organization',
      description: 'Intuitive library with powerful search to find any document instantly.',
      details: [
        'Quick search by name',
        'Recent documents',
        'Favorites system',
        'Easy sorting and filtering'
      ]
    },
    {
      icon: <Key className="w-12 h-12" />,
      title: 'No Account Required',
      description: 'Start scanning immediately. No sign-up, no login, no hassle.',
      details: [
        'Install and use instantly',
        'No email required',
        'No password to remember',
        'Complete privacy'
      ]
    },
    {
      icon: <Zap className="w-12 h-12" />,
      title: 'Fast & Lightweight',
      description: 'Optimized performance with minimal battery and storage usage.',
      details: [
        'Small app size',
        'Fast processing',
        'Battery efficient',
        'Works on older devices'
      ]
    },
    {
      icon: <HardDrive className="w-12 h-12" />,
      title: 'Local Storage',
      description: 'All documents stored securely in your device storage.',
      details: [
        'Access anytime, anywhere',
        'Works offline',
        'No subscription needed',
        'You own your data'
      ]
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-gray-900 to-black text-white">
      {/* Navigation */}
      <nav className="fixed top-0 w-full z-50 backdrop-blur-lg bg-gray-900/80 border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="flex items-center space-x-3">
              <div className="relative w-10 h-10">
                <Image 
                  src="/images/dark_mode_icon.png"
                  alt="ZeScan Logo" 
                  fill
                  className="object-contain"
                />
              </div>
              <span className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                ZeScan
              </span>
            </Link>

            <div className="flex items-center space-x-8">
              <Link href="/" className="hover:text-blue-400 transition">Home</Link>
              <Link href="/features" className="text-blue-400">Features</Link>
              <Link href="/privacy" className="hover:text-blue-400 transition">Privacy</Link>
              <a 
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                target="_blank"
                rel="noopener noreferrer"
                className="bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 px-6 py-2 rounded-full transition shadow-lg shadow-blue-500/30"
              >
                Download
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-32 pb-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              <span className="bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                Powerful Features
              </span>
              <br />
              <span className="text-white">Built for You</span>
            </h1>
            <p className="text-xl text-gray-400 max-w-3xl mx-auto">
              Everything you need in a document scanner, designed with privacy and simplicity in mind.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Features Grid */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl p-8 border border-gray-700 hover:border-blue-500 transition-all duration-300 hover:shadow-lg hover:shadow-blue-500/20"
              >
                <div className="text-blue-400 mb-4">
                  {feature.icon}
                </div>
                <h3 className="text-2xl font-bold mb-3">{feature.title}</h3>
                <p className="text-gray-400 mb-4">{feature.description}</p>
                <ul className="space-y-2">
                  {feature.details.map((detail, idx) => (
                    <li key={idx} className="flex items-start space-x-2 text-sm text-gray-500">
                      <span className="text-blue-400 mt-1">•</span>
                      <span>{detail}</span>
                    </li>
                  ))}
                </ul>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-r from-blue-600 to-blue-500">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <h2 className="text-4xl md:text-5xl font-bold mb-4 text-white">
              Ready to Try ZeScan?
            </h2>
            <p className="text-xl text-blue-50 mb-8">
              Experience all these features for free. No account required.
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
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-4 sm:px-6 lg:px-8 border-t border-gray-800 bg-black">
        <div className="max-w-7xl mx-auto text-center text-gray-400">
          <div className="flex items-center justify-center space-x-3 mb-4">
            <div className="relative w-8 h-8">
              <Image 
                src="/images/dark_mode_icon.png"
                alt="ZeScan Logo" 
                fill
                className="object-contain"
              />
            </div>
            <span className="text-xl font-bold text-white">ZeScan</span>
          </div>
          <div className="flex justify-center space-x-6 mb-4 text-sm">
            <Link href="/" className="hover:text-blue-400 transition">Home</Link>
            <Link href="/features" className="hover:text-blue-400 transition">Features</Link>
            <Link href="/privacy" className="hover:text-blue-400 transition">Privacy Policy</Link>
          </div>
          <p className="text-sm">© 2024 ZeScan. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
