---
name: "maxun"
description: "Open-source no-code platform for web scraping, crawling, search and AI data extraction. Use when user needs to scrape websites, extract data, crawl web pages, or automate data collection."
version: "1.1.0"
author: "Agent Zero Team"
tags: ["web-scraping", "no-code", "crawler", "data-extraction", "playwright", "rpa"]
trigger_patterns:
  - "maxun"
  - "scrape website"
  - "web scraping"
  - "extract data"
  - "crawl website"
  - "website automation"
  - "data extraction"
  - "playwright scraping"
---

# Maxun - Web Scraping & Data Extraction Platform

## What is Maxun?

Maxun is an open-source no-code platform for web scraping, crawling, search and AI data extraction. It turns websites into structured APIs in minutes.

**Links:**
- GitHub: https://github.com/getmaxun/maxun
- Website: https://www.maxun.dev
- Documentation: https://docs.maxun.dev
- Live App: https://app.maxun.dev

## 🆕 GitMCP Integration

For deeper code understanding and AI-assisted development, Maxun has a dedicated GitMCP server:

**GitMCP URL**: `https://gitmcp.io/getmaxun/maxun`

### What is GitMCP?

GitMCP creates a Model Context Protocol (MCP) server for the Maxun repository, enabling AI assistants to understand the code in context by reading llms.txt, llms-full.txt, readme.md and more.

### Using GitMCP with Maxun

The GitMCP server can be integrated with MCP-compatible AI tools:

