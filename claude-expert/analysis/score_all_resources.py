#!/usr/bin/env python3
import json
from datetime import datetime, timezone

# All resources including GitHub repos and other sources
all_resources = [
    # GitHub Repositories
    {
        "name": "anthropics/claude-code",
        "type": "github",
        "stars": 18538,
        "watchers": 115,
        "forks": 1049,
        "last_update": "2025-07-08",
        "created": "2025-02-22",
        "is_official": True,
        "unique_features": "Official implementation, latest features, primary source",
        "documentation": "Official documentation"
    },
    {
        "name": "anthropics/claude-code-action", 
        "type": "github",
        "stars": 1659,
        "watchers": 15,
        "forks": 921,
        "last_update": "2025-07-09",
        "created": "2025-05-19",
        "is_official": True,
        "unique_features": "GitHub Actions integration, CI/CD automation",
        "documentation": "Official GitHub Actions docs"
    },
    {
        "name": "hesreallyhim/awesome-claude-code",
        "type": "github",
        "stars": 3482,
        "watchers": 35,
        "forks": 178,
        "last_update": "2025-07-04",
        "created": "2025-04-19",
        "is_official": False,
        "unique_features": "Community hub, Claude Swarm, Claude Squad, experimental features",
        "documentation": "Well-documented community resource"
    },
    {
        "name": "cassler/awesome-claude-code-setup",
        "type": "github",
        "stars": 29,
        "watchers": 0,
        "forks": 1,
        "last_update": "2025-06-13",
        "created": "2025-06-10",
        "is_official": False,
        "unique_features": "50-80% token savings claim, 19 slash commands, 17 shell tools",
        "documentation": "Setup focused with specific metrics"
    },
    {
        "name": "qdhenry/Claude-Command-Suite",
        "type": "github",
        "stars": 233,
        "watchers": 1,
        "forks": 23,
        "last_update": "2025-07-07",
        "created": "2025-06-13",
        "is_official": False,
        "unique_features": "90+ commands, Ultra-think mode, Linear integration",
        "documentation": "Professional workflows documented"
    },
    {
        "name": "hikarubw/claude-commands",
        "type": "github",
        "stars": 3,
        "watchers": 0,
        "forks": 0,
        "last_update": "2025-06-15",
        "created": "2025-06-14",
        "is_official": False,
        "unique_features": "Minimal curated collection, quality over quantity",
        "documentation": "Basic documentation"
    },
    {
        "name": "disler/claude-code-hooks-mastery",
        "type": "github",
        "stars": 175,
        "watchers": 4,
        "forks": 36,
        "last_update": "2025-07-05",
        "created": "2025-07-05",
        "is_official": False,
        "unique_features": "5 hook types, UV single-file scripts, JSON flow control",
        "documentation": "Hooks-focused documentation"
    },
    {
        "name": "decider/claude-hooks",
        "type": "github",
        "stars": 10,
        "watchers": 0,
        "forks": 2,
        "last_update": "2025-07-10",
        "created": "2025-07-06",
        "is_official": False,
        "unique_features": "Clean code enforcement hooks",
        "documentation": "Basic hooks documentation"
    },
    {
        "name": "ruvnet/claude-flow",
        "type": "github",
        "stars": 1713,
        "watchers": 39,
        "forks": 299,
        "last_update": "2025-07-10",
        "created": "2025-06-02",
        "is_official": False,
        "unique_features": "87 MCP tools, Dynamic Agent Architecture, 27+ models, WASM SIMD",
        "documentation": "Advanced/experimental documentation"
    },
    {
        "name": "wshobson/commands",
        "type": "github",
        "stars": 13,
        "watchers": 1,
        "forks": 1,
        "last_update": "2025-06-14",
        "created": "2025-06-14",
        "is_official": False,
        "unique_features": "Production-ready focus, scaffolding tools",
        "documentation": "Production-oriented docs"
    },
    {
        "name": "iannuttall/claude-sessions",
        "type": "github",
        "stars": 622,
        "watchers": 7,
        "forks": 85,
        "last_update": "2025-06-16",
        "created": "2025-06-16",
        "is_official": False,
        "unique_features": "Session tracking, progress documentation, knowledge transfer",
        "documentation": "Comprehensive session management docs"
    },
    {
        "name": "steipete/agent-rules",
        "type": "github",
        "stars": 2619,
        "watchers": 28,
        "forks": 165,
        "last_update": "2025-06-25",
        "created": "2025-06-12",
        "is_official": False,
        "unique_features": "Cross-platform (Claude Code + Cursor), best practices",
        "documentation": "Multi-tool documentation"
    },
    {
        "name": "ArthurClune/claude-md-examples",
        "type": "github",
        "stars": 22,
        "watchers": 2,
        "forks": 4,
        "last_update": "2025-06-25",
        "created": "2025-03-06",
        "is_official": False,
        "unique_features": "CLAUDE.md examples and templates",
        "documentation": "Example-based documentation"
    },
    {
        "name": "zebbern/claude-code-guide",
        "type": "github",
        "stars": 1110,
        "watchers": 9,
        "forks": 89,
        "last_update": "2025-07-07",
        "created": "2025-06-21",
        "is_official": False,
        "unique_features": "Most complete command reference, hidden commands discovered",
        "documentation": "Comprehensive command reference"
    },
    {
        "name": "rizethereum/claude-code-requirements-builder",
        "type": "github",
        "stars": 1139,
        "watchers": 13,
        "forks": 120,
        "last_update": "2025-06-28",
        "created": "2025-06-27",
        "is_official": False,
        "unique_features": "Requirements generation, project specification tools",
        "documentation": "Requirements-focused docs"
    },
    {
        "name": "undeadpickle/claude-code-mcpinstall",
        "type": "github",
        "stars": 130,
        "watchers": 5,
        "forks": 12,
        "last_update": "2025-03-19",
        "created": "2025-03-19",
        "is_official": False,
        "unique_features": "MCP installation guide, global setup",
        "documentation": "MCP setup documentation"
    },
    {
        "name": "ygCEO/my-awesome-claude-code",
        "type": "github",
        "stars": 0,
        "watchers": 0,
        "forks": 0,
        "last_update": "2025-05-29",
        "created": "2025-06-04",
        "is_official": False,
        "unique_features": "Alternative curation approach",
        "documentation": "Basic curation"
    },
    {
        "name": "dwillitzer/claude-settings",
        "type": "github",
        "stars": 12,
        "watchers": 0,
        "forks": 8,
        "last_update": "2025-06-01",
        "created": "2025-05-29",
        "is_official": False,
        "unique_features": "Comprehensive permission settings templates",
        "documentation": "Configuration documentation"
    },
    {
        "name": "Maciek-roboblog/Claude-Code-Usage-Monitor",
        "type": "github",
        "stars": 2525,
        "watchers": 8,
        "forks": 112,
        "last_update": "2025-06-30",
        "created": "2025-06-19",
        "is_official": False,
        "unique_features": "Real-time usage tracking, cost predictions, warning system",
        "documentation": "Usage monitoring documentation"
    },
    {
        "name": "steipete/claude-code-mcp",
        "type": "github",
        "stars": 480,
        "watchers": 1,
        "forks": 45,
        "last_update": "2025-05-24",
        "created": "2025-05-13",
        "is_official": False,
        "unique_features": "Claude Code as MCP server, agent-in-agent pattern",
        "documentation": "Advanced integration docs"
    },
    {
        "name": "modelcontextprotocol/servers",
        "type": "github",
        "stars": 58779,
        "watchers": 432,
        "forks": 6794,
        "last_update": "2025-07-07",
        "created": "2024-11-19",
        "is_official": True,  # Official MCP repo
        "unique_features": "Official MCP implementations, Puppeteer server, reference examples",
        "documentation": "Official MCP documentation"
    },
    {
        "name": "joshuayoes/ios-simulator-mcp",
        "type": "github", 
        "stars": 683,
        "watchers": 4,
        "forks": 29,
        "last_update": "2025-07-09",
        "created": "2025-03-20",
        "is_official": False,
        "unique_features": "iOS simulator control, mobile testing, MCP integration",
        "documentation": "iOS MCP documentation"
    },
    {
        "name": "anthropics/claude-code/.devcontainer",
        "type": "github_subdir",
        "stars": 18538,  # Same as parent repo
        "watchers": 115,
        "forks": 1049,
        "last_update": "2025-07-08",
        "created": "2025-02-22",
        "is_official": True,
        "unique_features": "Official dev container setup, Docker configuration",
        "documentation": "Dev container documentation"
    },
    # Official Anthropic Resources
    {
        "name": "Anthropic Engineering Blog - Best Practices",
        "type": "blog",
        "url": "https://www.anthropic.com/engineering/claude-code-best-practices",
        "last_update": "2025-06-02",
        "published": "2025-04-18",
        "is_official": True,
        "unique_features": "Official best practices, production patterns, team insights",
        "documentation": "Primary best practices source"
    },
    {
        "name": "Claude 3.7 Sonnet Announcement",
        "type": "announcement",
        "url": "https://www.anthropic.com/news/claude-3-7-sonnet",
        "last_update": "2025-02-24",
        "published": "2025-02-24",
        "is_official": True,
        "unique_features": "Model specifications, performance improvements, official features",
        "documentation": "Official announcement"
    },
    {
        "name": "Claude Code Documentation",
        "type": "docs",
        "url": "https://claude.ai/code",
        "last_update": "2025-01-10",  # Assume current
        "is_official": True,
        "unique_features": "Primary documentation, getting started, feature guides",
        "documentation": "Official documentation site"
    },
    {
        "name": "Anthropic Prompt Improver",
        "type": "tool",
        "url": "https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-improver",
        "last_update": "2025-01-10",  # Assume current
        "is_official": True,
        "unique_features": "Official prompt optimization, interactive tool, best practices",
        "documentation": "Official tool documentation"
    },
    # Community Resources
    {
        "name": "claudecode.io",
        "type": "website",
        "url": "https://www.claudecode.io/commands",
        "is_official": False,
        "unique_features": "60+ commands, community platform",
        "documentation": "Community documentation"
    },
    {
        "name": "Claude Code Training Platform",
        "type": "course",
        "url": "https://www.claude-code-training.com/",
        "is_official": False,
        "unique_features": "Professional training, workshops, certification",
        "documentation": "Training course materials"
    },
    # Blog/Article Resources
    {
        "name": "Medium: Claude Code Hooks Automation",
        "type": "article",
        "url": "https://medium.com/@joe.njenga/use-claude-code-hooks-newest-feature-to-fully-automate-your-workflow-341b9400cfbe",
        "is_official": False,
        "unique_features": "Hooks automation tutorial, workflow examples",
        "documentation": "Tutorial article"
    },
    # Gist Collections
    {
        "name": "pillheadddd's Slash Commands",
        "type": "gist",
        "url": "https://gist.github.com/pillheadddd/9c8f5823856e6c857f85e613e31e1d90",
        "is_official": False,
        "unique_features": "Slash command reference collection",
        "documentation": "Command reference"
    },
    {
        "name": "transitive-bullshit's Prompts",
        "type": "gist", 
        "url": "https://gist.github.com/transitive-bullshit/487c9cb52c75a9701d312334ed53b20c",
        "is_official": False,
        "unique_features": "Prompt collection",
        "documentation": "Prompt examples"
    },
    {
        "name": "rjurney's Configuration",
        "type": "gist",
        "url": "https://gist.github.com/rjurney/f7364f2dd0f6b6c21ecd33690eee4fdf",
        "is_official": False,
        "unique_features": "Configuration examples",
        "documentation": "Config documentation"
    },
    {
        "name": "artemgetmann's Token Optimization",
        "type": "gist",
        "url": "https://gist.github.com/artemgetmann/74f28d2958b53baf50597b669d4bce43",
        "is_official": False,
        "unique_features": "Token optimization workflow",
        "documentation": "Optimization guide"
    }
]

