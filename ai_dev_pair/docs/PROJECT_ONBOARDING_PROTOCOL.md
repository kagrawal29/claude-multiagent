# Project Onboarding Protocol

## Overview

The Project Onboarding Protocol ensures our AI development team builds COMPLETE understanding of a project - its journey, current state, architecture, and all technical aspects. This discovery phase creates both high-level understanding for users and deep technical knowledge for informed decision-making.

## Core Purpose

**Discovery creates dual understanding:**
1. **Project Journey** - Where we are, where we're going, what's next
2. **Technical Mastery** - Complete system architecture, best practices, integration details

## Workflow Overview

```
Project Import → Discovery Phase → Team Collaboration → Comprehensive Understanding → Informed Action
                      ↓                    ↓                    ↓
             [Journey + Technical]  [DEV + GUIDE align]  [Both contexts clear]
```

## What We MUST Understand

### 1. The Journey (Project State)
- **Where we came from** - Project history and decisions made
- **Where we are now** - Current implementation state
- **Where we're going** - Planned features and goals
- **What's next** - Immediate priorities with context

### 2. System Architecture (Technical Deep Dive)
- **Frontend Architecture** - Framework, state management, UI patterns
- **Backend Architecture** - API design, database schema, services
- **Integration Layer** - How frontend/backend communicate
- **Infrastructure** - Deployment, CI/CD, monitoring
- **External Services** - Third-party APIs, authentication, payments

### 3. Critical Research Areas
- **Best Practices** - Current standards for the tech stack
- **Architecture Decisions** - Evaluate current choices, research alternatives
- **Security Considerations** - Vulnerabilities, authentication, data protection
- **Performance Optimization** - Bottlenecks, scaling considerations
- **Technology Updates** - Framework versions, migration needs

## Phase 1: Initial Project Discovery (DEV Leads)

### 1.1 Documentation Review
- [ ] Read README.md completely
- [ ] Check for docs/ folder and read all documentation
- [ ] Look for CONTRIBUTING.md or development guides
- [ ] Review any wikis or external documentation links
- [ ] Note any missing or outdated documentation

### 1.2 Project Structure Analysis
```bash
# Commands DEV should run:
find . -type f -name "*.md" | head -20  # Find all documentation
find . -name "package.json" -o -name "requirements.txt" -o -name "Gemfile" # Identify tech stack
tree -L 3 -I 'node_modules|__pycache__|.git'  # Understand structure
```

### 1.3 Git History Investigation
```bash
git log --oneline -30  # Recent commits
git log --since="2 weeks ago" --oneline  # Recent activity
git branch -a  # All branches
git tag  # Version history
```

### 1.4 Existing Task Analysis
- [ ] Check for tasks.md or TODO.md
- [ ] Look for GitHub/GitLab issues
- [ ] Search codebase for TODO/FIXME comments
- [ ] Review CHANGELOG.md for recent work

### 1.5 Technology Stack Discovery
- [ ] Identify primary language and framework
- [ ] List all major dependencies
- [ ] Note build tools and scripts
- [ ] Identify testing frameworks
- [ ] Check for CI/CD configuration

## Phase 2: Functional Testing & Understanding (DEV)

### 2.1 Get Project Running
```bash
# Based on project type, run appropriate commands:
npm install && npm start  # Node.js
pip install -r requirements.txt && python app.py  # Python
bundle install && rails server  # Ruby
```

### 2.2 Test Existing Features
- [ ] Run the application locally
- [ ] Test all major user flows
- [ ] Take screenshots of key features
- [ ] Note any broken functionality
- [ ] Check error handling and edge cases

### 2.3 Run Existing Tests
```bash
npm test  # or appropriate test command
npm run test:e2e  # E2E tests if available
```
- [ ] Note test coverage percentage
- [ ] Identify failing tests
- [ ] Understand testing patterns used

## Phase 3: Architecture & Code Review (GUIDE Leads)

### 3.1 Architecture Analysis
- [ ] Identify architectural patterns (MVC, microservices, etc.)
- [ ] Review folder structure and organization
- [ ] Understand data flow and state management
- [ ] Note API structure and endpoints
- [ ] Identify external service integrations

### 3.2 Code Quality Assessment
- [ ] Check code consistency and style
- [ ] Identify potential technical debt
- [ ] Note security concerns
- [ ] Review error handling patterns
- [ ] Assess performance considerations

