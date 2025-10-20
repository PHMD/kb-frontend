# Frontend Development Roadmap - Knowledge Base

**Project:** KB Team Interface
**Stack:** Next.js 14+ (App Router), TypeScript, Tailwind CSS, shadcn/ui, Supabase, Neo4j Aura
**Timeline:** 8 weeks to Phase 2.0 (fully-featured team product)

---

## 🎯 North Star Vision

**"A calm, credible, AI-enhanced research copilot that helps teams find, trust, and connect validated knowledge."**

**Success Criteria:**
- Team can search 275+ knowledge nodes semantically
- Confidence scores visible at every touchpoint
- Graph relationships show knowledge connections
- Sub-400ms search latency (p75)
- WCAG AA accessible

---

## 📅 Phase-by-Phase Roadmap

### **Phase 1.0: Core MVP** (Weeks 1-3)

**Goal:** Ship functional search + detail interface for owner-only use

**Deliverables:**

**Week 1: Foundation**
- [x] Next.js project scaffolded
- [x] Supabase project created + pgvector enabled
- [x] Design system implemented (globals.css + Tailwind config)
- [x] Auth working (email/password)
- [x] Deployed skeleton to Vercel
- [x] Coming soon page live

**Week 2: Search**
- [ ] Markdown → Supabase migration script
- [ ] OpenAI embeddings generation
- [ ] `/api/search` endpoint (pgvector similarity)
- [ ] Search page UI (SearchBar + FilterPanel + ResultList)
- [ ] Filters working (project, type, confidence slider)
- [ ] Empty/loading/error states

**Week 3: Detail + Polish**
- [ ] Knowledge detail page (`/knowledge/[id]`)
- [ ] Markdown rendering with syntax highlighting
- [ ] CRAAP score accordion
- [ ] Relations panel (depends_on, supports, blocks, conflicts_with)
- [ ] Keyboard shortcuts (cmd+k, ↑/↓, Enter)
- [ ] Basic telemetry (search_submitted, result_opened)
- [ ] Dark mode working

**Exit Criteria:**
- ✅ Owner can search all 275 facts semantically
- ✅ Search latency < 400ms p75
- ✅ Keyboard-only flow works end-to-end
- ✅ WCAG AA color contrast verified
- ✅ Deployed to production Vercel

---

### **Phase 1.5: Mobile Polish** (Week 4)

**Goal:** Optimize mobile experience for on-the-go research

**Deliverables:**

- [ ] Pull-to-refresh on search results
- [ ] Swipe actions on result cards (left: save, right: open)
- [ ] Mobile keyboard behavior (inputmode, autocomplete)
- [ ] Sticky search bar on scroll
- [ ] Touch targets 44px+ minimum
- [ ] Haptic feedback (Web Vibration API)
- [ ] Responsive testing (iOS Safari, Chrome Android)

**Exit Criteria:**
- ✅ Mobile search completion rate > 80%
- ✅ Touch target compliance 100%
- ✅ No layout shift (CLS < 0.1) on mobile

---

### **Phase 2.0: Team Collaboration** (Weeks 5-6)

**Goal:** Enable team access with inline comments + activity awareness

**Deliverables:**

**Team Access:**
- [ ] Member role (read + comment permissions)
- [ ] Team invite system (email invites)
- [ ] Row Level Security policies (Supabase RLS)
- [ ] Settings page (profile, team members, API keys)

**Collaboration:**
- [ ] Inline comments on fact paragraphs
- [ ] Comment threading (1-level)
- [ ] @mentions (internal team only)
- [ ] In-app notifications
- [ ] Activity feed (fact updates, comments)
- [ ] Realtime sync (Supabase Realtime subscriptions)

**Exit Criteria:**
- ✅ 3+ team members can access simultaneously
- ✅ Comments appear in real-time (<2s latency)
- ✅ @mention notifications delivered
- ✅ Activity feed shows last 30 days

---

### **Phase 2.5: Data Access Layer** (Week 7)

**Goal:** Enable export + API for power users and integrations

**Deliverables:**

- [ ] Export to CSV (search results)
- [ ] API key generation (Settings → API Access)
- [ ] Public API endpoints (`/api/v1/search`, `/api/v1/facts/:id`)
- [ ] API documentation (OpenAPI spec + Swagger UI)
- [ ] Webhooks (optional: Slack, Teams, Notion)
- [ ] Rate limiting (100 req/min per user)

**Exit Criteria:**
- ✅ CSV export works for 5K+ results
- ✅ API documented + tested
- ✅ Rate limiting functional

