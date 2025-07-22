#!/bin/bash
# Simple Terminal Tracking - Track terminal IDs, not processes

cd $(dirname "$0")
source "$(dirname "$0")/system_utils.sh"

TERMINAL_IDS_FILE=".terminal_ids.txt"

echo "📱 Starting Multi-Agent System with Terminal Tracking..."
echo "===================================================="

# Clean previous terminal IDs
> "$TERMINAL_IDS_FILE"

# Function to start terminal and record its title (simpler approach)
start_terminal() {
    local title="$1"
    local command="$2"
    local description="$3"
    
    log "🚀 Starting $description..."
    
    # Start terminal with unique title
    osascript << EOF 2>/dev/null
tell application "Terminal"
    set newWindow to do script "cd '$(pwd)' && $command"
    set custom title of newWindow to "$title"
end tell
EOF
    
    # Record the title for later cleanup
    echo "$title" >> "$TERMINAL_IDS_FILE"
    success "✅ $description started (Title: $title)"
    sleep 2
}

# Start background processes (non-terminal)
log "🔧 Starting background MCP servers..."
npx -y @modelcontextprotocol/server-filesystem "$(pwd)" &
echo "$!" > ".mcp_filesystem.pid"

npx -y @playwright/mcp &  
echo "$!" > ".mcp_playwright.pid"

sleep 3

# Start all terminal-based components
start_terminal "SYSTEM-MONITOR" "python3 orchestrator.py" "System Monitor"
start_terminal "DEV-AGENT" "cd dev && ./dev.sh" "DEV Agent"
start_terminal "GUIDE-AGENT" "cd guide && ./guide.sh" "GUIDE Agent" 
start_terminal "COMM-MONITOR" "watch -n 2 'cat comm.json | jq .'" "Communication Monitor"

echo ""
log "📋 Started terminals:"
cat "$TERMINAL_IDS_FILE"

echo ""
success "🎉 System started with $(wc -l < "$TERMINAL_IDS_FILE") terminals tracked + DEV creates additional MCP terminal!"
log "🛑 Total: 6 terminals (ORCHESTRATOR + 5 system terminals)"
log "🛑 To stop: ./stop_system_terminal_tracking.sh"