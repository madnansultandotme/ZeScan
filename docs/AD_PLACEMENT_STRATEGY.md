# ZeScan Ad Placement Strategy & Monetization Guide

## Executive Summary
This document outlines the complete ad placement strategy for ZeScan - a privacy-focused document scanning app. The strategy balances user experience with revenue generation while maintaining the app's core value proposition of 100% on-device processing.

---

## Current Ad Implementation Status

### ✅ Already Implemented
1. **PDF Generation Screen** - Banner/Medium Rectangle Ad (Active)
2. **Library Screen** - Banner Ad at Bottom (Active)

### 🔜 Recommended Additional Placements
3 additional strategic placements identified for maximum revenue without compromising UX

---

## Detailed Ad Placement Guide

### 1. PDF Generation Screen (✅ IMPLEMENTED)
**Location:** `lib/features/scanner/pdf_generation_screen.dart` (Line 249-329)

**Ad Type:** `AdMob Banner` or `Medium Rectangle (300x250)`

**Current Status:** ✅ Fully implemented with placeholder

**Why This Placement:**
- **High engagement time** - Users wait 3-15 seconds for PDF generation
- **Natural dwell time** - Users are captivated by progress bar animation
- **Non-intrusive** - Ads appear below the main content without blocking functionality
- **Optimal for retention** - Keeps users engaged during processing time

**Ad Specifications:**
```dart
// Recommended Ad Unit Types:
// 1. Banner (320x50) - Standard
// 2. Medium Rectangle (300x250) - Higher eCPM
// 3. Adaptive Banner - Responsive sizing

// Implementation Area (Line 249-329):
Container(
  width: double.infinity,
  margin: const EdgeInsets.all(16),
  constraints: const BoxConstraints(maxHeight: 300),
  decoration: BoxDecoration(
    color: AppTheme.surfaceDark,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppTheme.borderDark),
  ),
  child: Column(
    // AdMob BannerAd or MediumRectangle widget goes here
    // Google AdMob integration point
  ),
)
```

**Expected Revenue Impact:** ⭐⭐⭐⭐⭐ (Very High)
- 100% of PDF generations will see this ad
- Average dwell time: 5-10 seconds
- High completion rate due to mandatory wait

**User Experience Impact:** ⭐⭐⭐⭐⭐ (Minimal)
- Doesn't block functionality
- Natural placement during waiting period
- Users expect ads during processing

---

### 2. Library Screen Bottom Banner (✅ IMPLEMENTED)
**Location:** `lib/features/library/library_screen.dart` (Line 439-470)

**Ad Type:** `AdMob Banner` or `Adaptive Banner`

**Current Status:** ✅ Fully implemented with placeholder and "Remove Ads" CTA

**Why This Placement:**
- **High visibility** - Present on the main screen (most visited screen)
- **Persistent exposure** - Users browse library frequently
- **Pro upgrade driver** - Incentivizes premium subscription
- **Non-intrusive** - Fixed at bottom, doesn't interfere with content

**Ad Specifications:**
```dart
// Current Implementation (Line 439-470):
if (!state.isProUnlocked)
  Container(
    height: 54,
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppTheme.getSurfaceColor(isDark),
      border: Border.all(color: AppTheme.getBorderColor(isDark), width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      // AdMob Banner widget integration point
      // Include "Remove Ads" CTA button
    ),
  ),
```

**Expected Revenue Impact:** ⭐⭐⭐⭐ (High)
- Most frequently visited screen
- Recurring impressions per session
- Every library browse = 1 impression

**User Experience Impact:** ⭐⭐⭐⭐ (Low Impact)
- Standard placement (users expect ads here)
- Easy to scroll past
- Doesn't obstruct navigation

---

### 3. 🔜 Preview Screen Bottom Banner (RECOMMENDED)
**Location:** `lib/features/scanner/preview_screen.dart` (After line 429)

**Ad Type:** `AdMob Banner` (320x50 or Adaptive)

**Current Status:** ❌ Not implemented - HIGH PRIORITY

