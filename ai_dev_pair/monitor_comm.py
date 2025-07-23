#!/usr/bin/env python3
"""
Real-time Communication Monitor for Claude Multi-Agent System
Shows conversations in the unified comm.json file with live updates
"""
import json
import time
import os
from datetime import datetime
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class CommMonitor(FileSystemEventHandler):
    def __init__(self):
        self.comm_file = "comm.json"
        self.last_message_count = 0
        self.clear_screen()
        self.print_header()
        self.display_messages()
    
    def clear_screen(self):
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def print_header(self):
        print("=" * 80)
        print("🔥 CLAUDE MULTI-AGENT COMMUNICATION MONITOR")
        print("=" * 80)
        print(f"📁 Watching: {os.path.abspath(self.comm_file)}")
        print(f"🕐 Started: {datetime.now().strftime('%H:%M:%S')}")
        print("=" * 80)
        print()
    
    def on_modified(self, event):
        if event.src_path.endswith('comm.json'):
            self.display_messages()
    
    def display_messages(self):
        try:
            if not os.path.exists(self.comm_file):
                print("⚠️  comm.json not found!")
                return
            
            with open(self.comm_file, 'r') as f:
                data = json.load(f)
            
            messages = data.get('messages', [])
            
            # Only show new messages to avoid spam
            if len(messages) > self.last_message_count:
                new_messages = messages[self.last_message_count:]
                
                for msg in new_messages:
                    self.print_message(msg)
                
                self.last_message_count = len(messages)
            
        except Exception as e:
            print(f"❌ Error reading comm.json: {e}")
    
    def print_message(self, msg):
        timestamp = datetime.fromtimestamp(msg.get('ts', time.time())).strftime('%H:%M:%S')
        from_agent = msg.get('from', 'unknown')
        to_agent = msg.get('to', 'unknown')
        message_type = msg.get('message_type', 'unknown')
        ack = msg.get('ack', False)
        body = msg.get('body', '')
        
        # Color coding
        if message_type == 'user':
            color = '\033[94m'  # Blue for user messages
            icon = '👤'
        elif message_type == 'periodic':
            color = '\033[90m'  # Gray for periodic prompts
            icon = '🔄'
        elif from_agent in ['dev', 'guide']:
            color = '\033[92m'  # Green for agent responses
            icon = '🤖'
        else:
            color = '\033[0m'   # Default
            icon = '💬'
        
        reset = '\033[0m'
        ack_status = '✅' if ack else '⏳'
        
        print(f"{color}[{timestamp}] {icon} {from_agent.upper()} → {to_agent.upper()} {ack_status}{reset}")
        
        # Show abbreviated message for periodic, full for user messages
        if message_type == 'periodic':
            print(f"{color}    📝 [Periodic Check]{reset}")
        else:
            # Show first 100 chars of message
            preview = body[:100] + "..." if len(body) > 100 else body
            print(f"{color}    📝 {preview}{reset}")
        
        print()

def main():
    print("🚀 Starting Communication Monitor...")
    monitor = CommMonitor()
    
    # Set up file watcher
    observer = Observer()
    observer.schedule(monitor, path='.', recursive=False)
    observer.start()
    
    try:
        print("👀 Watching for communication changes... (Press Ctrl+C to stop)")
        print("🔴 LIVE UPDATES will appear below:")
        print("-" * 80)
        
        while True:
            time.sleep(1)
    
    except KeyboardInterrupt:
        observer.stop()
        print("\n👋 Communication Monitor stopped.")
    
    observer.join()

if __name__ == "__main__":
    main()