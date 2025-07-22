# Claude Multi-Agent Development System

A powerful AI pair programming system featuring two specialized Claude agents (DEV and GUIDE) that collaborate to help you build software projects, coordinated by a main Claude assistant (ORCHESTRATOR).

## 🚀 Features

- **Three AI Roles**:
  - **ORCHESTRATOR**: Your main assistant that coordinates the agents and helps you use the system
  - **DEV**: A hands-on software engineer that implements features
  - **GUIDE**: A senior engineering mentor that provides architecture advice and code reviews
- **Intelligent Coordination**: The ORCHESTRATOR manages communication between you and the agents
- **Autonomous Operation**: Agents work independently and communicate via a shared message system
- **MCP-Enabled DEV**: DEV comes with Playwright for browser automation and enhanced file operations
- **Real-time Collaboration**: Watch agents discuss and solve problems together
- **Project Integration**: Works with any codebase - just clone your project into the workspace

## 📋 Prerequisites

- Claude CLI installed and authenticated (`pip install claude`)
- macOS (for MCP automation features)
- Python 3.7+
- Terminal with accessibility permissions (for autonomous mode)

## 🛠️ Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd claude_multiagent
```

2. Clone your project into the workspace:
```bash
cd ai_dev_pair
git clone <your-project-url> project
# Or create a new project folder
mkdir project && cd project
```

## 🎯 Quick Start

### Option 1: Using the ORCHESTRATOR Assistant (Recommended)

1. **Start your Claude session with the ORCHESTRATOR**:
```bash
cd ai_dev_pair
claude --append-system-prompt "$(cat claude.md)"
```

2. **In the Claude session, ask the ORCHESTRATOR to**:
   - Start the agents
   - Send tasks to DEV
   - Check system status
   - Monitor progress

Example:
```
You: "Please start the DEV and GUIDE agents and create a TODO app"
ORCHESTRATOR: "I'll start both agents and send the task to DEV..."
```

### Option 2: Manual Operation

1. **Start the System Monitor** (Terminal 1):
```bash
cd ai_dev_pair
python3 orchestrator.py
```

2. **Start DEV Agent** (Terminal 2):
```bash
cd ai_dev_pair/dev
./dev.sh
```

3. **Start GUIDE Agent** (Terminal 3):
```bash
cd ai_dev_pair/guide
./guide.sh
# Choose option 2 for autonomous mode
```

4. **Send a Task**:
```bash
cd ai_dev_pair
python3 send_message.py dev "Create a REST API for user authentication"
```


## 💬 How It Works

1. **Communication**: Agents communicate through `comm.json`, a shared message file
2. **Message Flow**: 
   - You send tasks to DEV
   - DEV asks GUIDE for advice when needed
   - GUIDE provides architecture guidance
   - DEV implements the solution
   - Both agents report progress back

3. **Agent Roles**:
   - **ORCHESTRATOR**: Your main interface - manages agents, sends tasks, monitors progress
   - **DEV**: Focuses on implementation, writes code, asks for guidance (with MCP/Playwright capabilities)
   - **GUIDE**: Reviews code, suggests improvements, provides best practices

## 📁 Project Structure

```
claude_multiagent/
├── README.md                 # This file
└── ai_dev_pair/
    ├── claude.md            # ORCHESTRATOR system prompt
    ├── orchestrator.py       # System monitor
    ├── send_message.py       # Send messages to agents
    ├── comm.json            # Shared communication file
    ├── dev/
    │   ├── agent.py         # DEV autonomous agent
    │   ├── claude.md        # DEV system prompt
    │   ├── dev.sh           # MCP-enabled DEV launcher
    │   └── mcp_config.json  # MCP configuration
    ├── guide/
    │   ├── agent.py         # GUIDE autonomous agent
    │   ├── claude.md        # GUIDE system prompt
    │   └── guide.sh         # GUIDE launcher
    └── project/             # Your project goes here

```

## 🎮 Common Commands

### Send a message to DEV:
```bash
python3 send_message.py dev "Your task here"
```

### Send a message to GUIDE:
```bash
python3 send_message.py guide "Your question here"
```

### Monitor system status:
```bash
python3 orchestrator.py
```

## 🧪 Example Tasks

### Basic Web App:
```bash
python3 send_message.py dev "Create a TODO list app with React. Ask GUIDE for architecture advice."
```

### API Development:
```bash
python3 send_message.py dev "Build a REST API for a blog system with user authentication. Consult GUIDE for best practices."
```

### Browser Automation (requires MCP):
```bash
python3 send_message.py dev "Use Playwright to scrape product prices from an e-commerce site"
```

## 🔧 Configuration

### Customizing Agent Behavior

Edit the system prompts to modify agent behavior:
- `claude.md` - Customize the ORCHESTRATOR's coordination style
- `dev/claude.md` - Customize DEV's personality and approach
- `guide/claude.md` - Customize GUIDE's mentoring style

### MCP Configuration

Edit `dev/mcp_config.json` to add or modify MCP servers:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"]
    }
  }
}
```

## 🚦 System Status

The orchestrator shows real-time status:
```
=== Claude Multi-Agent Orchestrator ===
Time     | From  | To    | Message Preview            | Ack
---------|-------|-------|---------------------------|-----
14:23:45 | user  | dev   | Create a TODO list app... | ✓
14:23:47 | dev   | guide | I need architecture adv... | ✓
14:23:50 | guide | dev   | Here's my recommended...  | ✓
```

## 📌 Tips

1. **Always start with the orchestrator** to monitor system health
2. **Be specific in your requests** - the more context, the better
3. **Let agents collaborate** - DEV will ask GUIDE when unsure
4. **Check comm.json** if you need to debug communication
5. **DEV has built-in MCP** for browser automation and enhanced file operations

## 🐛 Troubleshooting

### Agents not responding:
- Check if both agents are running in autonomous mode
- Verify `comm.json` exists and is readable
- Restart agents if needed

### Permission errors with MCP:
- Grant Terminal accessibility permissions in System Settings
- DEV automatically runs with `--dangerously-skip-permissions` flag

### Message not delivered:
- Check orchestrator for message status
- Ensure you're using correct agent name (dev or guide)

## 🤝 Contributing

Feel free to modify the agent prompts, add new agents, or enhance the communication system. The architecture is designed to be extensible.

## 📄 License

[Your License Here]

---

Built with ❤️ using Claude Code