#!/usr/bin/env python3
"""
Send messages to DEV or GUIDE agents via comm.json with file locking and validation
Usage: python3 send_message.py dev "Your message here"
       python3 send_message.py guide "Your message here"
"""
import json
import uuid
import time
import sys
import fcntl
import os
import tempfile
from datetime import datetime

def validate_json_structure(data):
    """Ensure comm.json has correct structure"""
    if not isinstance(data, dict):
        return False, "Root must be a dictionary"
    if 'messages' not in data:
        return False, "Missing 'messages' key"
    if not isinstance(data['messages'], list):
        return False, "'messages' must be a list"
    
    # Validate each message structure
    for i, msg in enumerate(data['messages']):
        if not isinstance(msg, dict):
            return False, f"Message {i} is not a dictionary"
        required_keys = {'id', 'from', 'to', 'body', 'ack', 'ts'}
        missing_keys = required_keys - set(msg.keys())
        if missing_keys:
            return False, f"Message {i} missing keys: {missing_keys}"
    
    return True, "Valid"

def signal_corruption_to_guide(error_details):
    """Create a signal file for GUIDE to handle JSON recovery"""
    signal_file = ".json_corrupted"
    recovery_info = {
        "timestamp": datetime.now().isoformat(),
        "error": str(error_details),
        "handler": "GUIDE",
        "action_needed": "Reset comm.json and recover from archive if possible"
    }
    
    try:
        with open(signal_file, 'w') as f:
            json.dump(recovery_info, f, indent=2)
        print(f"⚠️  JSON corruption detected. Signaled GUIDE for recovery.")
    except:
        print(f"❌ Critical: Could not create recovery signal!")

def atomic_json_write(filepath, data):
    """Write JSON atomically using temp file and rename"""
    # Validate structure before writing
    is_valid, error_msg = validate_json_structure(data)
    if not is_valid:
        raise ValueError(f"Invalid JSON structure: {error_msg}")
    
    # Create temp file in same directory for atomic rename
    dir_name = os.path.dirname(filepath) or '.'
    temp_fd, temp_path = tempfile.mkstemp(dir=dir_name, prefix='.tmp_comm_')
    
    try:
        # Write to temp file
        with os.fdopen(temp_fd, 'w') as f:
            json.dump(data, f, indent=2)
            f.write('\n')  # Add newline at end of file
        
        # Atomic rename (replaces original)
        os.replace(temp_path, filepath)
        return True
    except Exception as e:
        # Clean up temp file if something went wrong
        try:
            os.unlink(temp_path)
        except:
            pass
        raise e

def send_message_with_lock(to_agent, message):
    """Send message with file locking to prevent race conditions"""
    comm_file = "comm.json"
    lock_file = ".comm.lock"
    max_retries = 5
    retry_delay = 0.5
    
    for attempt in range(max_retries):
        try:
            # Use a separate lock file to avoid issues with JSON reading
            with open(lock_file, 'w') as lock_f:
                # Acquire exclusive lock
                fcntl.flock(lock_f.fileno(), fcntl.LOCK_EX)
                
                # Read current data
                try:
                    with open(comm_file, 'r') as f:
                        content = f.read()
                        if not content.strip():
                            # Empty file, initialize
                            data = {"messages": []}
                        else:
                            data = json.loads(content)
                except json.JSONDecodeError as e:
                    print(f"❌ JSON decode error: {e}")
                    signal_corruption_to_guide(e)
                    # Initialize with empty structure
                    data = {"messages": []}
                except FileNotFoundError:
                    # File doesn't exist, create it
                    data = {"messages": []}
                
                # Validate loaded data
                is_valid, error_msg = validate_json_structure(data)
                if not is_valid:
                    print(f"❌ Invalid JSON structure: {error_msg}")
                    signal_corruption_to_guide(error_msg)
                    # Reset to valid structure
                    data = {"messages": []}
                
                # Add new message
                new_message = {
                    "id": str(uuid.uuid4()),
                    "from": "user",
                    "to": to_agent,
                    "body": message,
                    "ack": False,
                    "ts": time.time()
                }
                data["messages"].append(new_message)
                
                # Write atomically
                atomic_json_write(comm_file, data)
                
                # Release lock (happens automatically when file closes)
                print(f"✅ Sent message to {to_agent.upper()}: {message[:50]}...")
                return True
                
        except BlockingIOError:
            # Lock is held by another process, retry
            if attempt < max_retries - 1:
                time.sleep(retry_delay)
                continue
            else:
                print(f"❌ Failed to acquire lock after {max_retries} attempts")
                return False
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            signal_corruption_to_guide(e)
            return False
    
    return False

def send_message(to_agent, message):
    """Legacy function that now uses the locked version"""
    return send_message_with_lock(to_agent, message)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 send_message.py <dev|guide> <message>")
        sys.exit(1)
    
    to_agent = sys.argv[1].lower()
    message = sys.argv[2]
    
    if to_agent not in ["dev", "guide"]:
        print("Error: Agent must be 'dev' or 'guide'")
        sys.exit(1)
    
    success = send_message(to_agent, message)
    if not success:
        sys.exit(1)