**Why This Placement:**
- **High frequency screen** - Users spend 10-30 seconds reviewing pages
- **Natural review time** - Users carefully check each page before export
- **Pre-export monetization** - Capture engagement before PDF generation
- **Multiple page reviews** - Users often revisit this screen

**Recommended Implementation:**
```dart
// Add after line 429 (before "Export Footer Button" section)

// Ad Banner Section (Add this before the Export button)
if (!state.isProUnlocked)
  Container(
    width: double.infinity,
    height: 54,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppTheme.surfaceDark,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppTheme.borderDark),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.info, color: AppTheme.textMuted, size: 12),
          const SizedBox(width: 8),
          Text(
            'AdMob Banner Ad',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    ),
  ),

// Then the Export Footer Button follows...
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Container(
    // Export PDF button...
  ),
),
```

**Expected Revenue Impact:** ⭐⭐⭐⭐ (High)
- Every scan session includes preview
- Average dwell time: 15-25 seconds
- High engagement (users are actively reviewing)

**User Experience Impact:** ⭐⭐⭐⭐ (Low Impact)
- Placed between content and action button
- Doesn't interfere with page review
- Natural scroll position

---

### 4. 🔜 Favorites Screen Bottom Banner (RECOMMENDED)
**Location:** `lib/features/favorites/favorites_screen.dart`

**Ad Type:** `AdMob Banner` (320x50 or Adaptive)

**Current Status:** ❌ Not implemented - MEDIUM PRIORITY

**Why This Placement:**
- **Engaged users** - Users who favorite docs are power users
- **Frequent visits** - Quick access to important documents
- **Mirror library experience** - Consistent ad pattern
- **Pro upgrade opportunity** - Premium users likely to remove ads

**Recommended Implementation:**
```dart
// Add at bottom of Column in build method (similar to LibraryScreen)

// Dynamic AdMob Banner (add before closing Column widget)
if (!state.isProUnlocked)
  Container(
    height: 54,
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppTheme.getSurfaceColor(isDark),
      border: Border.all(color: AppTheme.getBorderColor(isDark), width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.star, color: AppTheme.warning, size: 16),
        const SizedBox(width: 8),
        Text(
          'AdMob Banner Ad • Remove with Pro',
          style: TextStyle(
            color: AppTheme.getTextSecondary(isDark),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
```

**Expected Revenue Impact:** ⭐⭐⭐ (Medium)
- Power users visit frequently
- Lower traffic than Library
- Higher user value (engaged users)

**User Experience Impact:** ⭐⭐⭐⭐⭐ (Minimal)
- Same pattern as Library (consistent UX)
- Bottom placement (non-intrusive)
- Easy to ignore while browsing

---

### 5. 🔜 Interstitial Ad After PDF Export (RECOMMENDED - STRATEGIC)
**Location:** Between PDF Generation completion and Share Screen transition

**Ad Type:** `AdMob Interstitial Ad`

**Current Status:** ❌ Not implemented - HIGH PRIORITY for revenue

**Why This Placement:**
- **Natural break point** - Task completion moment
- **High engagement** - User just accomplished a goal
- **Non-blocking** - Appears after work is done
- **Maximum eCPM** - Interstitials have highest revenue per impression

**Recommended Implementation Flow:**
```dart
// In pdf_generation_screen.dart, modify the completion flow (around line 112-125)

// Current flow:
// 1. PDF generation completes
// 2. Wait 1.5 seconds
// 3. Navigate to ShareScreen

// New flow with interstitial:
// 1. PDF generation completes
// 2. Show interstitial ad (if not Pro, and ad is loaded)
// 3. After ad dismissal, navigate to ShareScreen

// Implementation:
await Future.delayed(const Duration(milliseconds: 1500));

if (!mounted) return;

// Show interstitial ad before navigation (if available and not Pro)
if (!state.isProUnlocked) {
  await AdService.showInterstitialAd(
    onAdDismissed: () {
      // Navigate to share screen after ad
      _navigateToShareScreen(context, state, createdDoc);
    },
    onAdFailed: () {
      // Navigate immediately if ad fails
      _navigateToShareScreen(context, state, createdDoc);
    },
  );
} else {
  // Pro users skip ad
  _navigateToShareScreen(context, state, createdDoc);
}
```

