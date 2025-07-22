#!/bin/bash
# Multi-Agent System Startup Script
# This script opens all necessary terminals for the AI pair programming system

cd $(dirname "$0")

echo "🚀 Starting Claude Multi-Agent Development System..."
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
fi

# 2. Start DEV Agent with MCP
if ! check_running "dev/dev.sh" "DEV Agent"; then
    echo "🛠️  Starting DEV Agent (MCP-enabled)..."
    osascript << EOF
tell application "Terminal"
    set devWindow to do script "cd '$(pwd)/dev' && ./dev.sh"
    set custom title of window 1 to "DEV-AGENT"
end tell
EOF
    sleep 2
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
fi

# 4. Open Comm.json Watcher
echo "👀 Starting Communication Monitor..."
osascript << EOF
tell application "Terminal"
    set watchWindow to do script "cd '$(pwd)' && watch -n 1 'tail -20 comm.json | jq .'"
    set custom title of window 1 to "COMM-MONITOR"
end tell
EOF

echo ""
echo "✅ All systems started!"
echo ""
echo "Windows opened:"
echo "  - SYSTEM-MONITOR: Real-time message tracking"
echo "  - DEV-AGENT: MCP-enabled developer"
echo "  - GUIDE-AGENT: Autonomous mentor"
echo "  - COMM-MONITOR: Live communication feed"
echo ""
echo "🎉 The Multi-Agent System is ready!"