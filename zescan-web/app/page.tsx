'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import Link from 'next/link';
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
  ChevronRight,
  Check,
  Scan
} from 'lucide-react';
import Image from 'next/image';

export default function LandingPage() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const features = [
    {
      icon: <Shield className="w-8 h-8" />,
      title: 'Privacy First',
      description: 'Your documents stay secure and private',
      detail: 'All processing happens locally on your device. No cloud uploads, no data collection, no tracking.'
    },
    {
      icon: <FileText className="w-8 h-8" />,
      title: 'Powerful PDF Tools',
      description: 'Merge, compress, and split PDFs easily',
      detail: 'Professional-grade PDF manipulation tools built right into the app. Merge multiple PDFs, compress large files, or extract specific pages.'
    },
    {
      icon: <Search className="w-8 h-8" />,
      title: 'Organize Documents',
      description: 'Keep all your scans in one place',
      detail: 'Intuitive library with search functionality. Find any document instantly and keep everything organized.'
    },
    {
      icon: <Ban className="w-8 h-8" />,
      title: 'No Watermarks',
      description: 'Clean, professional documents every time',
      detail: 'Unlike other scanners, ZeScan never adds watermarks to your documents. What you scan is what you get - clean and professional.'
    }
  ];

  const pdfTools = [
    {
      icon: <FileText className="w-6 h-6" />,
      title: 'Merge PDFs',
      description: 'Combine multiple files into one document',
      color: 'from-blue-500 to-blue-600'
    },
    {
      icon: <Minimize2 className="w-6 h-6" />,
      title: 'Compress PDF',
      description: 'Reduce document file size',
      color: 'from-green-500 to-emerald-600'
    },
    {
      icon: <Split className="w-6 h-6" />,
      title: 'Split PDF',
      description: 'Extract specific pages from document',
      color: 'from-amber-500 to-orange-600'
    }
  ];

  const benefits = [
    'No account required',
    'Free to use forever',
    'No ads interruption',
    'Fast & lightweight',
    'Dark mode support',
    'Secure & private'
  ];

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-gray-900 to-black text-white">
      {/* Navigation */}
      <nav className="fixed top-0 w-full z-50 backdrop-blur-lg bg-gray-900/80 border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-3">
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
            </div>

            {/* Desktop Menu */}
            <div className="hidden md:flex items-center space-x-8">
              <a href="#features" className="hover:text-blue-400 transition">Features</a>
              <a href="#tools" className="hover:text-blue-400 transition">PDF Tools</a>
              <a href="#download" className="hover:text-blue-400 transition">Download</a>
              <Link href="/contact" className="hover:text-blue-400 transition">Contact</Link>
              <a 
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                target="_blank"
                rel="noopener noreferrer"
                className="bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 px-6 py-2 rounded-full transition flex items-center space-x-2 shadow-lg shadow-blue-500/30"
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
          <motion.div 
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            className="md:hidden bg-gray-900 border-t border-gray-800"
          >
            <div className="px-4 py-4 space-y-4">
              <a href="#features" className="block hover:text-blue-400" onClick={() => setMobileMenuOpen(false)}>Features</a>
              <a href="#tools" className="block hover:text-blue-400" onClick={() => setMobileMenuOpen(false)}>PDF Tools</a>
              <a href="#download" className="block hover:text-blue-400" onClick={() => setMobileMenuOpen(false)}>Download</a>
              <Link href="/contact" className="block hover:text-blue-400" onClick={() => setMobileMenuOpen(false)}>Contact</Link>
            </div>
          </motion.div>
        )}
      </nav>

      {/* Hero Section */}
      <section className="pt-32 pb-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
        {/* Animated background */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 w-96 h-96 bg-blue-500 rounded-full opacity-10 blur-3xl"></div>
          <div className="absolute -bottom-40 -left-40 w-96 h-96 bg-blue-600 rounded-full opacity-10 blur-3xl"></div>
        </div>

        <div className="max-w-7xl mx-auto relative z-10">
          <div className="text-center">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <div className="inline-flex items-center space-x-2 bg-blue-500/10 border border-blue-500/20 rounded-full px-4 py-2 mb-6">
                <Scan className="w-4 h-4 text-blue-400" />
                <span className="text-sm text-blue-400">Professional Document Scanner</span>
              </div>

              <h1 className="text-5xl md:text-7xl font-bold mb-6">
                <span className="bg-gradient-to-r from-blue-400 via-blue-500 to-blue-600 text-transparent bg-clip-text">
                  Document Scanning
                </span>
                <br />
                <span className="text-white">Made Simple</span>
              </h1>
              
              <p className="text-xl md:text-2xl text-gray-400 mb-8 max-w-3xl mx-auto">
                A privacy-first document scanner with powerful PDF tools. 
                Scan, organize, and manage documents without watermarks or accounts.
              </p>
              
              {/* Download Buttons */}
              <div className="flex flex-col sm:flex-row justify-center items-center gap-4 mb-12">
                <a 
                  href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-block transform hover:scale-105 transition"
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

              {/* Benefits Pills */}
              <div className="flex flex-wrap justify-center gap-3 mb-16">
                {benefits.map((benefit, index) => (
                  <motion.div
                    key={benefit}
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: index * 0.1 }}
                    className="flex items-center space-x-2 bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-full px-4 py-2"
                  >
                    <Check className="w-4 h-4 text-blue-400" />
                    <span className="text-sm text-gray-300">{benefit}</span>
                  </motion.div>
                ))}
              </div>

              {/* App Preview */}
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.3, duration: 0.6 }}
                className="relative mx-auto max-w-sm md:max-w-md"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-blue-600 rounded-3xl blur-3xl opacity-20"></div>
                <div className="relative bg-gradient-to-b from-gray-800 to-gray-900 rounded-3xl p-4 border border-gray-700 shadow-2xl">
                  <div className="relative w-full aspect-[9/16] rounded-2xl overflow-hidden bg-gray-900">
                    <Image 
                      src="/images/splash_icon.png"
                      alt="ZeScan App Preview" 
                      fill
                      className="object-contain p-8"
                    />
                  </div>
                </div>
              </motion.div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-b from-black to-gray-900">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <h2 className="text-4xl md:text-5xl font-bold mb-4">
                Why Choose <span className="text-blue-400">ZeScan</span>?
              </h2>
              <p className="text-xl text-gray-400">
                Everything you need in a document scanner
              </p>
            </motion.div>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl p-6 border border-gray-700 hover:border-blue-500 transition-all duration-300 cursor-pointer hover:shadow-lg hover:shadow-blue-500/20 hover:scale-105"
              >
                <div className="text-blue-400 mb-4">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-bold mb-2">{feature.title}</h3>
                <p className="text-gray-400 text-sm mb-3">{feature.description}</p>
                <p className="text-gray-500 text-xs">{feature.detail}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* PDF Tools Section */}
      <section id="tools" className="py-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-gray-900 to-black"></div>
        
        <div className="max-w-7xl mx-auto relative z-10">
          <div className="text-center mb-16">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
            >
              <h2 className="text-4xl md:text-5xl font-bold mb-4">
                Powerful <span className="text-blue-400">PDF Toolkit</span>
              </h2>
              <p className="text-xl text-gray-400">
                Professional PDF utilities built-in
              </p>
            </motion.div>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {pdfTools.map((tool, index) => (
              <motion.div
                key={tool.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group"
              >
                <div className={`bg-gradient-to-br ${tool.color} rounded-2xl p-8 shadow-xl transform transition-all duration-300 hover:scale-105 hover:shadow-2xl`}>
                  <div className="text-white mb-4 transform transition-transform group-hover:scale-110">
                    {tool.icon}
                  </div>
                  <h3 className="text-2xl font-bold mb-2 text-white">{tool.title}</h3>
                  <p className="text-white/90">{tool.description}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="py-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-r from-blue-600 via-blue-500 to-blue-600"></div>
        
        <div className="max-w-4xl mx-auto text-center relative z-10">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <Smartphone className="w-16 h-16 mx-auto mb-6 text-white" />
            <h2 className="text-4xl md:text-5xl font-bold mb-4 text-white">
              Ready to Get Started?
            </h2>
            <p className="text-xl text-blue-50 mb-8">
              Download ZeScan now and experience document scanning like never before
            </p>
            
            <a 
              href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block transform hover:scale-105 transition"
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
      <footer className="py-12 px-4 sm:px-6 lg:px-8 border-t border-gray-800 bg-black">
        <div className="max-w-7xl mx-auto">
          <div className="grid md:grid-cols-3 gap-8 mb-8">
            <div>
              <div className="flex items-center space-x-3 mb-4">
                <div className="relative w-8 h-8">
                  <Image 
                    src="/images/dark_mode_icon.png"
                    alt="ZeScan Logo" 
                    fill
                    className="object-contain"
                  />
                </div>
                <span className="text-xl font-bold bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                  ZeScan
                </span>
              </div>
              <p className="text-gray-400 text-sm">
                A privacy-first document scanner and PDF toolkit
              </p>
            </div>
            
            <div>
              <h3 className="font-bold mb-4">Company</h3>
              <ul className="space-y-2 text-sm text-gray-400">
                <li><a href="#features" className="hover:text-blue-400 transition">Features</a></li>
                <li><a href="#tools" className="hover:text-blue-400 transition">PDF Tools</a></li>
                <li><Link href="/privacy" className="hover:text-blue-400 transition">Privacy Policy</Link></li>
                <li><Link href="/contact" className="hover:text-blue-400 transition">Contact Us</Link></li>
              </ul>
            </div>
            
            <div>
              <h3 className="font-bold mb-4">Download</h3>
              <a 
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-block"
              >
                <Image 
                  src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
                  alt="Get it on Google Play"
                  width={150}
                  height={45}
                  className="h-12 w-auto"
                />
              </a>
            </div>
          </div>
          
          <div className="text-center pt-8 border-t border-gray-800">
            <p className="text-sm text-gray-400">
              © 2024 ZeScan. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
