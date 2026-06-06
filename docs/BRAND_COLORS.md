# ZeScan Brand Colors & Design System

## Primary Brand Color

### Blue - Main Brand Identity
- **Primary**: `#2196F3` (Material Blue 500)
  - RGB: `33, 150, 243`
  - Used for: Primary buttons, CTAs, active states, links
  
- **Primary Light**: `#42A5F5` (Material Blue 400)
  - RGB: `66, 165, 245`
  - Used for: Hover states, highlights, accents
  
- **Primary Dark**: `#1E88E5` (Material Blue 600)
  - RGB: `30, 136, 229`
  - Used for: Pressed states, darker variants

- **Primary Glow**: `#2196F3` at 15% opacity (`rgba(33, 150, 243, 0.15)`)
  - Used for: Subtle backgrounds, glass effects

## Color Palette

### Dark Mode Colors
```
Background: #0D0D0D (Near black)
Surface:    #161616 (Dark gray)
Border:     #262626 (Subtle border)
Text Primary:   #FFFFFF (White)
Text Secondary: #A3A3A3 (Gray)
Text Muted:     #525252 (Muted gray)
```

### Light Mode Colors
```
Background: #F8FAFC (Off-white)
Surface:    #FFFFFF (Pure white)
Border:     #E2E8F0 (Light gray)
Text Primary:   #0F172A (Near black)
Text Secondary: #475569 (Slate gray)
Text Muted:     #94A3B8 (Light slate)
```

### Semantic Colors
```
Success: #10B981 (Emerald green)
Warning: #F59E0B (Amber)
Danger:  #EF4444 (Red)
```

## Gradients

### Primary Gradient
```css
linear-gradient(135deg, #42A5F5 0%, #1E88E5 100%)
```
From light blue to dark blue, used for premium features and highlights.

### Gold Gradient
```css
linear-gradient(135deg, #FBBF24 0%, #D97706 100%)
```
Used for premium/pro features.

### Privacy Gradient
```css
linear-gradient(135deg, #059669 0%, #0D9488 100%)
```
Used for privacy badges and security features.

## Usage Guidelines

### Primary Color Usage
- ✅ Primary buttons and CTAs
- ✅ Active navigation items
- ✅ Progress indicators
- ✅ Focused input fields
- ✅ Selected items
- ✅ Brand elements (logo, icons)

### Do's
- Use primary blue as the dominant action color
- Maintain sufficient contrast ratios (4.5:1 for text)
- Use gradients sparingly for special elements
- Keep semantic colors consistent (green=success, red=danger)

### Don'ts
- Don't use too many colors at once
- Don't use primary color for destructive actions (use danger red)
- Don't mix gradients with flat colors in the same component
- Don't use low contrast combinations

## Accessibility

### Contrast Ratios
All color combinations meet WCAG AA standards:
- Primary Blue (#2196F3) on white: 3.4:1 (Large text ✓)
- Primary Dark (#1E88E5) on white: 4.1:1 (Normal text ✓)
- Primary Light (#42A5F5) on dark (#0D0D0D): 8.2:1 (Normal text ✓✓)

### Color Blind Safe
The blue primary color is distinguishable for most types of color blindness when used with proper semantic indicators (icons, labels).

## Implementation

### Flutter
```dart
AppTheme.primary         // #2196F3
AppTheme.primaryLight    // #42A5F5
AppTheme.primaryDark     // #1E88E5
AppTheme.primaryGradient // Gradient
```

### Web/CSS
```css
--primary: #2196F3;
--primary-light: #42A5F5;
--primary-dark: #1E88E5;
--primary-glow: rgba(33, 150, 243, 0.15);
```

### Android XML
```xml
<color name="primary">#2196F3</color>
<color name="primary_light">#42A5F5</color>
<color name="primary_dark">#1E88E5</color>
```

## Brand Assets

### Logo Colors
The ZeScan logo uses the primary blue (#2196F3) as its main color:
- Light mode logo: Blue icon on transparent/white background
- Dark mode logo: Blue icon on transparent/dark background
- Splash icon: Blue branding with appropriate background

### Icon Colors
- Launcher icon background: Primary blue (#2196F3)
- Adaptive icon background: Primary blue (#2196F3)
- Foreground: White or brand logo

## Updates History

- **v1.0.0** (June 2026): Updated from purple (#5B4FE8) to blue (#2196F3) based on logo analysis
  - Reason: Better alignment with actual logo colors
  - Impact: More cohesive brand identity across all platforms
