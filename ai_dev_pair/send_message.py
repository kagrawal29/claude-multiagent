#!/usr/bin/env python3
"""
Send messages to DEV or GUIDE agents via comm.json
Usage: python3 send_message.py dev "Your message here"
       python3 send_message.py guide "Your message here"
"""
import json, uuid, time, sys

def send_message(to_agent, message):
    comm_file = "comm.json"
    
    # Read current data
    with open(comm_file, 'r') as f:
        data = json.load(f)
    
    # Add new message
    data["messages"].append({
        "id": str(uuid.uuid4()),
        "from": "user",
        "to": to_agent,
        "body": message,
        "ack": False,
        "ts": time.time()
    })
    
    # Write back
    with open(comm_file, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"✅ Sent message to {to_agent.upper()}: {message[:50]}...")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 send_message.py <dev|guide> <message>")
        sys.exit(1)
    
    to_agent = sys.argv[1].lower()
    message = sys.argv[2]
    
    if to_agent not in ["dev", "guide"]:
        print("Error: Agent must be 'dev' or 'guide'")
        sys.exit(1)
    
    send_message(to_agent, message)