#!/bin/bash
cd $(dirname "$0")

echo "=== GUIDE AGENT ==="
echo "Starting in AUTONOMOUS mode..."
echo "GUIDE will check comm.json every 15 seconds and mentor DEV"
echo ""
python3 agent.py