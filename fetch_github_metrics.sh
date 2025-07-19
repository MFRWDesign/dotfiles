#!/bin/bash

# Function to fetch and display repo metrics
fetch_repo() {
    local repo=$1
    echo "Fetching: $repo"
    
    data=$(curl -s "https://api.github.com/repos/$repo")
    
    if [ $? -eq 0 ]; then
        echo "$data" | jq -r '
            "Repository: " + .full_name + "\n" +
            "Stars: " + (.stargazers_count | tostring) + "\n" +
            "Watchers: " + (.subscribers_count | tostring) + "\n" +
            "Forks: " + (.forks_count | tostring) + "\n" +
            "Last Push: " + .pushed_at + "\n" +
            "Created: " + .created_at + "\n" +
            "Description: " + (.description // "No description") + "\n" +
            "Language: " + (.language // "None") + "\n" +
            "---"
        '
    else
        echo "Error fetching $repo"
    fi
    
    # Be nice to GitHub API
    sleep 1
}

# List of repositories
repos=(
    "hesreallyhim/awesome-claude-code"
    "anthropics/claude-code"
    "cassler/awesome-claude-code-setup"
    "qdhenry/Claude-Command-Suite"
    "hikarubw/claude-commands"
    "disler/claude-code-hooks-mastery"
    "decider/claude-hooks"
    "ruvnet/claude-flow"
    "wshobson/commands"
    "iannuttall/claude-sessions"
    "steipete/agent-rules"
    "ArthurClune/claude-md-examples"
    "zebbern/claude-code-guide"
    "rizethereum/claude-code-requirements-builder"
    "undeadpickle/claude-code-mcpinstall"
    "ygCEO/my-awesome-claude-code"
    "dwillitzer/claude-settings"
    "Maciek-roboblog/Claude-Code-Usage-Monitor"
    "steipete/claude-code-mcp"
    "anthropics/claude-code-action"
)

# Fetch metrics for each repo
for repo in "${repos[@]}"; do
    fetch_repo "$repo"
done