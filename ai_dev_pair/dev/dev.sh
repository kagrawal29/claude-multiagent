#!/bin/bash
# MCP-enabled FULLY AUTONOMOUS DEV - Clean Version (No Terminal Logging)

cd $(dirname "$0")

echo "=== MCP-ENABLED AUTONOMOUS DEV (Clean) ==="
echo ""
echo "Features:"
echo "✓ Interactive Claude with MCP (Playwright + Filesystem)"
echo "✓ No permission prompts (--dangerously-skip-permissions)"
echo "✓ Auto-checks ../comm.json every 2 minutes"
echo "✓ Fully autonomous operation"
echo ""

# Generate unique window ID
WINDOW_ID="DEV-MCP-$$"

# Open interactive Claude with autonomous flags
osascript << EOF
tell application "Terminal"
    set devWindow to do script "cd '$(pwd)' && claude --mcp-config mcp_config.json --dangerously-skip-permissions --append-system-prompt \"\$(cat claude.md)\""
    set custom title of window 1 to "$WINDOW_ID"
end tell
EOF

echo "✓ Started autonomous DEV in terminal: $WINDOW_ID"
echo ""
echo "Waiting for Claude to initialize..."
sleep 5

echo "✓ Starting autonomous message checking"
echo ""
echo "To stop: Press Ctrl+C"
echo ""

# Send initial check
osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "Check ../comm.json for new messages and respond if needed"
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF

echo "[$(date +%H:%M:%S)] Sent initial check"

# Auto-check loop
while true; do
    sleep 120
    
    osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "Check ../comm.json for new messages and respond if needed"
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF
    
    echo "[$(date +%H:%M:%S)] Sent auto-check"
done