### 3.3 Best Practices Research
- [ ] Research unfamiliar technologies using WebSearch
- [ ] Look up current best practices for the stack
- [ ] Check for deprecated dependencies
- [ ] Research security advisories
- [ ] Find similar successful projects for reference

## Phase 4: Context Documentation (Collaborative)

### 4.1 Create Dual Understanding Documents

#### A. project-context.md (Technical Deep Dive)
Both DEV and GUIDE collaborate to create comprehensive technical documentation:

#### B. project-summary.md (Layman's Understanding)
Create a non-technical summary that explains:
- What the project does in simple terms
- Who uses it and why
- Current status in plain language
- What we're building next and why it matters

### 4.2 Technical Context Template (project-context.md)

```markdown
# Project Context: [Project Name]

## 1. PROJECT JOURNEY

### Where We Came From
- **Original Vision**: [Initial goals and problem to solve]
- **Major Milestones**: [Key development phases completed]
- **Pivots/Changes**: [Significant direction changes and why]
- **Lessons Learned**: [What worked, what didn't]

### Where We Are Now
- **Current State**: [Exactly what's implemented and working]
- **Active Development**: [What's being worked on right now]
- **Blocked Items**: [What's waiting and why]
- **Technical Debt**: [Known issues we're living with]

### Where We're Going
- **Immediate Goals**: [Next 2-4 weeks]
- **Medium-term Vision**: [Next 2-3 months]
- **Long-term Strategy**: [6+ months]
- **Success Metrics**: [How we measure progress]

## 2. SYSTEM ARCHITECTURE

### Frontend Architecture
- **Framework**: [e.g., React 18, Next.js 14]
- **State Management**: [Redux, Context, Zustand, etc.]
- **UI Library**: [Material-UI, Tailwind, etc.]
- **Build System**: [Webpack, Vite, etc.]
- **Key Patterns**: [Component structure, data flow]

### Backend Architecture
- **Framework**: [Express, Django, Rails, etc.]
- **API Design**: [REST, GraphQL, RPC]
- **Database**: [PostgreSQL, MongoDB, etc.]
- **Authentication**: [JWT, OAuth, Sessions]
- **Key Services**: [List microservices or modules]

### Frontend-Backend Integration
- **API Communication**: [How they talk - REST endpoints, WebSocket, etc.]
- **Data Flow**: [Request/response patterns]
- **State Synchronization**: [How frontend stays updated]
- **Error Handling**: [How errors propagate]
- **Authentication Flow**: [How auth works end-to-end]

### Infrastructure & DevOps
- **Hosting**: [AWS, Vercel, Heroku, etc.]
- **CI/CD Pipeline**: [GitHub Actions, Jenkins, etc.]
- **Monitoring**: [Logs, metrics, alerts]
- **Environment**: [Dev, staging, production setup]

## 3. CRITICAL RESEARCH & DECISIONS

### Architecture Decisions Made
- **Decision**: [What was chosen]
  - **Why**: [Reasoning]
  - **Trade-offs**: [What we gave up]
  - **Alternatives Considered**: [Other options evaluated]

### Research Needed for Next Phase
- **Performance**: [Scaling considerations]
- **Security**: [Vulnerabilities to address]
- **Best Practices**: [Industry standards to adopt]
- **Technology Updates**: [Versions to upgrade]

### External Dependencies
- **Third-party APIs**: [Services we rely on]
- **Critical Libraries**: [Can't-live-without packages]
- **Service Integrations**: [Payment, email, analytics]

## 4. DEVELOPMENT INSIGHTS

### Code Organization
- **Frontend Structure**: [How components are organized]
- **Backend Structure**: [How APIs/services are organized]
- **Shared Code**: [Common utilities, types]
- **Configuration**: [How settings are managed]

### Testing Strategy
- **Unit Tests**: [Coverage and approach]
- **Integration Tests**: [API testing strategy]
- **E2E Tests**: [User flow validation]
- **Performance Tests**: [Load testing approach]

### Common Operations
- **Add New Feature**: [Step-by-step process]
- **Fix a Bug**: [Debugging workflow]
- **Deploy Changes**: [Release process]
- **Rollback**: [Recovery procedures]

## 5. TEAM KNOWLEDGE

### Key Concepts to Understand
- **Business Logic**: [Core domain concepts]
- **Technical Patterns**: [Unique approaches used]
- **Integration Points**: [Where systems connect]

### Known Gotchas
- **Common Pitfalls**: [Things that trip people up]
- **Non-obvious Behaviors**: [Surprising system quirks]
- **Performance Traps**: [What to avoid]

### Resources & Documentation
- **Internal Docs**: [Team documentation]
- **External References**: [Helpful articles, guides]
- **Similar Projects**: [Good examples to study]
```

