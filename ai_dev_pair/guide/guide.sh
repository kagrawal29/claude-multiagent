#!/bin/bash
cd $(dirname "$0")

echo "=== GUIDE AGENT LAUNCHER ==="
echo "Choose mode:"
echo "1) Interactive - Chat directly + manual comm.json access + reprogram DEV"
echo "2) Autonomous - Runs automatically, checks comm.json every 15s"
echo ""
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "Starting INTERACTIVE mode..."
        ./interactive.sh
        ;;
    2)
        echo "Starting AUTONOMOUS mode..."
        python3 agent.py
        ;;
    *)
        echo "Invalid choice. Starting interactive mode by default..."
        ./interactive.sh
        ;;
esac