**Expected Revenue Impact:** ⭐⭐⭐⭐⭐ (Very High)
- Highest eCPM of all ad types
- 100% of exports (unless Pro)
- Natural completion point
- Can use frequency capping (1 per 3 exports to maintain UX)

**User Experience Impact:** ⭐⭐⭐ (Moderate)
- Appears at task completion
- Skippable after 5 seconds
- Use frequency capping (recommendation: show 1 every 2-3 exports)
- Strong Pro upgrade driver

**Frequency Capping Recommendation:**
```dart
// Smart frequency capping to balance UX and revenue
// Show interstitial ad:
// - 1st export: No ad (great first experience)
// - 2nd export: Show ad
// - 3rd export: Show ad
// - 4th export: No ad
// - Pattern: 2 ads per 3 exports = 66% impression rate
```

---

### 6. 🚫 NOT RECOMMENDED: Toolkit Screen
**Location:** `lib/features/toolkit/toolkit_screen.dart`

**Why NOT recommended:**
- ⛔ Low engagement time (quick navigation)
- ⛔ Few users visit (secondary feature)
- ⛔ Would clutter utility screen
- ⛔ Better to focus on high-traffic areas

---

### 7. 🚫 NOT RECOMMENDED: Settings Screen
**Location:** `lib/features/settings/settings_screen.dart`

**Why NOT recommended:**
- ⛔ Rarely visited
- ⛔ Functional/utility screen (users expect clean UI)
- ⛔ Low dwell time
- ⛔ Better suited for "Remove Ads" CTA without ads

---

### 8. 🚫 NOT RECOMMENDED: PDF Viewer Screen
**Location:** `lib/features/pdf_viewer/pdf_viewer_screen.dart`

**Why NOT recommended:**
- ⛔ Premium feature (users expect clean viewing)
- ⛔ Would interrupt document reading experience
- ⛔ Competitive disadvantage (other viewers are ad-free)
- ⛔ Better as Pro feature differentiator ("Ad-free viewing with Pro")

---

## Ad Type Breakdown & eCPM Estimates

### Banner Ads (320x50 or Adaptive)
- **Use Cases:** Library, Preview, Favorites
- **eCPM:** $0.50 - $2.00 (varies by region)
- **Best For:** Persistent, non-intrusive monetization
- **Implementation:** `google_mobile_ads: ^5.0.0`

### Medium Rectangle (300x250)
- **Use Cases:** PDF Generation Screen
- **eCPM:** $1.00 - $4.00 (higher than banners)
- **Best For:** Dwell time screens with vertical space
- **Implementation:** `google_mobile_ads: ^5.0.0`

### Interstitial Ads (Full Screen)
- **Use Cases:** Post-export, app launch (sparingly)
- **eCPM:** $3.00 - $10.00+ (highest revenue)
- **Best For:** Natural break points, task completions
- **Implementation:** `google_mobile_ads: ^5.0.0`
- **⚠️ Critical:** Use frequency capping to avoid user frustration

### Rewarded Ads (Optional - Future Consideration)
- **Use Cases:** "Remove ads for 24 hours", "Unlock Pro features for 1 hour"
- **eCPM:** $10.00 - $20.00+ (users opt-in)
- **Best For:** User-initiated, value exchange
- **Implementation:** Future monetization layer

---

## Revenue Projection (Estimated)

### Conservative Monthly Revenue Scenario
**Assumptions:**
- 1,000 DAU (Daily Active Users)
- Average 3 PDF exports per user per day
- 80% see ads (20% Pro subscribers)

**Ad Revenue Breakdown:**

| Ad Placement | Impressions/Day | eCPM | Daily Revenue | Monthly Revenue |
|--------------|----------------|------|---------------|-----------------|
| PDF Generation Banner | 3,000 | $2.00 | $6.00 | $180.00 |
| Library Bottom Banner | 5,000 | $1.00 | $5.00 | $150.00 |
| Preview Screen Banner | 3,000 | $1.00 | $3.00 | $90.00 |
| Favorites Banner | 1,000 | $1.00 | $1.00 | $30.00 |
| Post-Export Interstitial* | 2,000 | $5.00 | $10.00 | $300.00 |
| **TOTAL** | **14,000** | **-** | **$25.00** | **$750.00** |

