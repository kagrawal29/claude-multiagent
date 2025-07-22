#!/bin/bash
# 🚀 Claude Multi-Agent Development System - One-Click Startup
# Run this script to launch the entire system with the ORCHESTRATOR

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     🤖 Claude Multi-Agent Development System 🤖            ║"
echo "║                                                            ║"
echo "║     AI Pair Programming with DEV & GUIDE Agents           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Error: Claude CLI not found!"
    echo "Please install it first: pip install claude"
    exit 1
fi

# Navigate to the ai_dev_pair directory
cd ai_dev_pair || {
    echo "❌ Error: ai_dev_pair directory not found!"
    echo "Make sure you're running this from the claude_multiagent directory"
    exit 1
}

echo "🎯 Starting ORCHESTRATOR with automatic system initialization..."
echo ""
echo "The ORCHESTRATOR will:"
echo "  ✓ Launch all system components automatically"
echo "  ✓ Open monitoring terminals"
echo "  ✓ Start DEV agent with MCP/Playwright support"
echo "  ✓ Start GUIDE agent in autonomous mode"
echo "  ✓ Begin monitoring communications"
echo ""
echo "📝 Usage: Just tell the ORCHESTRATOR what you want to build!"
echo ""
echo "Starting in 3 seconds..."
sleep 3

# Start Claude with the ORCHESTRATOR prompt
claude --append-system-prompt "$(cat claude.md)"