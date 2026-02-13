# Security Audit Report - Agent Zero Skills

**Date:** 2026-02-13 21:01:35 UTC

## Audit Summary

- **Total Skills Audited:** 19
- **Passed:** 18 ✅
- **Failed:** 1 ⚠️
- **Errors:** 0 ❌
- **Total Security Issues:** 8

---

## Audited Skills

### ✅ himalaya

- **Status:** PASS
- **Path:** `/a0/usr/skills/himalaya/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ⚠️ dokploy

- **Status:** FAIL
- **Path:** `/a0/usr/skills/dokploy/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**Security Issues (8):**

- 🔴 **Private IP** (Line 45)

  `- Server URL: `http://192.168.1.110:3000/``

- 🔴 **Private IP** (Line 52)

  `dokploy authenticate --url http://192.168.1.110:3000/ --token $DOKPLOY_API_KEY`

- 🔴 **Private IP** (Line 98)

  `curl -X GET 'http://192.168.1.110:3000/api/project.all' -H 'x-api-key: $DOKPLOY_`

- 🔴 **Private IP** (Line 104)

  `curl -X POST 'http://192.168.1.110:3000/api/application.create' \`

- 🔴 **Private IP** (Line 112)

  `curl -X POST 'http://192.168.1.110:3000/api/application.update' \`

- 🔴 **Private IP** (Line 125)

  `curl -X POST 'http://192.168.1.110:3000/api/application.saveBuildType' \`

- 🔴 **Private IP** (Line 136)

  `curl -X POST 'http://192.168.1.110:3000/api/application.deploy' \`

- 🔴 **Private IP** (Line 213)

  `2. Verify server URL is correct: `http://192.168.1.110:3000/``


### ✅ memory-optimizer

- **Status:** PASS
- **Path:** `/a0/usr/skills/memory-optimizer/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ maxun

- **Status:** PASS
- **Path:** `/a0/usr/skills/maxun/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ opencode

- **Status:** PASS
- **Path:** `/a0/usr/skills/opencode/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ create-skill

- **Status:** PASS
- **Path:** `/a0/usr/skills/create-skill/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-components

- **Status:** PASS
- **Path:** `/a0/usr/skills/patterns/sveltekit-components/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ sveltekit-performance

- **Status:** PASS
- **Path:** `/a0/usr/skills/patterns/sveltekit-performance/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ sveltekit-forms

- **Status:** PASS
- **Path:** `/a0/usr/skills/patterns/sveltekit-forms/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-server-actions

- **Status:** PASS
- **Path:** `/a0/usr/skills/patterns/sveltekit-server-actions/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ dashboard-creation-workflow

- **Status:** PASS
- **Path:** `/a0/usr/skills/workflows/dashboard-creation-workflow/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ skeleton-ui-svelte

- **Status:** PASS
- **Path:** `/a0/usr/skills/core/skeleton-ui-svelte/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-bootstrap

- **Status:** PASS
- **Path:** `/a0/usr/skills/core/sveltekit-bootstrap/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ better-auth-svelte

- **Status:** PASS
- **Path:** `/a0/usr/skills/core/better-auth-svelte/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ stripe-integration

- **Status:** PASS
- **Path:** `/a0/usr/skills/features/stripe-integration/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

### ✅ sveltekit-analytics

- **Status:** PASS
- **Path:** `/a0/usr/skills/features/sveltekit-analytics/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-theming

- **Status:** PASS
- **Path:** `/a0/usr/skills/features/sveltekit-theming/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-dnd-dashboard

- **Status:** PASS
- **Path:** `/a0/usr/skills/features/sveltekit-dnd-dashboard/SKILL.md`
- **Environment Variables:** ⚠️ Not used

**No security issues found.**

### ✅ sveltekit-database

- **Status:** PASS
- **Path:** `/a0/usr/skills/features/sveltekit-database/SKILL.md`
- **Environment Variables:** ✅ Used

**No security issues found.**