**Claude Desktop** (`claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "maxun Docs": {
      "command": "npx",
      "args": ["mcp-remote", "https://gitmcp.io/getmaxun/maxun"]
    }
  }
}
```

**Cursor** (`~/.cursor/mcp.json`):
```json
{
  "mcpServers": {
    "maxun Docs": {
      "url": "https://gitmcp.io/getmaxun/maxun"
    }
  }
}
```

**Other MCP tools** (Windsurf, VSCode, Cline, etc.) can use the same URL pattern.

## When to Use This Skill

Activate when user asks to:
- Scrape data from websites
- Extract structured data from web pages
- Crawl entire websites
- Automate web searches
- Create APIs from websites
- Handle pagination and scrolling
- Extract data behind login
- Generate leads from web sources
- Perform market research via web data
- Integrate with GitMCP for code understanding

## Maxun Ecosystem (4 Types of Robots)

### 1. Extract - Structured Data Extraction

Emulate real user behavior and collect structured data from any website.

**Two Modes:**

#### Recorder Mode
- Record your actions as you browse
- Maxun turns them into a reusable extraction robot
- Point and click interface
- Perfect for repetitive tasks

**Use Cases:**
- Extract product listings from e-commerce sites
- Collect property listings from real estate sites
- Gather job postings from career sites

#### AI Mode
- Describe what you want in natural language
- LLM-powered extraction handles the rest
- No manual selection needed
- Adapts to page structure automatically

**Use Cases:**
- Extract names, ratings, and duration from movie sites
- Pull specific fields from complex pages
- Extract data with changing layouts

### 2. Scrape - Full Page Content

Convert full webpages into clean Markdown or HTML and capture screenshots.

**Features:**
- Clean Markdown for AI workflows
- Raw HTML for processing
- Screenshot capture
- Ideal for document processing

**Use Cases:**
- AI agent knowledge base building
- Document processing
- Content archiving
- LLM training data collection

### 3. Crawl - Website Crawling

Crawl entire websites and extract content from every relevant page.

**Features:**
- Full control over scope and discovery
- Depth limits
- URL pattern filtering
- Parallel processing

**Use Cases:**
- Build site search indexes
- Content aggregation
- Competitive analysis
- SEO analysis

### 4. Search - Automated Web Searches

Run automated web searches to discover or scrape results.

**Features:**
- Time-based filters
- Multiple search engines
- Result pagination
- Structured output

**Use Cases:**
- Trend monitoring
- News aggregation
- Competitor tracking
- Market research

## Installation Options

### Option 1: Hosted Version (Fastest)

1. Go to https://app.maxun.dev
2. Sign up/login
3. Start creating robots immediately

### Option 2: Docker Compose (Recommended for Self-Hosting)

```bash
# Clone repository
git clone https://github.com/getmaxun/maxun.git
cd maxun

# Copy environment variables
cp ENVEXAMPLE .env

# Edit .env with your settings
nano .env

# Start with Docker Compose
docker-compose up -d
```

### Option 3: Local Setup

```bash
# Clone repository
git clone https://github.com/getmaxun/maxun.git
cd maxun

# Install dependencies (Node.js required)
npm install

# Setup database
npm run db:migrate

# Start server
npm run dev
```

### Environment Variables (Key Settings)

See docs for complete list, but key variables include:
- `DATABASE_URL`: PostgreSQL connection string
- `JWT_SECRET`: Secret for authentication
- `PLAYWRIGHT_BROWSERS_PATH`: Path to Playwright browsers
- `REPLICATE_API_TOKEN`: For AI mode (if using Replicate)

## SDK Usage

Maxun provides a Node.js SDK for programmatic access:

```bash
npm install @maxun/sdk
```

**SDK Features:**
- Programmatic extraction
- Robot management
- Scheduling
- End-to-end data automation

## Key Features

| Feature | Description |
|---------|-------------|
| **No-Code Interface** | Point and click data selection |
| **LLM-Powered Extraction** | Natural language data extraction |
| **Developer SDK** | Full programmatic control |
| **Pagination & Scrolling** | Automatic navigation handling |
| **Scheduled Runs** | Set and forget automation |
| **API Endpoints** | RESTful APIs from any site |
| **Spreadsheet Export** | Google Sheets & Airtable integration |
| **Auto-Recovery** | Adapts to site layout changes |
| **Authentication** | Handles login seamlessly |
| **MCP Support** | Model Context Protocol integration |
| **LLM-Ready Data** | Clean Markdown output |
| **Self-Hostable** | Full infrastructure control |
| **GitMCP Integration** | Deep code understanding via MCP server |

## Quick Start Workflow

### For Extract (Structured Data)

1. Open Maxun app
2. Click "New Robot"
3. Choose "Extract"
4. **Either:**
   - Click "Recorder" and record actions
   - Click "AI Mode" and describe what you want
5. Preview results
6. Run robot or schedule it
7. Export data (API, CSV, JSON, Google Sheets)

### For Scrape (Full Page)

1. Click "New Robot"
2. Choose "Scrape"
3. Enter URL
4. Select output format (Markdown/HTML)
5. Enable screenshot if needed
6. Run and download results

### For Crawl (Entire Site)

1. Click "New Robot"
2. Choose "Crawl"
3. Enter starting URL
4. Set crawl limits (depth, pages)
5. Define URL patterns to include/exclude
6. Run and monitor progress

### For Search (Automated Search)

1. Click "New Robot"
2. Choose "Search"
3. Enter search query
4. Set time filters
5. Configure results extraction
6. Run and export results

## Common Use Cases

### Lead Generation
```
Source: LinkedIn, Yelp, Yellow Pages, etc.
Extract: Company name, contact, email, phone
Output: Google Sheets / CSV
```

### Price Monitoring
```
Source: E-commerce sites (Amazon, eBay)
Extract: Product name, price, availability
Schedule: Daily/Hourly
```

### Content Aggregation
```
Source: News sites, blogs
Extract: Headlines, articles, dates
Schedule: Every 6 hours
```

### Real Estate Data
```
Source: Zillow, Rightmove, Airbnb
Extract: Property details, prices, locations
Output: Database / API
```

## Best Practices

### Respect Robots.txt
Always check and respect the target site's robots.txt file.

### Rate Limiting
- Set appropriate delays between requests
- Use random delays when possible
- Don't overload servers

### Error Handling
- Set up retries for failed extractions
- Monitor robot performance
- Set up alerts for failures

### Data Quality
- Preview results before full runs
- Validate extracted data
- Clean and normalize output

### Legal Compliance
- Check terms of service of target sites
- Respect copyright
- Comply with GDPR/CCPA for personal data

## Troubleshooting

### Robot Fails
1. Check if site structure changed
2. Increase timeout settings
3. Verify selectors are still valid
4. Check browser console for errors

### Slow Performance
1. Reduce concurrent requests
2. Increase delays between requests
3. Check network connection
4. Consider upgrading infrastructure

### Authentication Issues
1. Verify credentials in robot settings
2. Check if login flow changed
3. Use browser agent for complex auth

## Integration Examples

### Google Sheets
```
Robot Settings → Integrations → Connect Google Sheets
Choose spreadsheet → Map columns → Save
```

### Webhook
```
Robot Settings → Webhook → Add URL
Configure payload format → Test → Save
```

### API Endpoint
```
Robot Settings → API → Copy endpoint
Use in your applications with JWT auth
```

### GitMCP for Development
```
URL: https://gitmcp.io/getmaxun/maxun
Use with Claude Desktop, Cursor, Windsurf, etc.
For code understanding and AI-assisted development
```

## License

Maxun is licensed under AGPLv3. If using commercially, consider contributing back.

## Additional Resources

- Discord Community: https://discord.gg/5GbPjBUkws
- YouTube Tutorials: https://www.youtube.com/@MaxunOSS
- SDK Repository: https://github.com/getmaxun/node-sdk
- Documentation: https://docs.maxun.dev
- GitMCP Server: https://gitmcp.io/getmaxun/maxun
- GitMCP Docs: https://gitmcp.io/docs
