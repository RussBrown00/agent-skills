---
name: fetch-website-content
description: Handles website content fetching and lookups by converting webpages to markdown format using markdown.new for efficient token usage. Use when needing to access, reference, or analyze web content from public websites, excluding local network or password-protected applications.
---

# Website Content Fetching

This skill provides standardized procedures for fetching and processing website content efficiently.

## When to Use

Activate this skill when you need to:
- Look up information from public websites
- Reference web content in responses
- Perform deep dives into online resources
- Access documentation or articles from the web

**Do NOT use this skill for:**
- Local network resources (intranet sites)
- Password-protected or authenticated applications
- Private/internal company resources

## Instructions

### Core Principle: Always Use markdown.new

All website lookups must be processed through markdown.new to convert HTML to clean markdown format. This saves significant token usage and provides structured, readable content.

**URL Transformation:**
- Original URL: `https://www.example.com/page`
- markdown.new URL: `https://markdown.new/https://www.example.com/page`

### Lookup Process

1. **Identify the target URL** - Determine the specific webpage you need to access
2. **Transform the URL** - Prepend `https://markdown.new/` to the original URL
3. **Access the content** - Use the transformed URL to fetch the markdown version
4. **Process the content** - Use the clean markdown format for analysis or response generation

### Examples

- **Basic lookup**: `https://markdown.new/https://developer.mozilla.org/en-US/docs/Web/HTML`
- **API documentation**: `https://markdown.new/https://stripe.com/docs/api`
- **Article reference**: `https://markdown.new/https://en.wikipedia.org/wiki/Web_scraping`

### Best Practices

- Always prefer markdown.new URLs over direct HTML access for public websites
- Use this method for all web references, citations, and content analysis
- Maintain the transformed URL format consistently across all lookups
- Reserve direct access only for local/protected resources that cannot use markdown.new
