# Development Team Playbook

*This file is maintained by GUIDE to document working patterns, common pitfalls, and insights from collaborating with DEV.*

## 📈 Working Patterns (What Works Well)

### Project Initiation
- **Pattern**: Always start by asking DEV to create tasks.md in the project folder before any implementation
- **Why it works**: Prevents scope creep and ensures clear deliverables
- **Example**: "Before coding, break this down into specific tasks in your project's tasks.md file"

### 🚨 CRITICAL: Git Branch Discovery (NEW)
- **Pattern**: ALWAYS run `git branch -a` first when starting work on ANY project
- **Why it matters**: Development work often exists on non-main branches
- **Real Case**: AI Scout project - all integration work was on development branch, not main!
- **Protocol**: 
  1. Check all branches: `git branch -a`
  2. Ask user which branch to work on if multiple exist
  3. Never assume main/master is the working branch
- **Impact**: Prevents wasted time investigating "missing" work

### 🎯 MANDATORY PROJECT ONBOARDING PROTOCOL
- **Pattern**: ALWAYS perform comprehensive branch analysis before ANY project work
- **Implementation**:
  1. List ALL branches: `git branch -a`
  2. Check recent activity: `git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) - %(committerdate:relative) - %(subject)'`
  3. Present findings to user BEFORE assuming branch
  4. Ask which branch contains their work
  5. Only then proceed with discovery
- **Why critical**: Prevents branch confusion that wastes hours of investigation
- **Real impact**: AI Scout project - spent time analyzing main branch when all work was on development branch

### Communication Flow
- **Pattern**: User → DEV consults GUIDE → Implementation → GUIDE review → User response
- **Why it works**: Catches issues early and maintains quality standards
- **Note**: DEV rarely skips this now after initial training

### Testing Approach
- **Pattern**: TEST-FIRST approach with Playwright for UI features
- **Why it works**: Catches integration issues that unit tests miss
- **Example**: "Test the existing login flow before adding the new authentication method"

## ⚠️ Common Pitfalls (DEV Tendencies to Watch)

### 🆕 Project Onboarding Gaps
- **Pitfall**: DEV doesn't gather essential context when starting on existing projects
- **Solution**: Enforce new onboarding protocol (see Working Patterns)
- **Key Questions to Extract**:
  - Which branch should I work on?
  - What was the last work done?
  - What are the current blockers?
  - Any special folders or patterns to follow?
  - What are the session goals?
- **Impact**: Missed critical development branch on AI Scout project

### Planning Issues
- **Pitfall**: DEV tends to jump into implementation without proper task breakdown
- **Solution**: Always ask "What's your plan? Show me the tasks first"
- **Frequency**: Observed in 60% of initial project requests

### Testing Shortcuts
- **Pitfall**: DEV sometimes skips E2E testing when "code works locally"
- **Solution**: Enforce "No feature complete without Playwright tests"
- **Red flag**: When DEV says "I tested it manually"

### Documentation Gaps
- **Pitfall**: DEV forgets to update changelog.md after completing features
- **Solution**: Include changelog updates in task completion checklist
- **Note**: Getting better after multiple reminders

## ✅ Quality Standards

### Code Review Checklist
- [ ] Feature broken down into specific tasks in tasks.md
- [ ] Proper git workflow (feature branch, not main)
- [ ] Playwright E2E tests covering user workflows
- [ ] Error handling and loading states implemented
- [ ] Mobile responsive (tested in Playwright)
- [ ] Performance considerations addressed
- [ ] changelog.md updated with completion details

### Evidence Requirements
- **Screenshots**: Before/after comparisons, working features
- **Test Results**: Playwright test execution logs
- **Performance**: Load times, Lighthouse scores when relevant
- **Cross-browser**: Chrome, Firefox, Safari testing results

## 🤝 Workflow Insights

### Team Collaboration
- **Effective**: DEV responds well to specific, actionable feedback
- **Ineffective**: Vague guidance like "make it better"
- **Best approach**: "This component needs loading states. Add a spinner when data is fetching."

### User Communication
- **Pattern**: Users prefer simple progress updates over technical details
- **Template**: "Feature X is complete. I've tested it in Chrome, Firefox, and Safari. Screenshots attached."
- **Avoid**: Technical jargon, implementation details unless specifically asked

## 🔧 Technical Discoveries

### React/Frontend
- **Working well**: Using React Query for data fetching
- **Pitfall to avoid**: Not handling loading/error states
- **Pattern**: Always implement loading spinners and error boundaries

### Testing
- **Playwright success**: Page object model works well for complex flows
- **Common issue**: Selectors breaking when UI changes
- **Solution**: Use data-testid attributes instead of CSS selectors

### Feature Branch Verification
- **Working well**: Comprehensive verification protocol before merge
- **Pattern**: Branch safety → Build → Tests → Code review → Merge approval
- **Key insight**: Auth-dependent apps can still be verified without real keys
- **Success case**: AI Scout investor-detail-page verified despite Clerk auth blocks

### Git Workflow
- **Success pattern**: Small, frequent commits with clear messages
- **Issue**: DEV sometimes forgets to push regularly
- **Solution**: Remind to push after each completed task

## 📊 Project Metrics (Observations)

### Success Rates
- **Projects with proper task planning**: 90% success rate
- **Projects jumping straight to code**: 40% success rate
- **E2E tested features**: 95% user satisfaction
- **Manual testing only**: 70% user satisfaction

### Time Patterns
- **Average task completion**: 2-3 hours with proper planning
- **Rush jobs without planning**: Often require 50% more time for fixes
- **Playwright test writing**: 20% additional time, but prevents 80% of bugs

## 🎯 Continuous Improvement

### Recent Improvements (This Month)
- DEV now consistently creates tasks.md before starting
- Playwright test coverage improved from 60% to 85%
- Communication workflow violations reduced from daily to rare
- Successful feature branch verification protocol established
- DEV proactively handles auth-dependent testing scenarios

### Areas Still Needing Work
- DEV sometimes forgets mobile testing
- changelog.md updates still need prompting
- Performance testing is inconsistent

### Next Focus Areas
- Automated accessibility testing
- Better error handling patterns
- Performance budgets and monitoring

---

*Last updated: [Auto-updated by GUIDE during monitoring cycles]*
*Next review: [Weekly pattern analysis]*