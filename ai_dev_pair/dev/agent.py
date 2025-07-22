#!/usr/bin/env python3
"""
Automated DEV agent wrapper that:
1. Watches comm.json for messages to 'dev'
2. Sends them to Claude CLI with the system prompt
3. Captures responses and writes them back to comm.json
"""
import json, time, uuid, subprocess, pathlib
from datetime import datetime

COMM = pathlib.Path("../comm.json")
SYSTEM_PROMPT = pathlib.Path("claude.md")
AGENT_NAME = "dev"

def log(msg):
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"[{timestamp}] DEV: {msg}")

def get_system_prompt():
    return SYSTEM_PROMPT.read_text().strip()

def get_unread_messages():
    """Get messages addressed to this agent that haven't been acknowledged"""
    if not COMM.exists():
        return []
    data = json.loads(COMM.read_text())
    unread = [m for m in data["messages"] 
              if m.get("to") == AGENT_NAME and not m.get("ack")]
    return unread

def send_response(original_msg_id, response_text):
    """Add a response message to comm.json"""
    if not COMM.exists():
        data = {"messages": []}
    else:
        data = json.loads(COMM.read_text())
    
    # Mark original message as acknowledged
    for m in data["messages"]:
        if m["id"] == original_msg_id:
            m["ack"] = True
            break
    
    # Add response
    target = "guide" if AGENT_NAME == "dev" else "dev"
    data["messages"].append({
        "id": str(uuid.uuid4()),
        "from": AGENT_NAME,
        "to": target,
        "body": response_text.strip(),
        "ack": False,
        "ts": time.time(),
        "reply_to": original_msg_id
    })
    
    COMM.write_text(json.dumps(data, indent=2))

def ask_claude(message_text):
    """Send message to Claude CLI and get response"""
    system_prompt = get_system_prompt()
    full_prompt = f"""
{system_prompt}

You are reading messages from comm.json. Here's a new message for you:

MESSAGE: {message_text}

Please respond as the DEV agent. Keep responses concise and focused.
"""
    
    try:
        result = subprocess.run([
            "claude", "--print", 
            "--dangerously-skip-permissions",
            "--add-dir", "/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair",
            "--append-system-prompt", system_prompt,
            full_prompt
        ], capture_output=True, text=True, timeout=120)
        
        if result.returncode == 0:
            return result.stdout.strip()
        else:
            return f"Error: Claude returned code {result.returncode}. stderr: {result.stderr}"
    except subprocess.TimeoutExpired:
        return "Error: Claude request timed out"
    except Exception as e:
        return f"Error calling Claude: {e}"

def main():
    log(f"Starting automated {AGENT_NAME.upper()} agent...")
    log(f"System prompt: {get_system_prompt()[:100]}...")
    
    while True:
        try:
            messages = get_unread_messages()
            
            for msg in messages:
                log(f"Processing message from {msg['from']}: {msg['body'][:50]}...")
                
                response = ask_claude(msg['body'])
                log(f"Claude response: {response[:100]}...")
                
                send_response(msg['id'], response)
                log(f"Sent response to comm.json")
                
        except Exception as e:
            log(f"Error: {e}")
        
        time.sleep(12)  # Check for new messages every 12 seconds

if __name__ == "__main__":
    main()