---

### **Phase 3.0: Advanced AI & Graph** (Week 8+)

**Goal:** Ship conversational AI + graph visualization for power users

**Deliverables:**

**Graph View:**
- [ ] Neo4j Aura integration
- [ ] `/graph` page with react-force-graph
- [ ] Node coloring by type + confidence
- [ ] Edge labels (relationship types)
- [ ] Click to focus + detail panel
- [ ] Search within graph
- [ ] Filters (type, confidence, depth)

**AI Enhancements:**
- [ ] Conversational layer (floating "Ask" composer)
- [ ] AI summarization (top of detail page)
- [ ] Query reformulation hints
- [ ] "Compare selected" multi-select feature
- [ ] AI helpfulness rating (thumbs up/down)
- [ ] Feedback loop (stores in ai_interactions table)

**Exit Criteria:**
- ✅ Graph renders 2K nodes smoothly
- ✅ AI responses cite sources
- ✅ Conversational context works (remembers last 3 queries)

---

## 📊 Milestones & Timeline

| Milestone | Date | Deliverable |
|-----------|------|-------------|
| **M1: Skeleton Live** | End Week 1 | Vercel deployment + auth working |
| **M2: MVP Shipped** | End Week 3 | Search + detail functional |
| **M3: Mobile Ready** | End Week 4 | Mobile UX polished |
| **M4: Team Launch** | End Week 6 | Collaboration features live |
| **M5: Platform Ready** | End Week 7 | API + export working |
| **M6: Full Vision** | End Week 8 | Graph + AI conversational |

---

## 🎯 Success Metrics by Phase

### Phase 1.0 (MVP)
- [ ] Search → open detail conversion > 50%
- [ ] Avg time to first insight < 10s
- [ ] Session depth ≥ 3 views per session
- [ ] User trust survey > 70% "confident in results"

### Phase 1.5 (Mobile)
- [ ] Mobile search completion > 80%
- [ ] Pull-to-refresh usage > 15% of mobile sessions
- [ ] Touch target compliance 100%

### Phase 2.0 (Collaboration)
- [ ] Comment engagement > 20% of detail views
- [ ] @mention response time < 4 hours median
- [ ] Activity feed DAU > 40% of team

### Phase 2.5 (API)
- [ ] CSV export usage > 10% of search sessions
- [ ] API adoption > 5 integrations (if product)

### Phase 3.0 (AI + Graph)
- [ ] AI helpfulness rating > 4/5
- [ ] Graph view engagement > 30% of power users
- [ ] Conversational queries > 20% of total searches

---

## 🚧 Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Supabase free tier limits** | High | Medium | Monitor usage; upgrade to Pro ($25/mo) if needed |
| **Neo4j Aura cost** | Medium | Low | Use free tier (50K nodes); defer graph to Phase 3 if budget constrained |
| **OpenAI embedding costs** | Medium | Low | ~$0.02 for 275 nodes; batch process; cache embeddings |
| **Search latency > 400ms** | High | Medium | Index optimization; server-side caching; consider Upstash Redis |
| **Mobile keyboard bugs** | Medium | Medium | Test on real devices early; use inputmode attributes |
| **Real-time sync flakiness** | Medium | Low | Supabase Realtime is beta; add polling fallback |

---

## 🔄 Dependencies & Blockers

### External Dependencies
- **Supabase**: Postgres + pgvector + Auth + Realtime
- **OpenAI**: Embeddings API (text-embedding-3-small)
- **Neo4j Aura**: Graph database (Phase 3)
- **Vercel**: Hosting + serverless functions

### Internal Dependencies
- **Data validation track** (parallel work): Clean data → Supabase migration
- **Design assets**: Logos, favicons, OG images (Week 1)

### Potential Blockers
- [ ] Supabase pgvector performance with 275+ nodes (test early)
- [ ] CRAAP score calculation on frontend vs backend (decide Week 1)
- [ ] Graph rendering performance (test with 500+ nodes before Phase 3)

---

## 💰 Cost Estimate (Monthly)

| Service | Tier | Cost |
|---------|------|------|
| **Vercel** | Hobby | $0 (sufficient for MVP) |
| **Supabase** | Free | $0 (500MB DB, 50K MAU) |
| **Neo4j Aura** | Free | $0 (50K nodes, 175K rels) |
| **OpenAI** | Pay-as-you-go | ~$0.02 (one-time embeddings) |
| **Total (MVP)** | | **$0/month** |

