#!/bin/bash
# MCP-enabled FULLY AUTONOMOUS GUIDE - Dynamic Prompt Loading

cd $(dirname "$0")

echo "=== MCP-ENABLED AUTONOMOUS GUIDE ==="
echo ""
echo "Features:"
echo "✓ Interactive Claude with MCP (Filesystem access)"
echo "✓ No permission prompts (--dangerously-skip-permissions)"
echo "✓ Auto-checks ../comm.json every 60 seconds"
echo "✓ Fully autonomous operation"
echo "✓ Proactive mentoring and code review"
echo "✓ Dynamic prompt loading from ../prompts/guide.md"
echo ""

# Generate unique window ID
WINDOW_ID="GUIDE-MCP-$$"

# Check if prompt file exists
PROMPT_FILE="../prompts/guide.md"
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
    set guideWindow to do script "cd '$(pwd)' && claude --dangerously-skip-permissions --add-dir /Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair --add-dir /Users/kshitiz/CascadeProjects/project --append-system-prompt \"\$(cat $PROMPT_FILE)\""
    set custom title of window 1 to "$WINDOW_ID"
end tell
EOF

echo "✓ Started autonomous GUIDE in terminal: $WINDOW_ID"
echo ""
echo "Waiting for Claude to initialize..."
sleep 5

echo "✓ Starting autonomous mentoring"
echo ""
echo "To stop: Press Ctrl+C"
echo ""

# Send initial check with proper GUIDE identity
osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "You are the GUIDE agent - senior engineering mentor. Check ../comm.json for messages addressed to 'guide'. Acknowledge each message by setting ack:true and respond as GUIDE. Be proactive: read project files, review DEV's work, suggest improvements. You have access to both the ai_dev_pair system and the project directory."
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF

echo "[$(date +%H:%M:%S)] Sent initial GUIDE check"

# Auto-check loop with proactive mentoring
while true; do
    sleep 60
    
    osascript << EOF
tell application "Terminal"
    repeat with w in windows
        if custom title of w is "$WINDOW_ID" then
            set frontmost of w to true
            delay 0.5
            
            tell application "System Events"
                keystroke "As GUIDE, check ../comm.json for new messages to 'guide' and respond. Also proactively: 1) Read project files to understand current work, 2) Review any code changes DEV made, 3) Suggest improvements or next steps, 4) Update development_playbook.md with insights. Be a helpful senior mentor, not just a monitor."
                delay 0.2
                keystroke return
            end tell
            
            exit repeat
        end if
    end repeat
end tell
EOF
    
    echo "[$(date +%H:%M:%S)] Sent GUIDE proactive check"
done