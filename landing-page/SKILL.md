---
name: landing-page
description: Create award-winning, visually stunning HTML landing pages with Tailwind CSS
category: Web Design
---

## When to Use This Skill

Use this skill when you need to:
- Create a complete landing page or single-page website
- Design HTML prototypes with modern, award-winning quality
- Build visually stunning pages that meet Awwwards/Behance standards
- Rapidly prototype using Tailwind CSS CDN
- Create responsive, accessible, performant web pages

**Perfect for:**
- Landing pages
- Product showcases
- Portfolio sites
- Marketing pages
- Startup websites
- SaaS product pages

## Core Philosophy

Every design must be:
- **Exceptionally beautiful** - Modern, innovative, memorable
- **Perfectly balanced** - Simplicity well-dosed according to needs
- **Award-winning quality** - Awwwards/Behance worthy execution
- **Contextually adapted** - Tailored to industry and project goals

## Visual Styles

Choose a visual style from the list below:

```
Minimalist Clean       | Pure, elegant              | whitespace, subtle, refined        | Premium, luxury, portfolios
Glassmorphism          | Futuriste, élégant         | blur, transparence, soft-glow       | Tech, SaaS, modern brands
Dark Luxury            | Sophisticated, premium     | noir, or, élégance                 | Luxury, fashion, high-end
Mesh Gradients         | Modern, vibrant            | animated, fluid, color-rich        | Startups, creative agencies
Aurora Borealis        | Ethereal, dreamy           | organic, light, soft-gradient      | Wellness, beauty, creative
Neo-Brutalism          | Bold, raw                  | strong borders, primary colors      | Edgy, youth, disruptive brands
Grainy Gradients       | Instagram-style, warm      | grain, overlay, vibrant            | Lifestyle, fashion, creative
Cyberpunk              | Futuristic, dark           | neon, glitch, dark-tech            | Gaming, tech, avant-garde
Holographic            | Iridescent, futuristic     | shimmer, rainbow, futuristic        | Fashion, art, experimental
Modern Organic         | Natural, soft              | curves, pastel, gentle             | Eco, wellness, lifestyle
Acid Graphics          | Edgy, experimental         | bold, clashing, disruptive          | Creative agencies, portfolios
Brutal Pop             | Playful, bold              | bright, rounded, fun              | Startups, playful brands
```

## Style Implementations (Tailwind)

### Minimalist Clean
```html
<body class="bg-white text-slate-900 font-sans">
  <h1 class="text-6xl font-light tracking-tight">Headline</h1>
  <p class="text-slate-600 leading-relaxed">Body text</p>
  <button class="border border-slate-900 px-6 py-3 hover:bg-slate-900 hover:text-white transition-colors">
    Button
  </button>
</body>
```

### Glassmorphism
```html
<body class="bg-gradient-to-br from-blue-500 to-purple-600">
  <div class="bg-white/10 backdrop-blur-md border border-white/20 p-8 rounded-2xl shadow-xl">
    <h1 class="text-4xl font-semibold text-white">Glass Card</h1>
  </div>
</body>
```

### Dark Luxury
```html
<body class="bg-slate-950 text-slate-50 font-serif">
  <h1 class="text-6xl text-amber-400 tracking-wide">Luxury</h1>
  <div class="border-t border-amber-400/30 pt-8"></div>
  <button class="bg-amber-500 text-slate-950 px-8 py-4 hover:bg-amber-400 transition-colors">
    Exclusive
  </button>
</body>
```

### Mesh Gradients
```html
<body class="bg-gradient-to-br from-pink-500 via-purple-500 to-blue-500 bg-[length:400%_400%] animate-gradient-x">
  <h1 class="text-white">Mesh Gradient</h1>
</body>
```

### Aurora Borealis
```html
<body class="bg-gradient-to-b from-slate-900 via-purple-900 to-slate-900">
  <div class="absolute inset-0 bg-gradient-to-t from-purple-500/20 via-transparent to-blue-500/20"></div>
  <h1 class="relative text-white">Aurora</h1>
</body>
```

