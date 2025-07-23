# Git Rules and Boundaries for Multi-Agent System

## CRITICAL: Two Separate Git Repositories

This system works with TWO completely separate git repositories:

### 1. **Multi-Agent System Repository**
- **Location**: The `ai_dev_pair` folder
- **Purpose**: Contains the multi-agent system infrastructure
- **Who can modify**: ONLY ORCHESTRATOR (when explicitly requested by user) and GUIDE (only development_playbook.md)
- **Contains**: Agent configurations, system scripts, documentation

### 2. **Project Repository** 
- **Location**: The `project` folder at the root of the multi-agent system
- **Purpose**: The actual development project being worked on
- **Who can modify**: DEV agent following proper git workflow
- **Contains**: Application code, project-specific files

## Agent-Specific Git Rules

### 🎯 ORCHESTRATOR Git Rules
- **CAN** make changes to multi-agent system repository ONLY when explicitly requested by user
- **CAN** run git commands in both repositories for status checking
- **CANNOT** make any changes to either repository without explicit user request
- **MUST** ask for user confirmation before any git operations that modify files

### 🛡️ GUIDE Git Rules  
- **CAN** update `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/development_playbook.md`
- **CAN** use git commands ONLY for:
  - `git add development_playbook.md`
  - `git commit -m "Update development playbook"`
  - `git push` (for playbook only)
- **CANNOT** run any git commands in the project directory
- **CANNOT** modify any other files in the multi-agent system
- **MUST** never touch the project repository with git commands

### 💻 DEV Git Rules
- **CAN** use all git commands but ONLY within `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/project/`
- **MUST** follow this workflow:
  1. Always work from `development` branch as base
  2. Create feature branches: `git checkout -b feature/description`
  3. Never commit directly to `main` or `development`
  4. Make atomic commits with clear messages
  5. Push feature branches regularly
  6. Create pull requests when ready
- **CANNOT** make any changes outside the project folder
- **CANNOT** touch the multi-agent system files
- **MUST** respect `.gitignore` and never commit sensitive files

## Enforcement Rules

### File System Boundaries
- **DEV**: Restricted to the `project` folder at the multi-agent root and its subdirectories
- **GUIDE**: Can only modify `development_playbook.md` in the multi-agent system
- **ORCHESTRATOR**: Can access all directories but only modifies when user explicitly requests

### Git Command Restrictions
```bash
# DEV Agent - Allowed commands (only in project directory)
git status
git checkout development
git checkout -b feature/name
git add .
git commit -m "message"
git push origin feature/name
git pull origin development
git log
git diff

# GUIDE Agent - Allowed commands (only for playbook)
git add development_playbook.md
git commit -m "Update development playbook"
git push

# ORCHESTRATOR - All commands allowed but only when user requests
```

## Common Scenarios

### Starting New Feature (DEV)
```bash
cd ../../project  # Navigate to project folder at root
git checkout development
git pull origin development
git checkout -b feature/api-integration
```

### Updating Playbook (GUIDE)
```bash
# After editing development_playbook.md
git add development_playbook.md
git commit -m "Update development playbook: Added API integration patterns"
git push
```

### System Updates (ORCHESTRATOR)
```bash
# Only when user says "update the system documentation"
# From within ai_dev_pair folder
git add docs/
git commit -m "Update system documentation"
git push
```

## Violations and Consequences

Any violation of these rules should result in:
1. Immediate stop of the operation
2. Alert to ORCHESTRATOR
3. Request for user guidance
4. Documentation in development_playbook.md

## Remember

- **Project work** = DEV's domain (with proper git workflow)
- **System maintenance** = ORCHESTRATOR's domain (only with user permission)
- **Knowledge documentation** = GUIDE's domain (only development_playbook.md)
- **Never cross boundaries** without explicit permission