#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Network Isolation Test for Claude Code Container${NC}"
echo "================================================"

# Function to test connectivity
test_connection() {
    local url=$1
    local expected=$2
    local description=$3
    
    echo -n "Testing $description... "
    
    if docker exec claude-code-isolated curl -s --connect-timeout 5 "$url" > /dev/null 2>&1; then
        if [ "$expected" = "allow" ]; then
            echo -e "${GREEN}✓ PASS${NC} (connection allowed as expected)"
            return 0
        else
            echo -e "${RED}✗ FAIL${NC} (connection succeeded but should be blocked)"
            return 1
        fi
    else
        if [ "$expected" = "block" ]; then
            echo -e "${GREEN}✓ PASS${NC} (connection blocked as expected)"
            return 0
        else
            echo -e "${RED}✗ FAIL${NC} (connection failed but should be allowed)"
            return 1
        fi
    fi
}

# Ensure container is running
if ! docker ps | grep -q claude-code-isolated; then
    echo -e "${RED}Error: Container not running. Run ./run-claude-yolo.sh first${NC}"
    exit 1
fi

echo -e "\n${YELLOW}Testing ALLOWED connections:${NC}"
test_connection "https://api.github.com/zen" "allow" "GitHub API"
test_connection "https://registry.npmjs.org" "allow" "NPM Registry"
test_connection "https://api.anthropic.com" "allow" "Anthropic API"

echo -e "\n${YELLOW}Testing BLOCKED connections:${NC}"
test_connection "https://example.com" "block" "Random website"
test_connection "https://google.com" "block" "Google"
test_connection "https://openai.com" "block" "OpenAI"

echo -e "\n${YELLOW}Testing DNS resolution:${NC}"
if docker exec claude-code-isolated nslookup github.com > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC} DNS resolution working"
else
    echo -e "${RED}✗ FAIL${NC} DNS resolution not working"
fi

echo -e "\n${YELLOW}Firewall Rules Summary:${NC}"
docker exec claude-code-isolated sudo iptables -L OUTPUT -n | grep -E "ACCEPT|DROP" | head -5

echo -e "\n${GREEN}Test complete!${NC}"