### Neo-Brutalism
```html
<body class="bg-yellow-300 text-slate-900 font-sans">
  <h1 class="text-6xl font-black uppercase tracking-tighter border-4 border-slate-900 p-4 inline-block">
    BRUTAL
  </h1>
  <button class="bg-red-500 text-white border-4 border-slate-900 px-8 py-4 font-bold hover:bg-red-400 transition-colors">
    ACTION
  </button>
</body>
```

### Grainy Gradients
```html
<body class="bg-gradient-to-br from-orange-500 to-pink-600">
  <div class="fixed inset-0 opacity-30 bg-[url('https://grainy-gradients.vercel.app/noise.svg')]"></div>
  <h1 class="relative text-white">Grainy</h1>
</body>
```

### Cyberpunk
```html
<body class="bg-slate-950 text-cyan-400 font-mono">
  <h1 class="text-6xl font-black uppercase tracking-widest text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-pink-500">
    CYBER
  </h1>
  <button class="bg-pink-500 text-white px-6 py-3 font-bold hover:shadow-[0_0_20px_rgba(236,72,153,0.5)] transition-shadow">
    GLITCH
  </button>
</body>
```

### Holographic
```html
<body class="bg-slate-900">
  <div class="bg-gradient-to-r from-pink-500 via-purple-500 to-cyan-500 bg-[length:200%_200%] animate-gradient-x p-1 rounded-2xl">
    <div class="bg-slate-900 rounded-2xl p-8">
      <h1 class="text-white">Holographic</h1>
    </div>
  </div>
</body>
```

### Modern Organic
```html
<body class="bg-stone-100 text-stone-900 font-sans">
  <div class="bg-amber-50 rounded-[2rem] p-8 shadow-xl">
    <h1 class="text-5xl text-amber-800">Organic</h1>
  </div>
</body>
```

### Acid Graphics
```html
<body class="bg-lime-400 text-slate-900 font-bold">
  <h1 class="text-8xl uppercase tracking-tighter mix-blend-difference">
    ACID
  </h1>
  <div class="bg-purple-600 text-white p-4 inline-block rotate-3 hover:rotate-0 transition-transform">
    WILD
  </div>
</body>
```

### Brutal Pop
```html
<body class="bg-blue-400 text-slate-900 font-bold">
  <h1 class="text-7xl text-yellow-300 drop-shadow-[4px_4px_0_rgba(15,23,42,1)]">
    POP
  </h1>
  <button class="bg-red-400 text-white rounded-full px-12 py-6 text-2xl hover:scale-110 transition-transform shadow-[8px_8px_0_rgba(15,23,42,1)]">
    FUN
  </button>
</body>
```

## Creation Workflow

**Step 0: Setup (Tailwind CDN)**
```html
<script src="https://cdn.tailwindcss.com"></script>
```
- Add Google Fonts if needed
- Configure custom colors, fonts, animations in tailwind.config
- **For production:** Use npm build with JIT mode and purging

**Step 1: Mock Data (Optional)**
- If user provides a JSON file, use it for content
- Mock data can include: industry, business name, hero sections, products, testimonials, navigation, etc.
- Generate realistic content based on the mock data structure

**Step 2: Context Analysis**
- Understand project type, industry, goals
- Determine: industry, target audience, emotion to convey
- Check if mock data is provided

**Step 3: Style Proposal**
```
Suggested Style: [Style name]
Reason: [1-2 sentences explaining why this fits the context]

Alternative styles for this project:
- [Option 1]: [brief reason]
- [Option 2]: [brief reason]

Choose from the list above or specify your own style:
```

