# Gaps & Recommendations - Frontend Development

This document expands on architectural UX and product design gaps that need to be addressed as the frontend evolves beyond MVP.

---

## ⚙️ Gap 1: Missing Mobile-Specific Interactions

### 📍 Current Coverage

✅ Responsive breakpoints defined (768px / 1280px)
✅ Floating FAB for filters

### ⚠️ What's Missing (UX Perspective)

| Interaction | User Value | Design Consideration |
|-------------|-----------|---------------------|
| **Pull-to-refresh** | Re-runs query or syncs new facts without leaving context | Add small bounce hint; show "Updated X facts" toast |
| **Swipe gestures** | Speed on touch; e.g. swipe left → save/comment, swipe right → open detail | Ensure accessible alternatives (buttons) |
| **Keyboard behavior** | On-focus: auto-scroll input into view; show OS suggestions; hide fixed footer | Use `inputmode` + `autocomplete` attributes |
| **Sticky search bar** | Persistent at top for new queries | Elevate with slight shadow when scrolling |
| **Compact card states** | Larger touch targets (min 44px) | Reflow metadata under title |
| **Haptic feedback** | Micro-confirmations (tap, save, error) | Via Web Vibration API where supported |

### 🧭 Recommendation → Phase 1.5: Mobile Polish Sprint

- Test real-world mobile query flow (keyboard in/out, scroll recovery)
- Add pull-to-refresh + swipe actions for 2–3 common gestures
- QA with Chrome DevTools + iOS Safari

---

## 🌐 Gap 2: No Offline / PWA Strategy

### 🎯 Why It Matters

If this becomes a research tool used on-site (field studies, labs, environmental inspections), network dropout kills momentum.

### 🚧 Current State

❌ Requires online Supabase + embedding API
❌ No caching, no manifest

### 💡 Phase 2: "Field-Ready" Mode

| Layer | Approach |
|-------|----------|
| **Service Worker** | Cache shell (app/layout + fonts + critical JS) |
| **IndexedDB / localStorage** | Cache last 50 search results + opened knowledge pages |
| **Sync Queue** | Pending annotations/comments upload when back online |
| **Manifest.json** | Installable shortcut, custom splash, dark/light icons |
| **Fallback UX** | Offline toast + cached content badge |

### 🧭 Decision Gate

**Ask:** Are 20%+ of users expected to work without constant connection?

- **If yes** → prioritize
- **Otherwise** → park until analytics confirm

---

## 👥 Gap 3: Collaboration Features Undefined

### 🧩 Currently

"Member (read, comment – Phase 2)" noted but no behavior spec.

### 💬 Questions to Answer

- Comment threading (1-level vs multi-level?)
- @mentions (internal only or external users?)
- Notifications (in-app, email, Slack?)
- Activity feed granularity (fact updated, CRAAP change, relation added?)

### 🧭 Recommendation: Phase 2A = Light Collaboration MVP

| Tier | Scope | UX Goal |
|------|-------|---------|
| **2A** | Inline comments on fact paragraphs | Contextual discussion |
| **2B** | Mentions + notifications | Lightweight awareness |
| **2C** | Activity feed | Audit + trust trail |

### Design Pattern

🗨️ **Comment bubble appears on text selection** → side drawer thread
Keep ephemeral; sync via Supabase Realtime

**Example Flow:**
1. User highlights text in knowledge detail
2. Comment bubble appears
3. Click → drawer opens with thread
4. @mention teammate
5. Notification sent (in-app + email)
6. Activity feed shows "User X commented on [fact]"

---

## 🔄 Gap 4: Data Export / API Access

### 📦 Currently

No explicit export or API endpoints.

### 💼 Use Cases

- Analyst exporting search results → CSV for reports
- Developer pulling facts → custom dashboards
- Automation → Slack / Notion updates when new validated fact added

### 🧭 Recommendation: Phase 2B: Data Access Layer

| Function | UX Surface | Tech Notes |
|----------|-----------|-----------|
| **Export to CSV** | Button on search results | Uses existing `/api/search`; streams rows |
| **Public API keys** | Settings → API Access | Supabase JWT scoped to user/team |
| **Webhooks** | Optional; Slack / Teams payload | Trigger on insert/update of facts |
| **Docs portal** | Auto-generated OpenAPI spec | Host via Swagger UI |

### Decision Criteria

- **If tool stays internal** → defer
- **If positioned as product** → plan early (retrofitting API auth later is painful)

---

## 🗓 Roadmap Integration

| Phase | Focus | Key Deliverables |
|-------|-------|-----------------|
| **1.0 (MVP)** | Core desktop UX + semantic search | Responsive shell, auth, search, detail |
| **1.5** | Mobile interaction layer | Pull-to-refresh, swipe, keyboard tuning |
| **2.0** | Collaboration & Offline (PWA core) | Comments + basic caching |
| **2.5** | API + Exports | CSV, API keys, docs |
| **3.0** | Advanced AI / Graph insights | Conversational layer, reasoning graph |

---

## 📊 Priority Matrix

| Gap | Impact | Effort | Priority | Phase |
|-----|--------|--------|----------|-------|
| Mobile interactions | High | Medium | 🔴 High | 1.5 |
| Offline/PWA | Medium | High | 🟡 Medium | 2.0 |
| Collaboration | High | High | 🟡 Medium | 2.0 |
| Export/API | Low | Medium | 🟢 Low | 2.5 |

---

## 🎯 Success Metrics by Gap

### Mobile Interactions
- Mobile search completion rate > 80%
- Touch target size 100% compliant (44px min)
- Pull-to-refresh usage > 15% of mobile sessions

### Offline/PWA
- Install rate (if PWA) > 30% of regular users
- Offline query success rate > 90% (cached results)
- Sync queue success rate > 95%

### Collaboration
- Comment engagement > 20% of detail views
- @mention response time < 4 hours median
- Activity feed DAU > 40% of team

### Export/API
- CSV export usage > 10% of search sessions
- API adoption > 5 integrations (if product)
- Webhook reliability > 99.5%

---

## 🧭 Next Steps

1. **Validate with users** - Which gaps matter most for your use case?
2. **Update roadmap** - Confirm phase priorities based on user needs
3. **Design collaboration patterns** - If prioritizing, spec threading/mentions
4. **Prototype mobile** - Test swipe gestures with real devices
5. **Research PWA** - If field use is confirmed, prototype offline mode

---

## 💡 Strategic Considerations

### When to Build Collaboration (Phase 2A)

**Build if:**
- ✅ 3+ team members actively using
- ✅ Users asking "How do I share this with X?"
- ✅ Knowledge quality depends on peer review

**Skip if:**
- ❌ Solo use case only
- ❌ Async Slack/email works fine
- ❌ No budget for real-time infrastructure

### When to Build Offline (Phase 2.0)

**Build if:**
- ✅ Field research confirmed
- ✅ Network reliability < 95% in target environments
- ✅ Users mention "wish I could access this offline"

**Skip if:**
- ❌ Office/wifi use only
- ❌ Always-connected workflows
- ❌ Real-time sync is critical

### When to Build API (Phase 2.5)

**Build if:**
- ✅ Positioning as platform/product
- ✅ 2+ integration requests
- ✅ Developer audience in GTM

**Skip if:**
- ❌ Internal tool only
- ❌ No extensibility needs
- ❌ Manual export sufficient