**If scaling:**
- Vercel Pro: $20/mo (better performance)
- Supabase Pro: $25/mo (8GB DB, better limits)
- Neo4j Aura Pro: $65/mo (unlimited nodes)
- **Total (Production):** ~$110/month

---

## 🎨 Design & UX Priorities

### Must Have (Phase 1.0)
- ✅ WCAG AA color contrast
- ✅ Keyboard shortcuts working
- ✅ Focus states visible
- ✅ Empty/error states designed
- ✅ Loading skeletons

### Should Have (Phase 1.5-2.0)
- ⚠️ Mobile swipe gestures
- ⚠️ Pull-to-refresh
- ⚠️ Haptic feedback
- ⚠️ Comment threading UI
- ⚠️ Activity feed design

### Could Have (Phase 2.5+)
- 💡 Graph visualization polish
- 💡 AI conversation bubbles
- 💡 Export preview modal
- 💡 API documentation portal

---

## 🧪 Testing Strategy

### Phase 1.0
- Unit tests: API routes (search, detail)
- Integration tests: Auth flow, search → detail
- E2E tests: Playwright (search, open detail, keyboard nav)
- Performance: Lighthouse (>90 score target)

### Phase 2.0
- Realtime tests: Comment sync, activity feed
- Security tests: RLS policies, API auth
- Load tests: 10 concurrent users, 1K search queries

### Phase 3.0
- Graph tests: 2K nodes render performance
- AI tests: Response quality, source citations
- Accessibility audit: Full WCAG AA compliance

---

## 📚 Documentation Deliverables

### User Docs (Phase 1.0)
- [ ] Getting started guide
- [ ] Keyboard shortcuts reference
- [ ] Search syntax guide (quoted phrases, tags)

### Developer Docs (Phase 2.5)
- [ ] API documentation (OpenAPI spec)
- [ ] Webhook integration guide
- [ ] Self-hosting instructions (optional)

### Team Docs (Phase 2.0)
- [ ] Collaboration guidelines
- [ ] Comment etiquette
- [ ] Data quality standards (CRAAP explainer)

---

## 🚀 Launch Strategy

### Phase 1.0 Launch (Internal)
- Deploy to Vercel
- Invite 2-3 team members for alpha testing
- Collect feedback (daily standup for Week 3)
- Iterate on UX pain points

### Phase 2.0 Launch (Team)
- Onboard full team (5-10 people)
- Training session (30 min walkthrough)
- Create demo knowledge set (10 curated facts)
- Monitor usage metrics (search conversion, session depth)

### Phase 3.0 Launch (Product?)
- If positioning as product:
  - Landing page + waitlist
  - Product Hunt launch
  - Blog post (architecture, design decisions)
  - Open source design system

---

## 🔧 Tech Debt & Refactoring

### Phase 1.0 → 1.5
- [ ] Extract search logic to reusable hook
- [ ] Centralize API error handling
- [ ] Add Sentry for error tracking

### Phase 2.0 → 2.5
- [ ] Migrate to tRPC (typed API layer)
- [ ] Add Zod schema validation
- [ ] Implement API versioning

### Phase 3.0
- [ ] Optimize graph rendering (WebGL shaders)
- [ ] Add Redis caching layer
- [ ] Implement CDN for static assets

---

## 📈 Analytics & Monitoring

### Week 1 Setup
- [ ] PostHog (product analytics)
- [ ] Sentry (error tracking)
- [ ] Vercel Analytics (performance)

### Events to Track (Phase 1.0)
- `search_submitted` {query, filters, resultsCount, durationMs}
- `result_opened` {id, rank, from}
- `filter_changed` {name, value}
- `auth_login` {method}
- `error_shown` {code, surface}

### Dashboards
- [ ] Daily active users (DAU)
- [ ] Search conversion funnel
- [ ] Average session depth
- [ ] API latency (p50, p95, p99)

---

## 🎯 Next Actions

**Immediate (This Week):**
1. Create Next.js project structure
2. Set up Supabase project + pgvector
3. Implement design system (globals.css)
4. Deploy skeleton to Vercel

**Week 2:**
1. Build markdown migration script
2. Generate embeddings for 275 facts
3. Implement search API endpoint
4. Build search page UI

**Week 3:**
1. Build knowledge detail page
2. Add keyboard shortcuts
3. Implement telemetry
4. User testing with team

---

**Last Updated:** 2025-10-20
**Owner:** Patrick Meehan
**Contributors:** Claude Code (AI Assistant)
