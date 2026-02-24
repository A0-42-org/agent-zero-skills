---
name: mock-data
description: Generate diverse mock data for web design prototypes and landing pages
version: 1.0.0
author: OpenCode Team
tags:
  - mock-data
  - prototyping
  - web-design
  - landing-page
trigger_patterns:
  - generate mock data
  - create mock data
  - fake data
  - sample data
  - prototype data
---

# Mock Data Generator

Generate realistic, diverse mock data for web design prototypes, landing pages, and UI development.

## Usage

```
Use mock-data skill to generate content for a [industry] landing page
```

## What This Skill Generates

### Industries Supported

| Industry | Business Types |
|----------|---------------|
| **Technology** | SaaS, App, Startup, Agency |
| **E-commerce** | Retail, Fashion, Electronics |
| **Finance** | Banking, Investment, Insurance |
| **Healthcare** | Clinic, Wellness, Medical |
| **Education** | Course, University, Training |
| **Food** | Restaurant, Delivery, Catering |
| **Travel** | Hotel, Agency, Tour |
| **Real Estate** | Property, Agency, Rental |
| **Creative** | Design, Photography, Art |

### Data Types

```json
{
  "business": {
    "name": "Company name",
    "tagline": "Short description",
    "description": "Full description (2-3 sentences)",
    "industry": "tech|finance|health|...",
    "founded": "2020",
    "employees": "50+"
  },
  "hero": {
    "headline": "Main value proposition",
    "subheadline": "Supporting text",
    "cta_primary": "Get Started",
    "cta_secondary": "Learn More"
  },
  "features": [
    {
      "title": "Feature name",
      "description": "Feature description",
      "icon": "icon-name"
    }
  ],
  "testimonials": [
    {
      "name": "Customer name",
      "role": "Job title",
      "company": "Company",
      "quote": "Testimonial text",
      "avatar": "url"
    }
  ],
  "pricing": [
    {
      "name": "Plan name",
      "price": "$29",
      "period": "month",
      "features": ["Feature 1", "Feature 2"],
      "recommended": false
    }
  ],
  "team": [
    {
      "name": "Person name",
      "role": "Job title",
      "bio": "Short bio",
      "avatar": "url"
    }
  ],
  "stats": [
    { "value": "10K+", "label": "Users" },
    { "value": "99%", "label": "Satisfaction" }
  ],
  "navigation": {
    "logo": "Brand",
    "links": ["Home", "Features", "Pricing", "About", "Contact"]
  },
  "footer": {
    "copyright": "© 2026 Company",
    "links": ["Privacy", "Terms", "Contact"]
  }
}
```

## Example Output

### Tech Startup

```json
{
  "business": {
    "name": "CloudSync",
    "tagline": "Seamless file synchronization for modern teams",
    "description": "CloudSync helps distributed teams stay in sync with real-time file sharing, automatic backups, and seamless collaboration across all devices.",
    "industry": "technology"
  },
  "hero": {
    "headline": "Your files, everywhere, instantly",
    "subheadline": "The smartest way to sync, share, and collaborate on files across your entire organization.",
    "cta_primary": "Start Free Trial",
    "cta_secondary": "Watch Demo"
  },
  "features": [
    {
      "title": "Real-time Sync",
      "description": "Changes sync instantly across all devices and team members.",
      "icon": "refresh"
    },
    {
      "title": "Smart Versioning",
      "description": "Never lose work with automatic version history and one-click restore.",
      "icon": "history"
    },
    {
      "title": "Enterprise Security",
      "description": "Bank-level encryption keeps your files safe and compliant.",
      "icon": "shield"
    }
  ],
  "testimonials": [
    {
      "name": "Sarah Chen",
      "role": "CTO",
      "company": "StartupXYZ",
      "quote": "CloudSync transformed how our remote team works. No more version conflicts or lost files."
    }
  ],
  "stats": [
    { "value": "500K+", "label": "Files synced daily" },
    { "value": "10K+", "label": "Teams" },
    { "value": "99.9%", "label": "Uptime" }
  ]
}
```

## Integration with Landing Pages

This skill is designed to work with:
- `@web-designer` agent for HTML prototypes
- `landing-page` skill for complete pages
- SvelteKit components for dynamic data

## Tips

1. **Specify industry** for more relevant data
2. **Request specific sections** (hero, features, testimonials, pricing)
3. **Customize tone** (professional, playful, corporate)
4. **Add constraints** (B2B vs B2C, target audience)