## Phase 5: Agent Collaboration & Communication

### 5.1 Building Coherent Understanding
During discovery, DEV and GUIDE must actively communicate to build shared understanding:

#### Communication Pattern
```
DEV: "I found the frontend uses Next.js 14 with Tailwind. The API is REST-based."
GUIDE: "I see potential issues with the current REST design. Let me research GraphQL migration patterns."
DEV: "The authentication uses JWT with 24-hour expiry. Testing shows refresh token issues."
GUIDE: "That explains the user complaints. We should research OAuth 2.0 best practices."
```

#### Collaborative Research Division
- **DEV Focus**: Implementation details, testing current functionality, identifying bugs
- **GUIDE Focus**: Architecture evaluation, best practices research, security analysis
- **Shared**: Building comprehensive documentation, decision recommendations

### 5.2 Discovery Communication Rules
1. **Share findings immediately** - Don't wait until end
2. **Ask questions** - "GUIDE, what does this pattern mean?"
3. **Challenge assumptions** - "DEV, are you sure that's the only way?"
4. **Build on each other's insights** - Collaborative knowledge building
5. **Document disagreements** - Note different perspectives for user

## Phase 6: Web Research Integration

### 6.1 Technology Research (When Needed)
```python
# Example research tasks:
- "How does [unfamiliar framework] handle [specific pattern]?"
- "Best practices for [technology] in 2024"
- "Common pitfalls with [library] version [X]"
- "Migration guide from [old version] to [new version]"
```

### 5.2 Solution Research
- Research similar problems and solutions
- Find relevant Stack Overflow discussions
- Check GitHub issues for the dependencies
- Look for tutorial or guides for complex features

## Completion Checklist

### Before Starting ANY New Development:
- [ ] project-context.md exists and is comprehensive
- [ ] Both DEV and GUIDE have reviewed the full context
- [ ] All major technologies are understood
- [ ] Existing functionality has been tested
- [ ] Recent development history is clear
- [ ] Known issues are documented
- [ ] Web research completed for unknowns

## Time Expectations

- **Small Projects** (< 50 files): 1-2 hours
- **Medium Projects** (50-200 files): 2-4 hours  
- **Large Projects** (> 200 files): 4-6 hours
- **Complex/Legacy Projects**: 6-8 hours

## Deliverables

1. **project-context.md** - Comprehensive technical understanding:
   - Project journey (where we are, where we're going)
   - Complete system architecture (frontend, backend, integration)
   - Critical research and decisions needed
   - Next steps with full context

2. **Simple Summary for User** - Plain language explanation:
   - What we discovered about the project
   - Current state and what's next
   - Any important decisions needed

3. **Immediate Action Plan** - What to do RIGHT NOW:
   - Specific next task with context
   - What research is needed first
   - Expected challenges

## Integration with Existing Workflow

```
User: "Work on project X"
↓
ORCHESTRATOR: Checks for project-context.md
↓
If missing: Initiate Onboarding Protocol
If exists: Check if still current (< 1 week old)
↓
Send discovery tasks to DEV and GUIDE
↓
Monitor progress via comm.json
↓
Review completed context document
↓
Present findings to user
↓
Proceed with specific development tasks
```

## Common Pitfalls to Avoid

1. **Skipping discovery** to "save time" - Always backfires
2. **Shallow analysis** - Missing critical architectural decisions
3. **Ignoring git history** - Losing context of recent changes
4. **Not running the project** - Missing runtime issues
5. **Skipping web research** - Using outdated practices

## Success Metrics

- **Complete Understanding**: Both journey AND technical architecture clear
- **Coherent Team View**: DEV and GUIDE aligned on project state
- **Research-Backed Decisions**: Critical choices informed by best practices
- **Clear Next Steps**: Know exactly what to do next and why
- **No Surprises**: All major issues/blockers identified upfront

This protocol ensures our AI team never starts blind and always has the context needed for high-quality development work.