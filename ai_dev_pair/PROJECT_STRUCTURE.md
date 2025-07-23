# Project Structure & File Organization

## Complete File Structure

```
/claude_multiagent/                              # Multi-agent system root
├── ai_dev_pair/                                 # AI system directory
│   ├── docs/                                    # Technical documentation
│   │   ├── SYSTEM_ARCHITECTURE.md              # Complete technical overview
│   │   ├── COMMUNICATION_FLOW.md               # Message protocols and archival
│   │   ├── ROLES_AND_RESPONSIBILITIES.md       # Agent responsibilities
│   │   ├── CORE_PHILOSOPHY.md                  # Design principles
│   │   └── GIT_RULES_AND_BOUNDARIES.md         # Git workflow rules
│   │
│   ├── dev/                                     # DEV agent files
│   │   ├── claude.md                           # DEV agent configuration
│   │   ├── mcp_config.json                     # MCP server configuration
│   │   ├── agent.py                            # DEV runtime
│   │   └── dev.sh                              # DEV startup script
│   │
│   ├── guide/                                   # GUIDE agent files
│   │   ├── claude.md                           # GUIDE agent configuration
│   │   ├── agent.py                            # GUIDE runtime
│   │   └── guide.sh                            # GUIDE startup script
│   │
│   ├── README.md                                # User-friendly instructions
│   ├── CLAUDE.md                                # ORCHESTRATOR configuration
│   ├── comm.json                                # Active communications (max 14 messages)
│   ├── comm_archive.json                        # Archived communications
│   ├── development_playbook.md                  # Working patterns (GUIDE maintains)
│   ├── orchestrator.py                          # System health monitoring
│   ├── send_message.py                          # Communication utility
│   ├── start_system.sh                          # System startup
│   └── stop_system.sh                           # System shutdown
│
└── project/                                     # ACTIVE PROJECT DIRECTORY
    └── [User's current project files]           # Only ONE project at a time
```

## CRITICAL: Project Folder Rules

### Single Active Project
- **Location**: `/Users/kshitiz/CascadeProjects/claude_multiagent/project`
- **Rule**: Only ONE project can exist at a time in this folder
- **Purpose**: This is where DEV does all development work
- **Management**: ORCHESTRATOR checks this folder before cloning new projects

### Project Lifecycle
1. **New Project**: Check if folder is empty → Clone to `project` folder
2. **Existing Project**: Inform user that folder is occupied
3. **Switch Projects**: User must backup/remove current project first
4. **Clean State**: Folder should be completely empty before new clone

## File Location Rules

### System-Level Files (AI System Folder)
**Location**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/`

#### Configuration Files
- `claude.md` - ORCHESTRATOR configuration
- `dev/claude.md` - DEV agent configuration  
- `guide/claude.md` - GUIDE agent configuration
- `dev/mcp_config.json` - MCP server settings

#### Communication Files
- `comm.json` - Active messages (GUIDE keeps only last 7 exchanges)
- `comm_archive.json` - Historical messages (GUIDE manages)

#### Documentation Files
- `README.md` - User instructions
- `development_playbook.md` - Working patterns and insights (GUIDE maintains)
- `docs/` - Technical system documentation

#### System Scripts
- `orchestrator.py` - Health monitoring
- `send_message.py` - Message utility
- `start_system.sh` / `stop_system.sh` - System management

### Project-Specific Files (User Project Folders)
**Location**: Where the actual software is being built (NOT in AI system folder)

#### Required Project Files (DEV creates these)
- `tasks.md` - Task planning and status tracking
- `changelog.md` - Feature completion documentation

#### Implementation Files
- Source code files (`.js`, `.py`, `.html`, etc.)
- Configuration files (`package.json`, `requirements.txt`, etc.)
- Test files (Playwright tests, unit tests)
- Build outputs and assets

## File Creation Guidelines

### DEV Agent Must Create
```
PROJECT_FOLDER/
├── tasks.md              # Task breakdown and status
├── changelog.md          # Completed features log
├── src/                  # Source code
├── tests/                # Test files including Playwright
└── [other project files] # Based on project type
```

### GUIDE Agent Must Maintain
```
AI_SYSTEM_FOLDER/
├── development_playbook.md    # Working patterns and insights
├── comm_archive.json          # Communication archive
└── comm.json                  # Active communications (keep last 7 exchanges)
```

### ORCHESTRATOR Manages
```
AI_SYSTEM_FOLDER/
├── System startup/shutdown
├── Agent coordination
└── User communication
```

## Critical Rules

### ✅ DO
- **DEV**: Create `tasks.md` and `changelog.md` in the PROJECT folder
- **GUIDE**: Update `development_playbook.md` in the AI SYSTEM folder
- **GUIDE**: Archive old messages to `comm_archive.json` in AI SYSTEM folder
- **All agents**: Use exact file paths with full directory structure

### ❌ DON'T
- **Never** create `tasks.md` or `changelog.md` in the AI system folder
- **Never** let `comm.json` exceed 14 messages without archiving
- **Never** create project files in the AI system directory
- **Never** use relative paths without full directory context

## Path References for Agents

### DEV Agent Path Usage
```bash
# ✅ CORRECT - Project files go in project folder
./project_name/tasks.md
./project_name/changelog.md
./project_name/src/

# ❌ WRONG - Don't put project files in system folder
../tasks.md
../changelog.md
```

### GUIDE Agent Path Usage
```bash
# ✅ CORRECT - System files use ../ from guide/ directory
../comm.json
../comm_archive.json  
../development_playbook.md
../dev/claude.md

# ✅ CORRECT - Project files use full path to project
./user_project/tasks.md
./user_project/changelog.md
```

### Communication File Management
```bash
# Active communications (GUIDE maintains)
../comm.json                    # Max 14 messages (7 exchanges)

# Archive communications (GUIDE manages)
../comm_archive.json           # Historical messages with timestamps

# Development insights (GUIDE updates)
../development_playbook.md     # Patterns, pitfalls, learnings
```

## File Lifecycle

### New Project Initiation
1. **User** requests project via ORCHESTRATOR
2. **ORCHESTRATOR** sends task to DEV via `send_message.py`
3. **DEV** consults GUIDE about approach
4. **DEV** creates project folder structure including `tasks.md`
5. **DEV** begins implementation with regular GUIDE consultation

### During Development  
1. **DEV** updates `tasks.md` with progress (TODO → IN_PROGRESS → DONE)
2. **GUIDE** monitors project files and provides feedback
3. **DEV** commits changes including project management files
4. **GUIDE** updates `development_playbook.md` with insights

### Project Completion
1. **DEV** updates `changelog.md` with completed features
2. **GUIDE** reviews all deliverables and evidence
3. **GUIDE** approves user communication
4. **GUIDE** archives old communications if needed
5. **GUIDE** updates development playbook with project learnings

### Communication Management
1. **GUIDE** counts messages in `comm.json` every 2 minutes
2. **If >14 messages**: GUIDE extracts older messages
3. **GUIDE** appends old messages to `comm_archive.json` with timestamp
4. **GUIDE** updates `comm.json` with only recent messages (last 7 exchanges)

## Directory Creation Commands

### For System Setup
```bash
mkdir -p docs/
mkdir -p dev/
mkdir -p guide/
```

### For New Projects (DEV creates)
```bash
mkdir -p [project_name]
mkdir -p [project_name]/src
mkdir -p [project_name]/tests
touch [project_name]/tasks.md
touch [project_name]/changelog.md
```

This structure ensures all files go to their correct locations while maintaining clear separation between system management and project development files.