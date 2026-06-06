'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import { MessageSquare, Lightbulb, Bug, Send, CheckCircle, Loader2 } from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';

export default function ContactPage() {
  const [formData, setFormData] = useState({
    type: 'feedback' as 'feedback' | 'feature_request' | 'bug_report',
    email: '',
    subject: '',
    message: '',
    appVersion: '',
    deviceInfo: '',
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [errorMessage, setErrorMessage] = useState('');

  const feedbackTypes = [
    {
      id: 'feedback' as const,
      icon: <MessageSquare className="w-6 h-6" />,
      title: 'General Feedback',
      description: 'Share your thoughts and suggestions',
    },
    {
      id: 'feature_request' as const,
      icon: <Lightbulb className="w-6 h-6" />,
      title: 'Feature Request',
      description: 'Suggest a new feature or improvement',
    },
    {
      id: 'bug_report' as const,
      icon: <Bug className="w-6 h-6" />,
      title: 'Bug Report',
      description: 'Report an issue or problem',
    },
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setSubmitStatus('idle');
    setErrorMessage('');

    try {
      const response = await fetch('/api/feedback', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      const data = await response.json();

      if (response.ok) {
        setSubmitStatus('success');
        // Reset form
        setFormData({
          type: 'feedback',
          email: '',
          subject: '',
          message: '',
          appVersion: '',
          deviceInfo: '',
        });
      } else {
        setSubmitStatus('error');
        setErrorMessage(data.message || 'Failed to submit feedback');
      }
    } catch (error) {
      setSubmitStatus('error');
      setErrorMessage('Network error. Please try again.');
      console.error('Error submitting feedback:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

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
              <Link href="/privacy" className="hover:text-blue-400 transition">Privacy</Link>
              <Link href="/contact" className="text-blue-400">Contact</Link>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-32 pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              <span className="bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                Get in Touch
              </span>
            </h1>
            <p className="text-xl text-gray-400">
              We'd love to hear from you. Send us feedback, report bugs, or request features.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Feedback Type Selection */}
      <section className="pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto">
          <div className="grid md:grid-cols-3 gap-6">
            {feedbackTypes.map((type) => (
              <motion.button
                key={type.id}
                type="button"
                onClick={() => setFormData({ ...formData, type: type.id })}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className={`p-6 rounded-2xl border transition-all ${
                  formData.type === type.id
                    ? 'bg-blue-500/20 border-blue-500 shadow-lg shadow-blue-500/20'
                    : 'bg-gray-800/50 border-gray-700 hover:border-gray-600'
                }`}
              >
                <div className={`mb-4 ${formData.type === type.id ? 'text-blue-400' : 'text-gray-400'}`}>
                  {type.icon}
                </div>
                <h3 className="text-lg font-bold mb-2">{type.title}</h3>
                <p className="text-sm text-gray-400">{type.description}</p>
              </motion.button>
            ))}
          </div>
        </div>
      </section>

      {/* Contact Form */}
      <section className="pb-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
            className="bg-gradient-to-br from-gray-800 to-gray-900 rounded-2xl p-8 border border-gray-700"
          >
            {submitStatus === 'success' ? (
              <div className="text-center py-12">
                <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
                <h3 className="text-2xl font-bold mb-2">Thank You!</h3>
                <p className="text-gray-400 mb-6">
                  Your feedback has been received. We'll review it shortly.
                </p>
                <button
                  onClick={() => setSubmitStatus('idle')}
                  className="bg-blue-500 hover:bg-blue-600 px-6 py-3 rounded-lg transition"
                >
                  Send Another Message
                </button>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-6">
                <div>
                  <label className="block text-sm font-medium mb-2">
                    Email <span className="text-gray-500">(optional)</span>
                  </label>
                  <input
                    type="email"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    placeholder="your@email.com"
                    className="w-full px-4 py-3 bg-gray-900 border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 transition"
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    Provide your email if you'd like us to respond
                  </p>
                </div>

                <div>
                  <label className="block text-sm font-medium mb-2">Subject *</label>
                  <input
                    type="text"
                    required
                    minLength={3}
                    maxLength={200}
                    value={formData.subject}
                    onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                    placeholder="Brief description of your feedback"
                    className="w-full px-4 py-3 bg-gray-900 border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 transition"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium mb-2">Message *</label>
                  <textarea
                    required
                    minLength={10}
                    maxLength={2000}
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    placeholder="Tell us more about your feedback, feature request, or issue..."
                    rows={6}
                    className="w-full px-4 py-3 bg-gray-900 border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 transition resize-none"
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    {formData.message.length}/2000 characters
                  </p>
                </div>

                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium mb-2">
                      App Version <span className="text-gray-500">(optional)</span>
                    </label>
                    <input
                      type="text"
                      value={formData.appVersion}
                      onChange={(e) => setFormData({ ...formData, appVersion: e.target.value })}
                      placeholder="e.g., 1.0.0"
                      className="w-full px-4 py-3 bg-gray-900 border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 transition"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium mb-2">
                      Device Info <span className="text-gray-500">(optional)</span>
                    </label>
                    <input
                      type="text"
                      value={formData.deviceInfo}
                      onChange={(e) => setFormData({ ...formData, deviceInfo: e.target.value })}
                      placeholder="e.g., Samsung Galaxy S21"
                      className="w-full px-4 py-3 bg-gray-900 border border-gray-700 rounded-lg focus:outline-none focus:border-blue-500 transition"
                    />
                  </div>
                </div>

                {submitStatus === 'error' && (
                  <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-4 text-red-400">
                    {errorMessage}
                  </div>
                )}

                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 disabled:from-gray-600 disabled:to-gray-700 disabled:cursor-not-allowed px-6 py-4 rounded-lg transition flex items-center justify-center space-x-2 text-lg font-medium shadow-lg shadow-blue-500/30"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      <span>Sending...</span>
                    </>
                  ) : (
                    <>
                      <Send className="w-5 h-5" />
                      <span>Send Feedback</span>
                    </>
                  )}
                </button>
              </form>
            )}
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
            <Link href="/contact" className="hover:text-blue-400 transition">Contact</Link>
          </div>
          <p className="text-sm">© 2024 ZeScan. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
