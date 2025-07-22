# System Architecture

## Overview
The Claude Multi-Agent Development System is a production-ready AI development team consisting of multiple specialized agents working collaboratively to deliver software projects.

## Core Components

### 1. ORCHESTRATOR (Primary Interface)
**File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/claude.md`
**Role**: User's personal project manager and system coordinator

#### Responsibilities:
- Translate user requests into technical tasks
- Coordinate communication between agents
- Start/stop system components
- Handle all technical complexity behind the scenes
- Provide user-friendly progress updates

#### Key Features:
- Automatic system startup and health monitoring
- Natural language interface for non-technical users
- System restart protocols with cleanup verification
- Task delegation to appropriate agents

### 2. DEV Agent (Implementation)
**Files**: 
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/dev/claude.md` (Configuration)
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/dev/mcp_config.json` (MCP Configuration)
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/dev/agent.py` (Runtime)

#### Responsibilities:
- Write and implement code following TEST-FIRST approach
- Create project-specific documentation (tasks.md, changelog.md)
- Perform comprehensive testing including Playwright E2E tests
- Manage git workflow with feature branches
- Consult GUIDE before all major decisions

#### Key Capabilities:
- **MCP Integration**: File system and Playwright browser automation
- **Project Management**: Task breakdown and progress tracking
- **Quality Assurance**: Evidence-based development with screenshots
- **Version Control**: Feature branches with clear commit messages

### 3. GUIDE Agent (Mentorship & Quality)
**Files**:
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/guide/claude.md` (Configuration)
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/guide/agent.py` (Runtime)

#### Responsibilities:
- Active code review and architectural guidance
- Maintain development playbook with lessons learned
- Manage communication archival (keep only last 7 exchanges)
- Enforce quality standards and testing requirements
- Monitor project files and provide real-time feedback

#### Key Features:
- **Development Playbook**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/development_playbook.md`
- **Communication Management**: Archive to `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/comm_archive.json`
- **Proactive Monitoring**: Every 2 minutes health checks
- **Quality Gates**: No feature approval without proper testing

### 4. Communication System
**Primary File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/comm.json`
**Archive File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/comm_archive.json`

#### Message Flow:
```
User → ORCHESTRATOR → DEV → GUIDE → DEV → ORCHESTRATOR → User
```

#### Communication Management:
- Maximum 14 messages (7 exchanges) in active comm.json
- Older messages archived automatically by GUIDE
- JSON format with acknowledgment tracking
- Real-time monitoring via orchestrator.py

### 5. System Monitoring
**File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/orchestrator.py`

#### Functions:
- Health monitoring of all agents
- Automatic agent restart on failure
- Communication flow tracking
- System status reporting

### 6. Project Management Files

#### Per-Project Files (Created in project folders):
- `tasks.md` - Task planning and status tracking
- `changelog.md` - Feature completion documentation

#### System-Level Files:
- `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/development_playbook.md` - Working patterns and insights

## Data Flow Architecture

### 1. Task Initiation
```
User Request → ORCHESTRATOR → send_message.py → comm.json → DEV
```

### 2. Approval Process
```
DEV → comm.json → GUIDE → Quality Review → Approval/Rejection → comm.json
```

### 3. Implementation Flow
```
GUIDE Approval → DEV Implementation → Project Files Update → Testing → Evidence Collection
```

### 4. Completion Flow
```
DEV Completion → GUIDE Review → User Communication → Playbook Update
```

## File System Structure

```
/ai_dev_pair/
├── docs/                          # System documentation
├── dev/                           # DEV agent files
│   ├── claude.md                  # DEV configuration
│   ├── mcp_config.json           # MCP server configuration
│   └── agent.py                  # DEV runtime
├── guide/                         # GUIDE agent files
│   ├── claude.md                  # GUIDE configuration
│   └── agent.py                  # GUIDE runtime
├── claude.md                      # ORCHESTRATOR configuration
├── comm.json                      # Active communications (max 14 messages)
├── comm_archive.json             # Archived communications
├── development_playbook.md        # Working patterns and insights
├── orchestrator.py               # System monitoring
├── send_message.py               # Communication utility
├── start_system.sh               # System startup
└── stop_system.sh                # System shutdown
```

## Technology Stack

### Core Technologies:
- **Claude AI**: All agents powered by Claude Sonnet
- **MCP (Model Context Protocol)**: Agent capabilities extension
- **Python**: System orchestration and monitoring
- **Bash**: System startup/shutdown automation
- **JSON**: Communication protocol and data storage

### Testing Framework:
- **Playwright**: End-to-end browser testing
- **Cross-browser**: Chrome, Firefox, Safari support
- **Mobile Testing**: Responsive design validation
- **Visual Regression**: Screenshot comparison

### Development Tools:
- **Git**: Version control with feature branch workflow
- **File System**: Direct project file manipulation
- **Terminal**: Command execution and output capture

## Scalability Considerations

### Communication Management:
- Automatic archival prevents comm.json bloat
- Structured message format for parsing
- Acknowledgment system ensures message delivery

### Performance Optimization:
- 2-minute polling intervals balance responsiveness and resource usage
- File-based communication reduces memory overhead
- Modular agent design allows independent scaling

### Quality Assurance:
- Evidence-based development with screenshots
- Automated testing pipeline with Playwright
- Continuous playbook updates for process improvement

## Security Considerations

### Access Control:
- Agents operate within designated project folders
- MCP configuration restricts file system access
- No direct system-level operations without approval

### Data Privacy:
- Communications archived locally (not transmitted)
- Project files remain in user's controlled environment
- No external API calls except to Claude AI service

### Quality Gates:
- GUIDE approval required for all user communications
- Code review mandatory before feature completion
- Testing requirements enforced before deployment