def calculate_freshness_score(last_update, resource_type="github"):
    """Calculate freshness score (0-10 points)"""
    if resource_type in ["docs", "tool"] or not last_update:
        return 8  # Assume official docs/tools are maintained
    
    today = datetime(2025, 1, 10)
    try:
        if isinstance(last_update, str):
            last_update_date = datetime.strptime(last_update, "%Y-%m-%d")
        else:
            return 5  # Default for unknown dates
    except:
        return 5
    
    days_diff = (today - last_update_date).days
    
    if days_diff <= 30:
        return 10
    elif days_diff <= 90:
        return 7
    elif days_diff <= 180:
        return 4
    elif days_diff <= 365:
        return 2
    else:
        return 0

def calculate_popularity_score(resource):
    """Calculate popularity score (0-10 points)"""
    if resource.get("is_official"):
        return 10  # Official resources get full points
    
    if resource["type"] == "github":
        stars = resource.get("stars", 0)
        if stars >= 2500:
            return 9
        elif stars >= 1000:
            return 7
        elif stars >= 500:
            return 5
        elif stars >= 100:
            return 3
        elif stars >= 50:
            return 2
        else:
            return 1
    else:
        # Non-GitHub resources get moderate scores
        return 3

def calculate_engagement_score(resource):
    """Calculate community engagement score (0-10 points)"""
    if resource["type"] == "github":
        watchers = resource.get("watchers", 0)
        forks = resource.get("forks", 0)
        engagement = watchers + forks
        
        if engagement >= 500:
            return 10
        elif engagement >= 200:
            return 8
        elif engagement >= 100:
            return 6
        elif engagement >= 50:
            return 4
        elif engagement >= 20:
            return 2
        else:
            return 1
    else:
        # Non-GitHub resources
        if resource.get("is_official"):
            return 8
        else:
            return 2

