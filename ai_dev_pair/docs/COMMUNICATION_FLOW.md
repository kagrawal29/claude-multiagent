# Communication Flow Documentation

## Overview
The Claude Multi-Agent Development System uses a structured JSON-based communication protocol to coordinate between agents and maintain quality standards.

## Core Communication Files

### Primary Communication
- **File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/comm.json`
- **Purpose**: Active message exchange between agents
- **Limit**: Maximum 14 messages (7 exchanges) to prevent bloat
- **Management**: GUIDE automatically archives older messages

### Communication Archive
- **File**: `/Users/kshitiz/CascadeProjects/claude_multiagent/ai_dev_pair/comm_archive.json`
- **Purpose**: Historical message storage
- **Management**: Maintained by GUIDE during routine monitoring
- **Format**: Timestamped message blocks for tracking conversation history

## Message Structure

### Standard Message Format
```json
{
  "id": "unique-message-id",
  "from": "sender_agent",
  "to": "recipient_agent", 
  "body": "message content",
  "ack": boolean,
  "ts": timestamp,
  "reply_to": "optional-parent-message-id"
}
```

### Message Fields
- **id**: Unique identifier for message tracking
- **from**: Source agent (user, dev, guide, orchestrator)
- **to**: Target recipient 
- **body**: Message content (supports markdown formatting)
- **ack**: Acknowledgment status (true when read and processed)
- **ts**: Unix timestamp for chronological ordering
- **reply_to**: Optional field linking to parent message

## Communication Patterns

### 1. User Task Initiation
```mermaid
User → ORCHESTRATOR → send_message.py → comm.json → DEV
```

**Flow Details:**
1. User describes task to ORCHESTRATOR
2. ORCHESTRATOR uses `send_message.py dev "task description"`
3. Message written to comm.json with `from: "user"`, `to: "dev"`
4. DEV reads comm.json during 2-minute polling cycle
5. DEV acknowledges with `ack: true`

### 2. DEV-GUIDE Consultation (Mandatory)
```mermaid
DEV → comm.json → GUIDE → Review → Approval/Guidance → comm.json → DEV
```

**Flow Details:**
1. DEV receives user task, immediately messages GUIDE
2. DEV proposes approach: "GUIDE: User wants X, I plan Y. Should I proceed?"
3. GUIDE reviews proposal, project context, and current codebase
4. GUIDE responds with approval, modifications, or alternative approach
5. DEV waits for GUIDE response before implementation

### 3. Implementation Progress Flow
```mermaid
DEV Implementation → Progress Updates → comm.json → GUIDE Monitoring
```

**Progress Pattern:**
1. DEV starts implementation after GUIDE approval
2. Regular progress updates: "✅ Completed: X, 📁 Files: Y, 🧪 Tests: Z"
3. GUIDE monitors progress and provides live feedback
4. GUIDE reviews actual code changes in project files

### 4. Completion & User Response Flow
```mermaid
DEV Completion → GUIDE Review → Quality Gates → User Communication
```

**Quality Gate Process:**
1. DEV completes feature, reports to GUIDE with evidence
2. GUIDE reviews: code quality, test coverage, documentation
3. GUIDE checks: tasks.md updated, changelog.md documented
4. Only after GUIDE approval: DEV responds to user
5. GUIDE updates development playbook with insights

## Agent Communication Responsibilities

### ORCHESTRATOR
- **Initiates**: User task delegation
- **Manages**: send_message.py utility calls
- **Monitors**: Overall system health via orchestrator.py
- **Responds**: User status requests and progress updates

### DEV Agent
- **Reads**: comm.json every 2 minutes when idle
- **Acknowledges**: All messages with ack: true
- **Consults**: GUIDE before ANY implementation
- **Reports**: Progress updates and completion status
- **Never**: Responds directly to user without GUIDE approval

### GUIDE Agent  
- **Monitors**: comm.json, project files, and system health every 2 minutes
- **Reviews**: All DEV proposals and implementations
- **Approves/Rejects**: DEV communications to users
- **Archives**: Communications when >14 messages exist
- **Updates**: Development playbook with new insights
- **Manages**: Communication system scalability

## Communication Management

### Automatic Archival Process
**Trigger**: When comm.json exceeds 14 messages (7 exchanges)

**GUIDE Process:**
1. Read comm.json and count messages
2. If >14 messages: Extract oldest messages (keep newest 14)
3. Append archived messages to comm_archive.json with timestamp
4. Update comm.json with only recent conversations
5. Log archival action in next monitoring update

### Archive Format
```json
{
  "archived_sessions": [
    {
      "archive_timestamp": "2024-01-15T10:30:00Z",
      "session_start": "2024-01-15T09:00:00Z", 
      "session_end": "2024-01-15T10:30:00Z",
      "messages": [
        // Archived messages from this session
      ]
    }
  ]
}
```

## Monitoring & Health Checks

### GUIDE Monitoring Checklist (Every 2 minutes)
1. **Read comm.json** - Any new messages?
2. **Communication Management** - Message count >14? Archive if needed
3. **Project Monitoring** - Check tasks.md, changelog.md in project folders
4. **Code Review** - Review actual files DEV is working on
5. **Playbook Updates** - Any new patterns/pitfalls to document?
6. **Workflow Compliance** - Is DEV following proper protocol?
7. **System Health** - All agents responding appropriately?

### ORCHESTRATOR System Monitoring
- **Agent Health**: All agents responding to communication
- **Message Flow**: Communications flowing correctly
- **Response Times**: Agents responding within expected timeframes
- **Error Handling**: Failed messages and recovery attempts

## Error Handling & Recovery

### Communication Failures
- **Missing Acknowledgments**: ORCHESTRATOR detects unack'd messages
- **Agent Unresponsive**: orchestrator.py restarts failed agents
- **Corrupted Messages**: Message validation and error logging
- **Archive Failures**: GUIDE maintains backup communication logs

### Workflow Violations
- **DEV Skips GUIDE**: GUIDE immediately corrects and logs violation
- **Missing Evidence**: GUIDE blocks user communication until provided
- **Quality Issues**: GUIDE rejects completion until standards met

## Message Examples

### Task Initiation
```json
{
  "id": "task-001",
  "from": "user",
  "to": "dev", 
  "body": "Create a todo list app with React. Include add, delete, and mark complete functionality.",
  "ack": false,
  "ts": 1705123456.789
}
```

### DEV-GUIDE Consultation
```json
{
  "id": "dev-consult-001",
  "from": "dev",
  "to": "guide",
  "body": "GUIDE: User wants todo app with React. My plan:\n1. Create tasks.md with breakdown\n2. Set up React project\n3. Build components: TodoList, TodoItem, AddTodo\n4. Add local storage persistence\n5. Playwright E2E tests\n\nShould I proceed?",
  "ack": false,
  "ts": 1705123500.123
}
```

### GUIDE Approval
```json
{
  "id": "guide-approval-001",
  "from": "guide", 
  "to": "dev",
  "body": "APPROVED! Good plan. Suggestions:\n- Add loading states for better UX\n- Include error handling for localStorage\n- Test on mobile viewports\n- Consider using useReducer for state management\n\nProceed with implementation!",
  "ack": false,
  "ts": 1705123600.456,
  "reply_to": "dev-consult-001"
}
```

## Performance Considerations

### Polling Frequency
- **2-minute cycles**: Balance between responsiveness and resource usage
- **Event-driven**: Critical messages trigger immediate responses
- **Throttling**: Prevents system overload during high activity

### Message Retention
- **Active window**: Last 7 exchanges (14 messages) for quick access
- **Archive system**: Complete history maintained but not actively loaded
- **Performance**: Keeps comm.json size manageable for fast parsing

### Scalability
- **Archive rotation**: Prevents unlimited growth of communication files
- **Structured format**: Enables programmatic message processing
- **Modular design**: Individual agent scaling without system redesign