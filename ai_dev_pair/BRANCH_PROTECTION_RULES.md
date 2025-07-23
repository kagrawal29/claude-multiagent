# Branch Protection Rules for Claude Multi-Agent System

This document outlines the branch protection rules that should be configured on GitHub to maintain code quality and prevent accidental changes to protected branches.

## Protected Branches

### 1. `main` Branch (Production)
The main branch should be the most protected, only accepting merges from the development branch.

**GitHub Settings:**
1. Navigate to: Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Enable these protections:
   - ✅ **Require a pull request before merging**
     - ✅ Require approvals: 1
     - ✅ Dismiss stale pull request approvals when new commits are pushed
     - ✅ Require review from CODEOWNERS
   - ✅ **Require status checks to pass before merging**
     - ✅ Require branches to be up to date before merging
   - ✅ **Require conversation resolution before merging**
   - ✅ **Require signed commits** (optional but recommended)
   - ✅ **Require linear history** (prevents merge commits)
   - ✅ **Include administrators** (applies rules to admins too)
   - ✅ **Restrict who can push to matching branches**
     - Only allow merges through pull requests
   - ✅ **Restrict pushes that create matching branches**
   - ✅ **Require a pull request before merging**
     - Allowed merge methods: Only from `development` branch

### 2. `development` Branch (Staging)
The development branch collects all feature work before releasing to main.

**GitHub Settings:**
1. Navigate to: Settings → Branches → Add rule
2. Branch name pattern: `development`
3. Enable these protections:
   - ✅ **Require a pull request before merging**
     - ✅ Require approvals: 1
     - ✅ Dismiss stale pull request approvals when new commits are pushed
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require conversation resolution before merging**
   - ✅ **Include administrators**
   - ✅ **Restrict who can push to matching branches**
     - No direct pushes allowed
     - Only merge from feature branches

## Branch Flow

```
feature/* ──PR──> development ──PR──> main
sprint/*  ──PR──┘
project/* ──PR──┘
fix/*     ──PR──┘
```

## Enforcement in Code

These rules are also enforced in our system:
- `CLAUDE.md` prevents work on main/development branches
- Agents are instructed to use feature branches only
- Git workflow is monitored by GUIDE

## Setting Up Protection Rules

### Step-by-Step Guide:

1. **Access Branch Settings**
   ```
   https://github.com/kagrawal29/claude-multiagent/settings/branches
   ```

2. **For Main Branch:**
   - Click "Add rule"
   - Pattern: `main`
   - Check all boxes mentioned above
   - Under "Restrict who can push", add specific rule to only allow PRs from `development`
   - Save changes

3. **For Development Branch:**
   - Click "Add rule"  
   - Pattern: `development`
   - Check all boxes mentioned above
   - Save changes

4. **Verify Protection:**
   - Try to push directly to protected branches (should fail)
   - Create a test PR to verify rules work

## Additional Recommendations

### 1. **CODEOWNERS File**
Create `.github/CODEOWNERS` to automatically request reviews:
```
# Global owners
* @kagrawal29

# System files
/ai_dev_pair/claude.md @kagrawal29
/ai_dev_pair/guide/claude.md @kagrawal29
/ai_dev_pair/dev/claude.md @kagrawal29
```

### 2. **PR Templates**
Create `.github/pull_request_template.md` for consistent PRs:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] System improvement
- [ ] Documentation update

## Testing
- [ ] Changes tested locally
- [ ] No breaking changes

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Comments added where needed
```

### 3. **GitHub Actions**
Consider adding automated checks:
- Linting
- JSON validation for comm.json
- Python syntax checking
- Branch name validation

## Emergency Override

In case of emergency need to push directly:
1. Temporarily disable protection
2. Make critical fix
3. Re-enable protection immediately
4. Document the emergency change

## Monitoring

Regularly review:
- Failed push attempts to protected branches
- PR merge patterns
- Rule bypass events (if any)

---
*Last Updated: July 2025*
*Maintained by: ORCHESTRATOR*