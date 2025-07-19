#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Claude Code Isolated Container - YOLO Mode${NC}"
echo "=========================================="

# Check for API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo -e "${RED}Error: ANTHROPIC_API_KEY environment variable not set${NC}"
    echo "Please set it with: export ANTHROPIC_API_KEY='your-api-key'"
    exit 1
fi

# Build and start the container if not already running
if ! docker ps | grep -q claude-code-isolated; then
    echo -e "${GREEN}Building and starting container...${NC}"
    docker-compose up -d --build
    echo -e "${GREEN}Waiting for container to initialize...${NC}"
    sleep 5
fi

# Initialize firewall
echo -e "${GREEN}Initializing network isolation...${NC}"
docker exec claude-code-isolated sudo /usr/local/bin/init-firewall.sh

# Show safety reminder
echo -e "${YELLOW}⚠️  SAFETY REMINDER:${NC}"
echo "- This container has network isolation enabled"
echo "- Only approved domains are accessible (GitHub, NPM, Anthropic)"
echo "- Your dotfiles directory is mounted at /workspace"
echo "- Use Ctrl+C to exit Claude Code"
echo ""

# Run Claude in YOLO mode
echo -e "${GREEN}Starting Claude Code with --dangerously-skip-permissions...${NC}"
echo "=================================================="
docker exec -it claude-code-isolated claude --dangerously-skip-permissions