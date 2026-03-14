# Agent Skills Repository

A collection of reusable skills for AI agents that extend capabilities with specialized knowledge, workflows, and tools.

## Getting Started

Skills are reusable capabilities that help AI agents accomplish specific tasks more effectively. This repository contains skills that can be installed and used with the [skills.sh](https://skills.sh/) ecosystem.

### Installation

Install the skills CLI:

```bash
npm install -g @vercel/skills
# or
npx skills
```

### Installing Skills

Skills can be installed from git repositories, URLs, or local paths:

```bash
# Install from GitHub repository
npx skills add https://github.com/username/repo

# Install from GitHub shorthand (user/repo)
npx skills add username/repo

# Install from local directory
npx skills add ./path/to/skill-directory

# Install specific skills from this repository
npx skills add https://github.com/rbrown/clients/agent-skills
```

### Managing Skills

```bash
# List installed skills
npx skills list

# Check for updates
npx skills check

# Update all skills
npx skills update

# Initialize a new skill template
npx skills init my-new-skill
```

### Using Skills with AI Agents

Once installed, skills provide procedural knowledge that enhances what your AI agent can do. Each skill contains:

- **SKILL.md**: Instructions and guidance for using the skill
- **Optional resources**: Scripts, references, and assets for complex tasks

Skills are automatically loaded by compatible AI agents when the skill's trigger conditions are met.

## Available Skills

### create-skill
Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.

### fetch-website-content
Handles website content fetching and lookups by converting webpages to markdown format using markdown.new for efficient token usage. Use when needing to access, reference, or analyze web content from public websites, excluding local network or password-protected applications.

### git-commit-instructions
Generates git commit messages with custom formatting (short summary + bulleted changes), based on conventional commits workflow.

## Contributing

Skills follow a specific structure with a required `SKILL.md` file containing YAML frontmatter and markdown instructions. See the [create-skill](create-skill/) for detailed guidance on creating effective skills.

### Skill Structure

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code
    ├── references/       - Documentation
    └── assets/           - Files used in output
```

## Security

Skills are subject to routine security audits. While we strive to maintain a safe ecosystem, we encourage you to review skills before installation and use your own judgment. Report security issues to [security.vercel.com](https://security.vercel.com/).

## License

See LICENSE.txt for complete terms.