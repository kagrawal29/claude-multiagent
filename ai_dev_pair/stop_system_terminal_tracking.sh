#!/bin/bash
# Simple Terminal Tracking Stop - Kill the exact terminals we started

cd $(dirname "$0")
source "$(dirname "$0")/system_utils.sh"

TERMINAL_IDS_FILE=".terminal_ids.txt"

echo "📱 Stopping Multi-Agent System - Terminal Tracking..."
echo "=================================================="

# Stop background processes first
log "🔧 Stopping background MCP servers..."
if [ -f ".mcp_filesystem.pid" ]; then
    pid=$(cat ".mcp_filesystem.pid")
    if kill -0 "$pid" 2>/dev/null; then
        kill -TERM "$pid" 2>/dev/null
        sleep 2
        kill -9 "$pid" 2>/dev/null
    fi
    rm -f ".mcp_filesystem.pid"
fi

if [ -f ".mcp_playwright.pid" ]; then
    pid=$(cat ".mcp_playwright.pid")
    if kill -0 "$pid" 2>/dev/null; then
        kill -TERM "$pid" 2>/dev/null
        sleep 2  
        kill -9 "$pid" 2>/dev/null
    fi
    rm -f ".mcp_playwright.pid"
fi

# Stop terminals
if [ ! -f "$TERMINAL_IDS_FILE" ]; then
    error "❌ No terminal tracking file found!"
    exit 1
fi

log "📋 Terminals to close:"
cat "$TERMINAL_IDS_FILE"

echo ""
log "🔪 Closing tracked terminals..."

# Close each terminal by title (simpler approach)
closed_count=0
while read -r title; do
    if [ ! -z "$title" ]; then
        log "Closing $title..."
        
        osascript << EOF 2>/dev/null
tell application "Terminal"
    repeat with w in windows
        try
            set wTitle to custom title of w
            if wTitle is equal to "$title" then
                close w
            end if
        on error
            -- Continue if error
        end try
    end repeat
end tell
EOF
        
        closed_count=$((closed_count + 1))
        success "✅ Closed $title"
    fi
done < "$TERMINAL_IDS_FILE"

# Clean up tracking file
rm -f "$TERMINAL_IDS_FILE"

# Also close any DEV-MCP terminals (created by dev.sh)
log "🎯 Closing DEV-MCP terminals..."
osascript << 'EOF' 2>/dev/null
tell application "Terminal"
    repeat with w in windows
        try
            set wTitle to custom title of w
            if wTitle contains "DEV-MCP-" then
                close w
            end if
        on error
            -- Continue if error
        end try
    end repeat
end tell
EOF

# Also kill any remaining MCP processes by pattern
log "🧹 Cleaning up any remaining MCP processes..."
pkill -f "mcp-server-filesystem" 2>/dev/null
pkill -f "mcp-server-playwright" 2>/dev/null  
pkill -f "@playwright/mcp" 2>/dev/null
pkill -f "@modelcontextprotocol/server-filesystem" 2>/dev/null

# Kill any remaining Claude processes that might be DEV agents
log "🎯 Cleaning up any remaining Claude DEV processes..."
for pid in $(pgrep -f "claude" 2>/dev/null); do
    if [ ! -z "$pid" ]; then
        # Check if this is a recent Claude process (likely our DEV agent)
        process_info=$(ps -p $pid -o etime= 2>/dev/null)
        if [[ "$process_info" =~ ^[[:space:]]*[0-9]{1,2}:[0-9]{2}$ ]]; then
            log "Killing recent Claude process: $pid"
            kill -9 "$pid" 2>/dev/null
        fi
    fi
done

echo ""
success "🎉 Closed $closed_count terminals and cleaned up background processes!"
log "🚀 To restart: ./start_system_terminal_tracking.sh"