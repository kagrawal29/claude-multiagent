#!/bin/bash
# MCP-enabled FULLY AUTONOMOUS DEV - Dynamic Prompt Loading

cd $(dirname "$0")

echo "=== MCP-ENABLED AUTONOMOUS DEV ==="
echo ""
echo "Features:"
echo "✓ Interactive Claude with MCP (Playwright + Filesystem)"
echo "✓ No permission prompts (--dangerously-skip-permissions)"
echo "✓ Auto-checks ../comm.json every 2 minutes"
echo "✓ Fully autonomous operation"
echo "✓ Proper DEV identity in commands"
echo "✓ Dynamic prompt loading from ../prompts/dev.md"
echo ""

# Generate unique window ID
WINDOW_ID="DEV-MCP-$$"

# Check if prompt file exists
PROMPT_FILE="../prompts/dev.md"
if [ ! -f "$PROMPT_FILE" ]; then
    echo "ERROR: Prompt file not found at $PROMPT_FILE"
    echo "Falling back to claude.md"
    PROMPT_FILE="claude.md"
fi

echo "Loading prompt from: $PROMPT_FILE"
echo ""

# Open interactive Claude with autonomous flags
osascript << EOF
tell application "Terminal"
    set devWindow to do script "cd '$(pwd)' && claude --mcp-config mcp_config.json --dangerously-skip-permissions --append-system-prompt \"\$(cat $PROMPT_FILE)\""
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

# Send initial check with proper DEV identity
osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "You are the DEV agent. Check ../comm.json for messages addressed to 'dev'. Acknowledge each message by setting ack:true and respond as DEV following your system prompt instructions."
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF

echo "[$(date +%H:%M:%S)] Sent initial DEV check"

# Auto-check loop with proper identity
while true; do
    sleep 120
    
    osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "As the DEV agent, check ../comm.json for new messages to 'dev' and respond. Remember to acknowledge messages and provide test evidence for all work."
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF
    
    echo "[$(date +%H:%M:%S)] Sent DEV auto-check"
done