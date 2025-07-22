#!/bin/bash
# Stop all Multi-Agent System processes

echo "🛑 Stopping Claude Multi-Agent Development System..."
echo ""

# Kill processes by name patterns
echo "Stopping orchestrator..."
pkill -f "orchestrator.py" 2>/dev/null

echo "Stopping comm monitor..."
pkill -f "comm_monitor.py" 2>/dev/null

echo "Stopping guide agent..."
pkill -f "agent.py" 2>/dev/null

echo "Stopping watch processes..."
pkill -f "watch.*comm.json" 2>/dev/null

echo "Stopping MCP servers..."
pkill -f "mcp-server-filesystem" 2>/dev/null

echo "Stopping Claude instances..."
# Find and kill Claude processes related to our agents
ps aux | grep -E "claude.*mcp-config|claude.*dev/claude.md|claude.*guide/claude.md" | grep -v grep | awk '{print $2}' | xargs kill 2>/dev/null

# Also check for the auto script
pkill -f "dev_auto.sh" 2>/dev/null

# Read PID file if it exists
if [ -f ".system_pids" ]; then
    echo ""
    echo "Cleaning up tracked PIDs..."
    while IFS=: read -r name pid; do
        if [ ! -z "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            echo "  Stopping $name (PID: $pid)"
            kill "$pid" 2>/dev/null
        fi
    done < ".system_pids"
    rm -f ".system_pids"
fi

# Close Terminal windows with our custom titles
echo ""
echo "Closing Terminal windows..."
osascript << 'EOF'
tell application "Terminal"
    set windowTitles to {"SYSTEM-MONITOR", "DEV-AGENT", "GUIDE-AGENT", "COMM-MONITOR"}
    
    repeat with w in windows
        try
            set wTitle to custom title of w
            if wTitle is in windowTitles then
                close w
            end if
        end try
    end repeat
end tell
EOF

echo ""
echo "✅ All processes stopped!"
echo ""
echo "To restart: ./start_system.sh"