#!/bin/bash
# Robust system utilities for process management

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log with color
log() {
    echo -e "${BLUE}[SYSTEM]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Comprehensive process discovery
find_system_processes() {
    log "🔍 Discovering all system processes..."
    
    # Create temporary file for PIDs
    local pids_file="/tmp/multiagent_pids.txt"
    : > "$pids_file"
    
    # Our system processes patterns
    local patterns=(
        "orchestrator.py"
        "comm_monitor.py" 
        "agent.py"
        "claude.*mcp-config"
        "claude.*dev/claude.md"
        "claude.*guide/claude.md"
        "mcp-server-filesystem"
        "mcp-server-playwright"
        "@playwright/mcp"
        "@executeautomation/playwright-mcp-server"
        "playwright-mcp-server"
        "dev_auto.sh"
        "npm.*@playwright/mcp"
        "npm.*mcp-server"
        "npm.*playwright.*mcp"
        "watch.*comm.json"
        "Chrome.*mcp-chrome-profile"
        "chrome.*playwright"
        "node.*mcp.*server"
    )
    
    # Find processes matching our patterns
    for pattern in "${patterns[@]}"; do
        pids=$(pgrep -f "$pattern" 2>/dev/null)
        if [ ! -z "$pids" ]; then
            echo "Found: $pattern -> PIDs: $pids"
            echo "$pids" | tr ' ' '\n' >> "$pids_file"
        fi
    done
    
    # Also check for processes in our directory
    local our_dir="/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair"
    pids=$(ps aux | grep "$our_dir" | grep -v grep | awk '{print $2}')
    if [ ! -z "$pids" ]; then
        echo "Found directory processes: $pids"
        echo "$pids" | tr ' ' '\n' >> "$pids_file"
    fi
    
    # Return unique PIDs
    if [ -f "$pids_file" ]; then
        sort "$pids_file" | uniq
        rm -f "$pids_file"
    fi
}

# Kill processes with escalating force
kill_processes_robust() {
    local pids="$1"
    local process_name="${2:-processes}"
    
    if [ -z "$pids" ]; then
        return 0
    fi
    
    log "🛑 Stopping $process_name..."
    
    # Convert to array
    local pid_array=($pids)
    local remaining_pids=()
    
    # Phase 1: TERM signal
    for pid in "${pid_array[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "  Sending TERM to PID $pid"
            kill -TERM "$pid" 2>/dev/null
            remaining_pids+=("$pid")
        fi
    done
    
    if [ ${#remaining_pids[@]} -gt 0 ]; then
        log "⏳ Waiting 3 seconds for graceful shutdown..."
        sleep 3
        
        # Phase 2: Check who's still alive
        local stubborn_pids=()
        for pid in "${remaining_pids[@]}"; do
            if kill -0 "$pid" 2>/dev/null; then
                stubborn_pids+=("$pid")
            fi
        done
        
        # Phase 3: KILL signal for stubborn processes
        if [ ${#stubborn_pids[@]} -gt 0 ]; then
            warn "💥 Force killing stubborn processes..."
            for pid in "${stubborn_pids[@]}"; do
                echo "  Force killing PID $pid"
                kill -9 "$pid" 2>/dev/null
            done
            sleep 1
        fi
        
        # Phase 4: Final verification
        local survivors=()
        for pid in "${pid_array[@]}"; do
            if kill -0 "$pid" 2>/dev/null; then
                survivors+=("$pid")
            fi
        done
        
        if [ ${#survivors[@]} -gt 0 ]; then
            error "❌ Failed to kill: ${survivors[*]}"
            return 1
        fi
    fi
    
    success "✅ $process_name stopped successfully"
    return 0
}

# Verify clean state
verify_clean_state() {
    log "🔍 Verifying clean state..."
    
    local remaining=$(find_system_processes)
    if [ -z "$remaining" ]; then
        success "✅ System is clean - no processes remaining"
        return 0
    else
        error "❌ Remaining processes detected:"
        echo "$remaining" | while read pid; do
            if [ ! -z "$pid" ] && kill -0 "$pid" 2>/dev/null; then
                ps -p "$pid" -o pid,ppid,command | tail -n 1
            fi
        done
        return 1
    fi
}

# Nuclear option - kill everything related to our project
nuclear_cleanup() {
    error "🚨 NUCLEAR CLEANUP - Killing everything related to our system..."
    
    # Kill by patterns with extreme prejudice
    pkill -9 -f "orchestrator.py"
    pkill -9 -f "claude.*mcp-config"  
    pkill -9 -f "mcp-server"
    pkill -9 -f "playwright.*mcp"
    pkill -9 -f "mcp.*server"
    pkill -9 -f "dev/claude.md"
    pkill -9 -f "guide/claude.md"
    
    # Kill Chrome processes related to MCP
    pkill -9 -f "Chrome.*mcp-chrome-profile"
    pkill -9 -f "chrome.*playwright"
    
    # Kill any processes in our directory
    local our_dir="/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair"
    ps aux | grep "$our_dir" | grep -v grep | awk '{print $2}' | xargs -r kill -9
    
    sleep 2
    
    if verify_clean_state; then
        success "🎯 Nuclear cleanup successful!"
    else
        error "💀 Even nuclear cleanup failed - manual intervention required"
    fi
}

# Export functions for use in other scripts
export -f find_system_processes
export -f kill_processes_robust  
export -f verify_clean_state
export -f nuclear_cleanup
export -f log warn success error