def calculate_uniqueness_score(features):
    """Calculate uniqueness score (0-10 points)"""
    unique_keywords = [
        "token savings", "MCP", "hooks", "swarm", "squad", "ultra", "wasm", 
        "agent-in-agent", "cross-platform", "hidden commands", "real-time", 
        "CI/CD", "90+ commands", "87 MCP tools", "official", "primary",
        "iOS simulator", "puppeteer", "dev container", "prompt optimization"
    ]
    
    score = 0
    features_lower = features.lower()
    for keyword in unique_keywords:
        if keyword.lower() in features_lower:
            score += 2
    
    return min(score, 10)

def calculate_documentation_score(resource):
    """Calculate documentation score (0-10 points)"""
    doc_desc = resource.get("documentation", "").lower()
    
    if resource.get("is_official"):
        return 10
    elif "comprehensive" in doc_desc or "complete" in doc_desc:
        return 8
    elif "well-documented" in doc_desc or "professional" in doc_desc:
        return 7
    elif "focused" in doc_desc or "specific" in doc_desc:
        return 6
    elif "tutorial" in doc_desc or "guide" in doc_desc:
        return 5
    elif "basic" in doc_desc:
        return 3
    else:
        return 2

def calculate_authority_bonus(resource):
    """Add bonus points for official/authoritative sources (0-10 points)"""
    if resource.get("is_official"):
        if "anthropic" in resource["name"].lower():
            return 10  # Maximum bonus for official Anthropic resources
        else:
            return 8  # High bonus for other official resources (like MCP)
    elif resource["type"] == "github" and resource.get("stars", 0) > 10000:
        return 5  # Bonus for extremely popular repos
    else:
        return 0

