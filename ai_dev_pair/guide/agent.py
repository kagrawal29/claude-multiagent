#!/usr/bin/env python3
"""
Automated GUIDE agent wrapper that:
1. Watches comm.json for messages to 'guide'
2. Sends them to Claude CLI with the system prompt
3. Captures responses and writes them back to comm.json
4. Can modify dev/claude.md to reprogram the DEV agent
"""
import json, time, uuid, subprocess, pathlib
from datetime import datetime

COMM = pathlib.Path("../comm.json")
SYSTEM_PROMPT = pathlib.Path("claude.md")
DEV_PROMPT = pathlib.Path("../dev/claude.md")
AGENT_NAME = "guide"

def log(msg):
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"[{timestamp}] GUIDE: {msg}")

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
    data["messages"].append({
        "id": str(uuid.uuid4()),
        "from": AGENT_NAME,
        "to": "dev",
        "body": response_text.strip(),
        "ack": False,
        "ts": time.time(),
        "reply_to": original_msg_id
    })
    
    COMM.write_text(json.dumps(data, indent=2))

def ask_claude(message_text):
    """Send message to Claude CLI and get response"""
    system_prompt = get_system_prompt()
    current_dev_prompt = DEV_PROMPT.read_text()
    
    full_prompt = f"""
{system_prompt}

CURRENT DEV AGENT PROMPT:
{current_dev_prompt}

You are reading messages from comm.json. Here's a message from the DEV agent:

MESSAGE: {message_text}

As the GUIDE agent, you can:
1. Provide feedback, corrections, or guidance
2. Modify the DEV agent's behavior by editing dev/claude.md
3. Give specific technical instructions

If you want to modify the DEV agent's prompt, start your response with:
MODIFY_DEV_PROMPT:
[new prompt content]
END_MODIFY

Otherwise, just provide your guidance response.
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
            response = result.stdout.strip()
            
            # Check if GUIDE wants to modify DEV's prompt
            if "MODIFY_DEV_PROMPT:" in response and "END_MODIFY" in response:
                start = response.find("MODIFY_DEV_PROMPT:") + len("MODIFY_DEV_PROMPT:")
                end = response.find("END_MODIFY")
                new_prompt = response[start:end].strip()
                
                DEV_PROMPT.write_text(new_prompt)
                log(f"Modified DEV agent prompt: {new_prompt[:50]}...")
                
                # Remove the modification command from the response
                response = response[:response.find("MODIFY_DEV_PROMPT:")].strip()
                if not response:
                    response = "I've updated your instructions. Please continue with the task."
            
            return response
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
        
        time.sleep(15)  # Check for new messages every 15 seconds

if __name__ == "__main__":
    main()