import json, time, pathlib
from datetime import datetime

COMM = pathlib.Path("comm.json")

def log(msg):
    timestamp = datetime.now().strftime("%H:%M:%S")
    print(f"[{timestamp}] ORCHESTRATOR: {msg}")

def monitor():
    """Just monitor and report on comm.json changes - no automatic routing"""
    if not COMM.exists():
        log("comm.json not found, creating empty file...")
        COMM.write_text('{"messages": []}')
        return
    
    try:
        data = json.loads(COMM.read_text())
        total_messages = len(data.get("messages", []))
        unread = len([m for m in data.get("messages", []) if not m.get("ack", False)])
        
        log(f"Status: {total_messages} total messages, {unread} unread")
        
        # Show recent unread messages
        for m in data.get("messages", [])[-3:]:  # Last 3 messages
            status = "✓" if m.get("ack") else "•"
            log(f"  {status} {m.get('from', '?')} → {m.get('to', '?')}: {m.get('body', '')[:30]}...")
            
    except Exception as e:
        log(f"Error reading comm.json: {e}")

if __name__ == "__main__":
    log("Starting message monitor (no auto-routing)...")
    log("Press Ctrl+C to stop")
    
    while True:
        try:
            monitor()
        except KeyboardInterrupt:
            log("Shutting down...")
            break
        except Exception as e:
            log(f"Error: {e}")
        time.sleep(15)  # Check every 15 seconds