# Calculate scores for each resource
results = []
for resource in all_resources:
    freshness = calculate_freshness_score(
        resource.get("last_update"), 
        resource.get("type", "github")
    )
    popularity = calculate_popularity_score(resource)
    engagement = calculate_engagement_score(resource)
    uniqueness = calculate_uniqueness_score(resource.get("unique_features", ""))
    documentation = calculate_documentation_score(resource)
    authority = calculate_authority_bonus(resource)
    
    # Total out of 60 points (including authority bonus)
    total = freshness + popularity + engagement + uniqueness + documentation + authority
    
    results.append({
        "name": resource["name"],
        "type": resource.get("type", "unknown"),
        "is_official": resource.get("is_official", False),
        "scores": {
            "freshness": freshness,
            "popularity": popularity,
            "engagement": engagement,
            "uniqueness": uniqueness,
            "documentation": documentation,
            "authority": authority,
            "total": total
        },
        "url": resource.get("url", f"https://github.com/{resource['name']}" if resource.get("type") == "github" else ""),
        "stars": resource.get("stars", 0) if resource.get("type") == "github" else None
    })

# Sort by total score
results.sort(key=lambda x: x["scores"]["total"], reverse=True)

# Print results
print("Claude Code Resources Comprehensive Scoring Results")
print("=" * 120)
print(f"{'Resource':<55} {'Type':<12} {'Fresh':>6} {'Pop':>4} {'Eng':>4} {'Uniq':>5} {'Doc':>4} {'Auth':>5} {'Total':>6}")
print("-" * 120)

for result in results:
    scores = result["scores"]
    official_marker = "⭐" if result["is_official"] else "  "
    print(f"{official_marker}{result['name'][:53]:<53} {result['type']:<12} {scores['freshness']:>6} {scores['popularity']:>4} {scores['engagement']:>4} {scores['uniqueness']:>5} {scores['documentation']:>4} {scores['authority']:>5} {scores['total']:>6}/60")

# Save detailed results
with open('/Users/thomas.sample/.dotfiles/comprehensive_scores.json', 'w') as f:
    json.dump(results, f, indent=2)

print("\n" + "=" * 120)
print("Top 15 Resources by Score:")
print("-" * 120)
for i, result in enumerate(results[:15], 1):
    official_marker = "⭐" if result["is_official"] else "  "
    print(f"{i:2}. {official_marker}{result['name']:<50} Score: {result['scores']['total']}/60")
    if result.get("url"):
        print(f"    URL: {result['url']}")

print("\n⭐ = Official Anthropic or MCP resource")
print("\nScoring includes 6 categories (10 points each):")
print("- Freshness: How recently updated")
print("- Popularity: Stars/recognition")
print("- Engagement: Community activity")
print("- Uniqueness: Novel features")
print("- Documentation: Quality of docs")
print("- Authority: Bonus for official sources")