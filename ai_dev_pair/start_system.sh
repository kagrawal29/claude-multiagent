#!/bin/bash
# Multi-Agent System Startup Script V2
# This script opens all necessary terminals for the AI pair programming system

cd $(dirname "$0")

# Store PIDs for cleanup
PID_FILE=".system_pids"
> "$PID_FILE"

echo "🚀 Starting Claude Multi-Agent Development System..."
echo ""
echo "This system provides a complete AI pair programming environment with:"
echo ""
echo "📊 SYSTEM OVERVIEW:"
echo "┌─────────────────────────────────────────────────────────────────┐"
echo "│  1. SYSTEM-MONITOR (orchestrator.py)                           │"
echo "│     • Real-time health monitoring of all agents                │"
echo "│     • Shows agent status, message flow, and system health      │"
echo "│     • Auto-restarts failed agents                              │"
echo "├─────────────────────────────────────────────────────────────────┤"
echo "│  2. DEV-AGENT (MCP-enabled Claude)                             │"
echo "│     • Your primary developer with file system access           │"
echo "│     • Follows TEST-FIRST approach with Playwright E2E testing  │"
echo "│     • Auto-checks for new tasks every 2 minutes               │"
echo "├─────────────────────────────────────────────────────────────────┤"
echo "│  3. GUIDE-AGENT (Autonomous Mentor)                            │"
echo "│     • Senior engineer providing guidance and review            │"
echo "│     • Enforces quality standards and E2E testing requirements  │"
echo "│     • Can reprogram DEV agent behavior                         │"
echo "├─────────────────────────────────────────────────────────────────┤"
echo "│  4. COMM-MONITOR (Live Message Feed)                           │"
echo "│     • Shows all messages between agents in real-time           │"
echo "│     • JSON formatted for easy reading                          │"
echo "│     • Use to track conversation flow                           │"
echo "└─────────────────────────────────────────────────────────────────┘"
echo ""
echo "🎮 HOW TO USE:"
echo "• Send tasks via: python3 send_message.py dev \"Your task\""
echo "• Monitor progress: Watch the COMM-MONITOR window"
echo "• Check health: Look at SYSTEM-MONITOR for agent status"
echo "• Stop system: Run ./stop_system.sh"
echo ""
echo "Starting components..."
echo ""

# Function to check if a process is already running
check_running() {
    if pgrep -f "$1" > /dev/null; then
        echo "⚠️  $2 appears to be already running. Skipping..."
        return 0
    else
        return 1
    fi
}

# 1. Start System Monitor (Orchestrator)
if ! check_running "orchestrator.py" "System Monitor"; then
    echo "📊 Starting System Monitor..."
    osascript << EOF
tell application "Terminal"
    set monitorWindow to do script "cd '$(pwd)' && python3 orchestrator.py"
    set custom title of window 1 to "SYSTEM-MONITOR"
end tell
EOF
    sleep 2
    # Get PID
    echo "orchestrator:$(pgrep -f 'python3 orchestrator.py' | tail -1)" >> "$PID_FILE"
fi

# 2. Start DEV Agent with MCP (Modified to be fully autonomous)
if ! check_running "mcp-server-filesystem" "DEV Agent"; then
    echo "🛠️  Starting DEV Agent (MCP-enabled)..."
    
    osascript << EOF
tell application "Terminal"
    set devWindow to do script "cd '$(pwd)/dev' && ./dev.sh"
    set custom title of window 1 to "DEV-AGENT"
end tell
EOF
    sleep 3
    # Get PID
    echo "dev:$(pgrep -f 'claude.*mcp-config' | tail -1)" >> "$PID_FILE"
    echo "mcp:$(pgrep -f 'mcp-server-filesystem' | tail -1)" >> "$PID_FILE"
fi

# 3. Start GUIDE Agent in Autonomous Mode
if ! check_running "guide/agent.py" "GUIDE Agent"; then
    echo "🎯 Starting GUIDE Agent (Autonomous)..."
    osascript << EOF
tell application "Terminal"
    set guideWindow to do script "cd '$(pwd)/guide' && python3 agent.py"
    set custom title of window 1 to "GUIDE-AGENT"
end tell
EOF
    sleep 2
    # Get PID
    echo "guide:$(pgrep -f 'python3 agent.py' | tail -1)" >> "$PID_FILE"
fi

# 4. Open Comm.json Watcher
echo "👀 Starting Communication Monitor..."
osascript << EOF
tell application "Terminal"
    set watchWindow to do script "cd '$(pwd)' && watch -n 1 'tail -30 comm.json | jq . || echo \"Waiting for messages...\"'"
    set custom title of window 1 to "COMM-MONITOR"
end tell
EOF
# Get PID
sleep 1
echo "watch:$(pgrep -f 'watch.*comm.json' | tail -1)" >> "$PID_FILE"

echo ""
echo "✅ All systems started!"
echo ""
echo "💡 Quick Start:"
echo "   python3 send_message.py dev \"Create a simple todo app with React\""
echo ""
echo "📖 For more info, check README.md"
echo ""
echo "🛑 To stop all processes: ./stop_system.sh"