**Step 4: Impact Level Selection**
```
Which level of visual impact?
1. Minimal    - Radical simplicity, few animations (2-3), pure elegance
2. Équilibré   - Perfect balance, moderate animations (4-6), modernité
3. Impact     - Maximum creativity, rich animations (8+), bold effects

Note: You can request any specific effects regardless of impact level.
Example: "Minimal but with just parallax" or "Impact but without particles"
```

**Step 5: Animation Selection**
```
Select effects to include (or specify "minimal", "balanced", "impact" for auto-selection):
- Scroll animations (reveal, parallax)
- Visual effects (glassmorphism, glow, gradients, noise)
- Interactive elements (micro-interactions, hover states, cursor)
- Advanced effects (particles, WebGL, 3D, text animations)
```

**Step 6: Creation**
- Use Tailwind utility classes for all styles
- Add custom CSS in `<style>` blocks only when Tailwind is insufficient
- Implement with award-winning quality
- Every detail must be exceptional
- Focus on visual hierarchy, typography, spacing
- Execute animations with perfect timing
- Ensure all interactive states (hover, active, focus, disabled)
- Test responsive behavior (mobile → desktop)
- Verify performance (transform, opacity only, will-change)
- Check accessibility (contrast 4.5:1, prefers-reduced-motion)

## Mock Data Integration

When provided with a JSON file:

**Use the content to populate:**
- Hero section (headline, subheadline, CTAs, badges, stats)
- About section (mission, story, team, process)
- Products/services (if applicable)
- Testimonials and reviews
- Navigation structure
- Footer content
- Any other sections specified

**Design with the data:**
- Use industry-appropriate terminology
- Create compelling copy that matches the tone
- Maintain consistency throughout all sections
- Ensure content supports the visual style chosen

## Animation Techniques

**Scroll Animations:**
- Reveal on scroll (fade, slide, scale, rotate)
- Parallax effects (1-5 layers)
- Scroll-triggered animations
- Scroll progress indicators

**Visual Effects:**
- Glassmorphism overlays
- Neon glow effects
- Gradient borders (animated)
- Mesh gradients (animated)
- Noise/grain overlays
- Glitch effects
- Holographic iridescence

**Interactive Elements:**
- Micro-interactions (buttons, cards, inputs)
- Hover states (transform, opacity, scale)
- Custom cursor interactions
- Magnetic buttons

**Advanced Effects:**
- Particle systems (1-3 types)
- WebGL effects
- 3D transforms & perspective
- Text animations (typing, reveal, gradient)
- Floating elements
- Complex transitions

## Performance Guidelines

**Always do:**
- ✅ Use `transform` and `opacity` only (no layout shifts)
- ✅ Use Tailwind's `will-change-transform` for animating properties
- ✅ Use `requestAnimationFrame` for JS animations
- ✅ Hardware accelerate with `transform: translateZ(0)` or Tailwind's `translate-z-0`
- ✅ Add `@media (prefers-reduced-motion: reduce)` for accessibility
- ✅ Use Tailwind's `ease-[cubic-bezier(0.16,1,0.3,1)]` for smooth, natural feel
- ✅ Use Tailwind's `transition` classes with appropriate durations
- ✅ Leverage Tailwind's `prefers-reduced-motion` utilities if available

**Never do:**
- ❌ Animate `width`, `height`, `top`, `left`, `margin`, `padding`
- ❌ Update DOM in animation loop without batching
- ❌ Use heavy filters (blur, brightness) in animations
- ❌ Override Tailwind's optimized transforms with custom CSS unnecessarily

## Typography

### Font Categories

**Modern Clean**
- Inter, Satoshi, Plus Jakarta Sans, Manrope, DM Sans, Urbanist, Geist Sans
- *Perfect for: tech startups, SaaS, minimalist designs*

**Premium Elegant**
- Cormorant Garamond, Playfair Display, Spectral, Libre Baskerville, Bodoni Moda
- *Perfect for: luxury, fashion, editorial, high-end brands*

