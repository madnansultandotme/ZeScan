'use client';

import { motion } from 'framer-motion';
import { Shield, Lock, Eye, Server, Database, FileCheck } from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';

export default function PrivacyPage() {
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
              <Link href="/features" className="hover:text-blue-400 transition">Features</Link>
              <Link href="/privacy" className="text-blue-400">Privacy</Link>
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
        <div className="max-w-4xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center mb-16"
          >
            <Shield className="w-16 h-16 mx-auto mb-6 text-blue-400" />
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              <span className="bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                Privacy Policy
              </span>
            </h1>
            <p className="text-xl text-gray-400">
              Your privacy is our top priority. Learn how ZeScan protects your data.
            </p>
            <p className="text-sm text-gray-500 mt-4">Last updated: June 6, 2024</p>
          </motion.div>

          {/* Privacy Highlights */}
          <div className="grid md:grid-cols-3 gap-6 mb-16">
            <div className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-xl p-6 border border-gray-700 text-center">
              <Lock className="w-10 h-10 mx-auto mb-3 text-blue-400" />
              <h3 className="font-bold mb-2">Local Processing</h3>
              <p className="text-sm text-gray-400">All data stays on your device</p>
            </div>
            <div className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-xl p-6 border border-gray-700 text-center">
              <Eye className="w-10 h-10 mx-auto mb-3 text-blue-400" />
              <h3 className="font-bold mb-2">No Tracking</h3>
              <p className="text-sm text-gray-400">Zero analytics or telemetry</p>
            </div>
            <div className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-xl p-6 border border-gray-700 text-center">
              <Server className="w-10 h-10 mx-auto mb-3 text-blue-400" />
              <h3 className="font-bold mb-2">No Cloud</h3>
              <p className="text-sm text-gray-400">No uploads to external servers</p>
            </div>
          </div>

          {/* Privacy Policy Content */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3 }}
            className="prose prose-invert max-w-none"
          >
            <div className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl p-8 border border-gray-700 space-y-8">
              
              <section>
                <h2 className="text-2xl font-bold text-white mb-4 flex items-center">
                  <Database className="w-6 h-6 mr-3 text-blue-400" />
                  Information We Collect
                </h2>
                <p className="text-gray-300 mb-4">
                  <strong className="text-white">ZeScan does NOT collect, store, or transmit any personal information.</strong>
                </p>
                <p className="text-gray-400">
                  The app operates entirely on your device. All scanned documents, PDFs, and user data remain in your local device storage. We have no access to your documents or any information about how you use the app.
                </p>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4 flex items-center">
                  <FileCheck className="w-6 h-6 mr-3 text-blue-400" />
                  Data Storage
                </h2>
                <ul className="space-y-3 text-gray-400">
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">Local Only:</strong> All documents are stored in your device's local storage</span>
                  </li>
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">Your Control:</strong> You can delete documents anytime through the app or device settings</span>
                  </li>
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">No Backup:</strong> We do not backup your documents to any cloud service</span>
                  </li>
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">Offline:</strong> The app works completely offline with no internet requirement</span>
                  </li>
                </ul>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4">Permissions</h2>
                <p className="text-gray-400 mb-4">ZeScan requests the following permissions:</p>
                <ul className="space-y-3 text-gray-400">
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">Camera:</strong> To capture document photos for scanning</span>
                  </li>
                  <li className="flex items-start">
                    <span className="text-blue-400 mr-2">•</span>
                    <span><strong className="text-white">Storage:</strong> To save scanned documents and PDFs to your device</span>
                  </li>
                </ul>
                <p className="text-gray-400 mt-4">
                  These permissions are used solely for the app's core functionality. No data is transmitted outside your device.
                </p>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4">Third-Party Services</h2>
                <p className="text-gray-400">
                  ZeScan does not integrate with any third-party analytics, advertising, or tracking services. The app does not contain any SDKs that collect or transmit user data.
                </p>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4">Children's Privacy</h2>
                <p className="text-gray-400">
                  ZeScan does not knowingly collect any information from anyone, including children under 13. The app can be safely used by users of all ages.
                </p>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4">Changes to This Policy</h2>
                <p className="text-gray-400">
                  We may update this privacy policy from time to time. Any changes will be posted on this page with an updated revision date.
                </p>
              </section>

              <section>
                <h2 className="text-2xl font-bold text-white mb-4">Contact Us</h2>
                <p className="text-gray-400">
                  If you have any questions about this privacy policy, please contact us through the app's settings or visit our support page.
                </p>
              </section>

              <div className="bg-blue-500/10 border border-blue-500/30 rounded-xl p-6 mt-8">
                <p className="text-blue-400 font-semibold mb-2">Privacy Guarantee</p>
                <p className="text-gray-300">
                  ZeScan is designed with privacy as the foundation. We will never compromise on this principle. Your documents are yours alone.
                </p>
              </div>
            </div>
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