*Interstitial with 66% frequency capping (2 of 3 exports)

**Total Monthly Ad Revenue:** ~$750

**Plus Pro Subscriptions:**
- 20% of users × 1,000 DAU = 200 Pro users
- If $4.99/month subscription: 200 × $4.99 = $998/month
- **Total Monthly Revenue:** $750 (ads) + $998 (subscriptions) = **~$1,748/month**

---

## Implementation Priority Ranking

### Phase 1: Quick Wins (Week 1)
1. ✅ **PDF Generation Banner** - Already implemented (verify AdMob integration)
2. ✅ **Library Bottom Banner** - Already implemented (verify AdMob integration)
3. 🔜 **Preview Screen Banner** - HIGH PRIORITY (30 min implementation)

### Phase 2: High Revenue (Week 2)
4. 🔜 **Post-Export Interstitial** - HIGH REVENUE (2-3 hours implementation + testing)
   - Implement frequency capping
   - Add analytics tracking
   - Test dismissal flow

### Phase 3: Power Users (Week 3)
5. 🔜 **Favorites Screen Banner** - MEDIUM PRIORITY (20 min implementation)

### Phase 4: Optimization (Ongoing)
- A/B test ad sizes (Banner vs Medium Rectangle)
- Optimize interstitial frequency
- Monitor bounce rates and retention
- Adjust based on user feedback

---

## AdMob Integration Code Snippets

### Step 1: Add Dependency
```yaml
# pubspec.yaml
dependencies:
  google_mobile_ads: ^5.0.0
```

### Step 2: Initialize AdMob
```dart
// lib/main.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob
  await MobileAds.instance.initialize();
  
  runApp(const MyApp());
}
```

### Step 3: Banner Ad Widget
```dart
// lib/core/services/ad_service.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  
  const AdBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: 'YOUR_AD_UNIT_ID', // Replace with your AdMob unit ID
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    return const SizedBox.shrink();
  }
}
```

### Step 4: Interstitial Ad Service
```dart
// lib/core/services/ad_service.dart
class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialReady = false;
  static int _exportCount = 0;

  // Load interstitial ad
  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: 'YOUR_INTERSTITIAL_AD_UNIT_ID',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialReady = false;
              loadInterstitialAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialReady = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialReady = false;
        },
      ),
    );
  }

  // Show interstitial with frequency capping
  static Future<void> showInterstitialAd({
    required VoidCallback onAdDismissed,
    required VoidCallback onAdFailed,
  }) async {
    _exportCount++;

    // Frequency capping: Show 2 out of 3 times (skip every 3rd export)
    if (_exportCount % 3 == 0) {
      debugPrint('AdService: Skipping interstitial (frequency cap)');
      onAdDismissed();
      return;
    }

    if (_isInterstitialReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      onAdDismissed();
    } else {
      debugPrint('AdService: Interstitial not ready');
      onAdFailed();
      // Try to load for next time
      loadInterstitialAd();
    }
  }

  // Initialize ads (call from main.dart)
  static Future<void> initialize() async {
    await loadInterstitialAd();
  }
}
```

### Step 5: Usage in Screens

#### PDF Generation Screen:
```dart
// Replace placeholder container with:
if (!state.isProUnlocked)
  Container(
    width: double.infinity,
    height: 250,
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surfaceDark,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.borderDark),
    ),
    child: const AdBannerWidget(
      adSize: AdSize.mediumRectangle, // 300x250
    ),
  ),
```

#### Library Screen:
```dart
// Replace placeholder with:
if (!state.isProUnlocked)
  Container(
    height: 54,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: const AdBannerWidget(
      adSize: AdSize.banner, // 320x50
    ),
  ),
```

---

## Pro Subscription Strategy

### Remove Ads Feature
- **Primary Pro Benefit:** "Ad-Free Experience"
- **Pricing:** $4.99/month or $29.99/year (save 50%)
- **Value Proposition:**
  - ✅ Remove all banner ads
  - ✅ No interstitial interruptions
  - ✅ Priority PDF processing (placebo effect)
  - ✅ Unlimited cloud backup (future feature)