**Bold Impact**
- Anton, Clash Display, Orbitron, Bebas Neue, Impact, Montserrat Heavy, Oswald
- *Perfect for: headlines, bold statements, disruptive brands*

**Tech/Futuristic**
- Space Grotesk, JetBrains Mono, VT323, Rajdhani, Share Tech Mono, JetBrains Mono
- *Perfect for: gaming, tech, developer tools, cyberpunk*

**Handwritten**
- Caveat, Pacifico, Marker Script, Nothing You Could Do, Kalam, Archangelsk
- *Perfect for: personal, playful, creative, lifestyle*

**Display/Decorative**
- Righteous, Abril Fatface, Lobster, Press Start 2P, Fredoka One, Permanent Marker
- *Perfect for: hero headlines, playful brands, creative portfolios*

**Classic Serif**
- Merriweather, Georgia, Times New Roman, Source Serif, Crimson Text, Charter
- *Perfect for: editorial, journalism, traditional brands*

**Clean Sans**
- Open Sans, Roboto, Lato, Helvetica Neue, Source Sans, Work Sans
- *Perfect for: general purpose, corporate, clean designs*

### Font Pairings

**Headline + Body:**
- Cormorant Garamond + Inter (elegant + clean)
- Clash Display + Satoshi (bold + modern)
- Playfair Display + DM Sans (premium + clean)
- Space Grotesk + JetBrains Mono (tech theme)
- Anton + Manrope (impact + readability)

**Three-font hierarchy:**
- Display (headline) + Sans-serif (subheadline) + Serif or Sans-serif (body)

**Tailwind Typography Scale:**
```html
<!-- Text sizes -->
<h1 class="text-4xl md:text-6xl lg:text-8xl">
<h2 class="text-2xl md:text-4xl lg:text-5xl">
<h3 class="text-xl md:text-2xl lg:text-3xl">
<p class="text-base md:text-lg">
<p class="text-sm">
<p class="text-xs">

<!-- Leading (line-height) -->
<p class="leading-tight">
<p class="leading-normal">
<p class="leading-loose">

<!-- Tracking (letter-spacing) -->
<p class="tracking-tight">
<p class="tracking-normal">
<p class="tracking-wide">

<!-- Font weights -->
<p class="font-light">
<p class="font-normal">
<p class="font-medium">
<p class="font-semibold">
<p class="font-bold">
<p class="font-extrabold">
```

## Color Theory & Palettes

### Color Harmony Principles

**Monochromatic**
- Single hue, varying lightness/saturation
- *Effect*: Harmonious, unified, elegant
- *Use*: Minimalist, luxury, single-brand focus

**Analogous**
- Adjacent hues on color wheel (e.g., blue + blue-green + green)
- *Effect*: Serene, comfortable, natural
- *Use*: Wellness, nature, harmonious brands

**Complementary**
- Opposite hues (e.g., blue + orange, purple + yellow)
- *Effect*: Vibrant, high contrast, energetic
- *Use*: CTAs, bold statements, energetic brands

**Triadic**
- Three equally spaced hues (e.g., red + blue + yellow)
- *Effect*: Vibrant, balanced, playful
- *Use*: Creative agencies, playful brands

### 60-30-10 Rule

**60%** - Dominant color (backgrounds, large areas)
**30%** - Secondary color (sections, cards, supporting elements)
**10%** - Accent color (CTAs, highlights, key elements)

### WCAG AA Contrast Requirements

**Normal text (< 18px / 14px bold):** Minimum 4.5:1
**Large text (≥ 18px / ≥ 14px bold):** Minimum 3:1
**UI components and graphics:** Minimum 3:1

### Palettes by Style

