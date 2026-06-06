import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "ZeScan - Privacy-First Document Scanner & PDF Toolkit",
  description: "Professional document scanner with powerful PDF tools. Scan, merge, compress, and split PDFs without watermarks or accounts. Free, secure, and privacy-first.",
  keywords: "document scanner, PDF tools, merge PDF, compress PDF, split PDF, no watermark, privacy, free scanner",
  authors: [{ name: "ZeScan" }],
  openGraph: {
    title: "ZeScan - Privacy-First Document Scanner",
    description: "Professional document scanner with powerful PDF tools. Free, secure, and privacy-first.",
    type: "website",
    url: "https://zescan.app",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