### Upgrade Prompts (Non-Intrusive)
1. **Library Screen CTA:** "Remove Ads" button on banner
2. **Settings Screen:** Prominent "Upgrade to Pro" card
3. **Post-Export:** "Enjoying ZeScan? Go Pro!" message (1 per 10 exports)

---

## Analytics & Tracking

### Key Metrics to Monitor
```dart
// Track ad performance
- Ad impression rate
- Ad click-through rate (CTR)
- Ad revenue per user (ARPU)
- Interstitial completion rate
- Pro conversion rate from ad dismissals

// Track user behavior
- Retention rate (7-day, 30-day)
- Export frequency (per user)
- Session length
- Bounce rate after interstitial
```

### Firebase Analytics Events
```dart
// Example tracking
Analytics.logEvent(
  name: 'ad_impression',
  parameters: {
    'ad_type': 'banner',
    'ad_location': 'pdf_generation_screen',
    'user_type': 'free',
  },
);

Analytics.logEvent(
  name: 'pro_upgrade_prompt_shown',
  parameters: {
    'trigger': 'ad_removal_cta',
    'location': 'library_screen',
  },
);
```

---

## Testing Checklist

### Before Launch
- [ ] Test ads on physical devices (iOS + Android)
- [ ] Verify ad unit IDs (test vs production)
- [ ] Test frequency capping logic
- [ ] Verify Pro users see NO ads
- [ ] Test ad loading failures (graceful degradation)
- [ ] Check ad sizes on different screen sizes
- [ ] Monitor memory usage with ads loaded
- [ ] Test interstitial dismissal flow
- [ ] Verify analytics tracking
- [ ] Test "Remove Ads" CTA functionality

### Post-Launch Monitoring (First Week)
- [ ] Monitor ad fill rate
- [ ] Check eCPM performance
- [ ] Track user retention impact
- [ ] Monitor crash reports
- [ ] Review user feedback on ads
- [ ] A/B test different ad frequencies
- [ ] Optimize interstitial timing

---

## Compliance & Privacy

### GDPR Compliance (EU Users)
```dart
// Implement consent form
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> requestConsent() async {
  final params = ConsentRequestParameters();
  
  ConsentInformation.instance.requestConsentInfoUpdate(
    params,
    () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        loadConsentForm();
      }
    },
    (error) {
      debugPrint('Consent error: ${error.message}');
    },
  );
}
```

### Privacy Policy Requirements
- ✅ Disclose ad serving partners (AdMob/Google)
- ✅ Explain data collection for ads
- ✅ Provide opt-out mechanism (Pro subscription)
- ✅ Comply with COPPA (if targeting children)
- ✅ Update Privacy Policy on website

---

## Conclusion

### Quick Reference: Ad Placement Summary

| Screen | Ad Type | Priority | Status | Expected eCPM | Monthly Revenue |
|--------|---------|----------|--------|---------------|-----------------|
| PDF Generation | Medium Rectangle | HIGH | ✅ | $2-4 | $180-360 |
| Library | Banner | HIGH | ✅ | $1-2 | $150-300 |
| Preview | Banner | HIGH | 🔜 | $1-2 | $90-180 |
| Post-Export | Interstitial | CRITICAL | 🔜 | $5-10 | $300-600 |
| Favorites | Banner | MEDIUM | 🔜 | $1-2 | $30-60 |

**Total Estimated Monthly Revenue:** $750 - $1,500 (ads only)

**With Pro Subscriptions (20% users):** $1,750 - $2,500/month

---

## Next Steps

1. **Immediate:** Verify AdMob integration on implemented placements
2. **Week 1:** Add Preview Screen banner
3. **Week 2:** Implement post-export interstitial with frequency capping
4. **Week 3:** Add Favorites screen banner
5. **Week 4:** A/B test and optimize based on metrics

---

**Document Version:** 1.0  
**Last Updated:** June 6, 2026  
**Maintained By:** ZeScan Development Team  
**Contact:** For AdMob account IDs and implementation support
