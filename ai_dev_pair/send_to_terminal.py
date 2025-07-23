#!/usr/bin/env python3
"""
Direct Terminal Message Sender
Sends messages directly to visible Claude Code terminals via AppleScript
"""
import subprocess
import sys
import time

def find_agent_windows():
    """Find terminal windows containing Claude agents"""
    try:
        # Get all terminal window names  
        result = subprocess.run([
            'osascript', '-e', 
            'tell application "Terminal" to return name of every window'
        ], capture_output=True, text=True, timeout=10)
        
        if result.returncode != 0:
            print(f"Error getting window names: {result.stderr}")
            return {}
        
        window_names = result.stdout.strip().split(', ')
        
        agent_windows = {}
        for name in window_names:
            # Clean up the name by removing quotes
            clean_name = name.strip('"{}')
            if 'DEV-MCP' in clean_name:
                agent_windows['dev'] = clean_name
            elif 'GUIDE-MCP' in clean_name:
                agent_windows['guide'] = clean_name
        
        return agent_windows
    
    except Exception as e:
        print(f"Error finding agent windows: {e}")
        return {}

def send_to_terminal_window(window_name, message):
    """Send message to a specific Terminal window"""
    try:
        # Escape the message for AppleScript - need to be more careful with escaping
        escaped_message = message.replace('\\', '\\\\').replace('"', '\\"').replace("'", "\\'")
        
        applescript = f'''
        tell application "Terminal"
            repeat with w in windows
                if name of w contains "{window_name}" then
                    activate
                    set index of w to 1
                    delay 0.3
                    tell application "System Events"
                        keystroke "{escaped_message}"
                        delay 0.2
                        key code 36
                    end tell
                    return true
                end if
            end repeat
            return false
        end tell
        '''
        
        result = subprocess.run([
            'osascript', '-e', applescript
        ], capture_output=True, text=True, timeout=10)
        
        if result.returncode == 0 and 'true' in result.stdout:
            print(f"✅ Message sent to {window_name}")
            return True
        else:
            print(f"❌ Failed to send to {window_name}: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Error sending to terminal: {e}")
        return False

def send_message_to_agent(agent, message):
    """Send message to specific agent's terminal"""
    print(f"🎯 Sending message to {agent.upper()}...")
    
    # Find agent windows
    windows = find_agent_windows()
    print(f"📋 Found windows: {windows}")
    
    if agent not in windows:
        print(f"❌ No terminal window found for {agent}")
        return False
    
    window_name = windows[agent]
    success = send_to_terminal_window(window_name, message)
    
    if success:
        print(f"✅ Message delivered to {agent.upper()} terminal!")
    else:
        print(f"❌ Failed to deliver message to {agent.upper()}")
    
    return success

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 send_to_terminal.py <dev|guide> <message>")
        sys.exit(1)
    
    agent = sys.argv[1].lower()
    message = sys.argv[2]
    
    if agent not in ["dev", "guide"]:
        print("Error: Agent must be 'dev' or 'guide'")
        sys.exit(1)
    
    success = send_message_to_agent(agent, message)
    sys.exit(0 if success else 1)