**Glassmorphism / Mesh Gradients**
- Primary: Deep blues, purples (#1e3a8a, #7c3aed)
- Secondary: Teals, cyans (#06b6d4, #22d3ee)
- Accent: Neon pink, electric blue (#f472b6, #3b82f6)

**Dark Luxury**
- Primary: Rich blacks, charcoals (#0a0a0a, #1a1a1a)
- Secondary: Gold, bronze accents (#d4af37, #cd7f32)
- Accent: Deep burgundy, navy (#722f37, #1e3a8a)

**Aurora Borealis / Modern Organic**
- Primary: Soft pastels (peach, mint, lavender)
- Secondary: Warm neutrals (cream, beige)
- Accent: Vibrant accents (coral, teal)

**Cyberpunk / Acid Graphics**
- Primary: Neon greens, hot pinks (#00ff9d, #ff006e)
- Secondary: Deep purples, blacks (#2d0a31, #0d0221)
- Accent: Cyan, magenta (#00fff5, #ff00ff)

**Neo-Brutalism / Brutal Pop**
- Primary: Bold primaries (red, yellow, blue)
- Secondary: Black, white, gray
- Accent: Electric colors, high contrast

**Minimalist Clean**
- Primary: White, light grays (#ffffff, #f8fafc)
- Secondary: Soft beiges, warm neutrals
- Accent: Black, dark charcoal for contrast

## Spacing & Layout Systems

### Tailwind Spacing Scale

Base spacing unit: 0.25rem (4px)

**Scale:**
```
0-px   - Micro spacing (letter-spacing, borders)
0.5    - 2px (very small)
1      - 4px (base unit, letter-spacing)
1.5    - 6px (small)
2      - 8px (padding small, gaps)
2.5    - 10px
3      - 12px (padding medium, gaps)
4      - 16px (padding large, card padding)
5      - 20px
6      - 24px (sections, card gaps)
7      - 28px
8      - 32px (section spacing)
9      - 36px
10     - 40px
11     - 44px
12     - 48px (major sections, hero padding)
16     - 64px (hero spacing)
20     - 80px (massive spacing)
24     - 96px (hero-level spacing)
32     - 128px (ultra spacing)
```

### Layout Principles

**Golden Ratio (1.618)**
- Content width: ~1.618 times sidebar
- Perfect for creating balanced, natural layouts
- Example: 618px sidebar + 1000px content

**Rule of Thirds**
- Divide layout into 3x3 grid
- Place key elements on intersections
- Creates dynamic, interesting compositions

**Whitespace Principles**
- Generous whitespace = premium feel
- Negative space directs attention
- Whitespace between: 24-48px minimum
- Section breaks: 64-96px

### Breakpoints (Tailwind)

**Tailwind Default Breakpoints:**
```
sm:  640px   (small devices)
md:  768px   (medium devices, tablets)
lg:  1024px  (large devices, laptops)
xl:  1280px  (extra large devices)
2xl: 1536px  (extra extra large)
```

## Interactive States

### Required States

**All interactive elements must have:**

1. **Default** - Base appearance
2. **Hover** - Cursor over element
3. **Active/Pressed** - Mouse down / touch
4. **Focus** - Keyboard navigation
5. **Disabled** - Not interactable

**Additional states for specific elements:**
6. **Loading** - In progress
7. **Error** - Invalid input / failure
8. **Success** - Completed successfully

### State Design Guidelines

**Hover States**
- Transform: Scale (1.05-1.1), Translate (0 -4px)
- Opacity: 0.8-0.9
- Shadow: Increase elevation (deeper shadow)
- Color: Slight brightness boost
- Duration: 0.2-0.3s

**Active States**
- Scale: 0.95-0.98 (button press feel)
- Opacity: 0.7-0.8
- Duration: 0.1s (instant feedback)

**Focus States**
- Outline: 2-3px solid accent color (accessibility)
- Offset: 2-4px from element
- Shadow: Optional glow effect
- Always visible, never remove

## Mobile-First Specific Guidelines

### Touch Targets

**Minimum size:** 44px x 44px
**Optimal size:** 48px x 48px
**Spacing between targets:** Minimum 8px

### Responsive Typography (Tailwind)

**Tailwind Responsive Text Classes:**
```html
<!-- Headline: mobile 32px → desktop 80px -->
<h1 class="text-3xl md:text-5xl lg:text-8xl">

<!-- Subheadline: mobile 24px → desktop 48px -->
<h2 class="text-2xl md:text-4xl lg:text-5xl">

<!-- Body: mobile 16px → desktop 18px -->
<p class="text-base md:text-lg">

<!-- Caption: 12-14px -->
<p class="text-xs sm:text-sm">
```

## Implementation Snippets

### Scroll Reveal Animation
```css
.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}

.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}

/* JavaScript trigger */
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
});

document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

### Parallax Effect
```css
.parallax-layer {
  will-change: transform;
  transition: transform 0.1s linear;
}

/* JavaScript */
window.addEventListener('scroll', () => {
  const scrolled = window.scrollY;
  document.querySelectorAll('.parallax-layer').forEach(layer => {
    const speed = layer.dataset.speed || 0.5;
    layer.style.transform = `translateY(${scrolled * speed}px)`;
  });
});
```

### Glassmorphism
```css
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

/* Tailwind version */
.glass {
  @apply bg-white/10 backdrop-blur-md border border-white/20 shadow-xl;
}
```

### Gradient Border
```css
.gradient-border {
  position: relative;
  background: #fff;
  border-radius: 8px;
}

.gradient-border::before {
  content: '';
  position: absolute;
  inset: -2px;
  background: linear-gradient(45deg, #f472b6, #3b82f6, #10b981);
  border-radius: 10px;
  z-index: -1;
  animation: rotate 3s linear infinite;
}

@keyframes rotate {
  to { transform: rotate(360deg); }
}
```

### Particle System (Lightweight)
```javascript
class Particle {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.particles = [];
    this.init();
  }

  init() {
    for (let i = 0; i < 50; i++) {
      this.particles.push({
        x: Math.random() * this.canvas.width,
        y: Math.random() * this.canvas.height,
        vx: (Math.random() - 0.5) * 0.5,
        vy: (Math.random() - 0.5) * 0.5,
        size: Math.random() * 3 + 1,
        opacity: Math.random() * 0.5 + 0.2
      });
    }
    this.animate();
  }

  animate() {
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.particles.forEach(p => {
      p.x += p.vx;
      p.y += p.vy;

      if (p.x < 0 || p.x > this.canvas.width) p.vx *= -1;
      if (p.y < 0 || p.y > this.canvas.height) p.vy *= -1;

      this.ctx.beginPath();
      this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      this.ctx.fillStyle = `rgba(255, 255, 255, ${p.opacity})`;
      this.ctx.fill();
    });
    requestAnimationFrame(() => this.animate());
  }
}
```

## Tailwind Integration

### Tailwind CDN Configuration

**Customize Tailwind with the `tailwind.config` script:**
```html
<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          brand: {
            50: '#f0f9ff',
            100: '#e0f2fe',
            500: '#0ea5e9',
            600: '#0284c7',
            900: '#0c4a6e',
          },
        },
        fontFamily: {
          display: ['Clash Display', 'sans-serif'],
          body: ['Inter', 'sans-serif'],
        },
        animation: {
          'float': 'float 3s ease-in-out infinite',
          'gradient-x': 'gradient-x 3s linear infinite',
        },
        keyframes: {
          float: {
            '0%, 100%': { transform: 'translateY(0)' },
            '50%': { transform: 'translateY(-10px)' },
          },
          'gradient-x': {
            '0%, 100%': { 'background-position': '0% 50%' },
            '50%': { 'background-position': '100% 50%' },
          },
        },
      },
    },
  }
</script>
```

### Adding Custom Fonts

**Method 1: Google Fonts (before Tailwind script)**
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Clash+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
```

## Tailwind Best Practices

### Class Organization

**Recommended order (BEM-like):**
```html
<div class="
  /* Layout */
  container mx-auto
  /* Grid/Flex */
  grid grid-cols-1 md:grid-cols-3 gap-8
  /* Spacing */
  p-8 md:p-12
  /* Typography */
  text-center text-2xl font-semibold leading-tight
  /* Colors */
  text-slate-900
  /* Backgrounds & Borders */
  bg-white rounded-lg shadow-lg
  /* Effects */
  hover:shadow-xl transition-shadow duration-300
  /* Interactive */
  focus:ring-2 focus:ring-brand-500 focus:ring-offset-2
">
  Content
</div>
```

### Responsive Design Pattern

**Mobile-first approach:**
```html
<div class="
  p-4           /* Mobile padding */
  md:p-8        /* Tablet padding */
  lg:p-12       /* Desktop padding */
  text-lg       /* Mobile text */
  md:text-xl    /* Tablet text */
  lg:text-2xl   /* Desktop text */
">
  Responsive content
</div>
```

### Common Tailwind Patterns

**Card:**
```html
<div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow duration-300">
  <h3 class="text-xl font-semibold mb-4">Card Title</h3>
  <p class="text-slate-600">Card content</p>
</div>
```

**Button:**
```html
<button class="bg-brand-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-brand-600 active:scale-95 focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 transition-all">
  Button
</button>
```

**Hero Section:**
```html
<section class="container mx-auto px-4 py-24 text-center">
  <h1 class="text-5xl md:text-7xl font-bold mb-6">Hero</h1>
  <p class="text-xl text-slate-600 mb-8 max-w-2xl mx-auto">Subtitle</p>
  <button class="bg-brand-500 text-white px-8 py-4 rounded-lg font-semibold hover:bg-brand-600 transition-colors">
    CTA
  </button>
</section>
```

## Award-Winning Standards

Every design must have:
- ✅ Perfect color harmony (use Tailwind color palette)
- ✅ Exceptional typography (Tailwind responsive font sizes, line-height, tracking)
- ✅ Balanced composition (Tailwind grid, flex, spacing)
- ✅ Smooth, delightful interactions (Tailwind hover, active, focus states)
- ✅ Attention to every pixel (Tailwind utility classes for precision)
- ✅ Modern, current trends (Tailwind + custom animations)
- ✅ Performance that doesn't sacrifice beauty (Tailwind transforms, opacity only)
- ✅ Mobile-responsive excellence (Tailwind responsive prefixes: sm:, md:, lg:, xl:, 2xl:)

**Tailwind-specific standards:**
- ✅ Use semantic spacing scale (4, 8, 12, 16, 24, 32, 48, 64, 96px)
- ✅ Leverage responsive utilities for mobile-first design
- ✅ Use Tailwind's built-in accessibility features (prefers-reduced-motion)
- ✅ Organize classes logically: layout → spacing → typography → colors → effects
- ✅ Add custom styles in `<style>` blocks only when Tailwind is insufficient
- ✅ Use Tailwind's color palette for consistency
- ✅ Implement all interactive states with Tailwind (hover:, active:, focus:, disabled:)

## External Resources

### Award-Winning Examples

**Awwwards** - Best of the best
- Awwwards.com/winners

**Behance** - Creative excellence
- behance.net/web-design

**CSS Design Awards** - CSS-focused
- cssdesignawards.com

### Design Tools

**Color:**
- Coolors.co - Palette generator
- Adobe Color - Harmony rules
- WebAIM - Contrast checker

**Typography:**
- Google Fonts - Free fonts
- Font Pair - Pairing suggestions

## Completion Summary

```
✅ Created: [filename]
✅ Style: [selected style]
✅ Impact Level: [Minimal/Équilibré/Impact]
✅ Effects Used: [specific effects implemented]
✅ Performance: [optimizations applied]
✅ Accessibility: [motion reduction support]

Award-worthy elements:
- [specific excellence points]
- [why it stands out]
- [modern techniques used]
```
