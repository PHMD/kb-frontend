# Frontend Development TODO - Comprehensive Checklist

**Project:** KB Team Interface
**Status:** Not Started
**Last Updated:** 2025-10-20

---

## 🎯 Phase 1.0: Core MVP (Weeks 1-3)

### Week 1: Foundation ✅ / ⏳

#### Project Setup
- [ ] Create Next.js 14+ project with App Router
  ```bash
  npx create-next-app@latest kb-frontend \
    --typescript --tailwind --app --no-src-dir
  ```
- [ ] Initialize Git repository
- [ ] Create `.env.local` with environment variables
- [ ] Install dependencies
  ```bash
  npm install @supabase/supabase-js @supabase/auth-helpers-nextjs
  npm install openai
  npm install gray-matter
  npm install lucide-react
  npm install @radix-ui/react-* (shadcn/ui dependencies)
  ```
- [ ] Set up ESLint + Prettier
- [ ] Configure TypeScript strict mode

#### Supabase Setup
- [ ] Create Supabase project (https://app.supabase.com)
- [ ] Enable pgvector extension
  ```sql
  CREATE EXTENSION IF NOT EXISTS vector;
  ```
- [ ] Run schema migrations (facts, numerical_facts, craap_scores, profiles tables)
- [ ] Set up Row Level Security (RLS) policies
- [ ] Create database functions (`match_documents` for vector search)
- [ ] Generate API keys (anon + service role)
- [ ] Test connection from Next.js

#### Design System Implementation
- [ ] Copy tokens from `/docs/frontend/design-system.md` to `app/globals.css`
- [ ] Configure Tailwind (`tailwind.config.ts`)
  - Map CSS variables to Tailwind colors
  - Add custom border radius, shadows, fonts
  - Enable dark mode (class-based)
- [ ] Install shadcn/ui CLI
  ```bash
  npx shadcn-ui@latest init
  ```
- [ ] Add shadcn/ui components:
  - [ ] Button
  - [ ] Input
  - [ ] Badge
  - [ ] Card
  - [ ] Skeleton
  - [ ] Alert
  - [ ] Drawer
  - [ ] Tooltip
  - [ ] Accordion

#### Auth Implementation
- [ ] Set up Supabase Auth helpers
- [ ] Create `/app/(auth)/login/page.tsx`
- [ ] Create `/app/(auth)/signup/page.tsx`
- [ ] Create `/app/(auth)/logout/route.ts`
- [ ] Implement middleware for protected routes
- [ ] Add session management
- [ ] Test login/signup/logout flows
- [ ] Add password validation (min 8 chars, show/hide toggle)
- [ ] Add error states (user not found, wrong password, rate limited)

#### Deployment
- [ ] Connect GitHub repo to Vercel
- [ ] Configure environment variables in Vercel dashboard
- [ ] Deploy skeleton app
- [ ] Set up custom domain (optional)
- [ ] Test production build
- [ ] Add OG image + favicon

#### Coming Soon Page
- [ ] Create landing page (`/app/page.tsx`)
- [ ] Add "Coming soon" message
- [ ] Show search mockup (static, non-functional)
- [ ] Add email signup for launch notifications (optional)
- [ ] Deploy to production

---

### Week 2: Search Implementation ⏳

#### Data Migration
- [ ] Create migration script (`/scripts/migrate-markdown.ts`)
- [ ] Parse markdown files from parent KB (`../knowledge-base/facts/**/*.md`)
- [ ] Extract frontmatter (gray-matter)
- [ ] Generate OpenAI embeddings (text-embedding-3-small)
  ```typescript
  const embedding = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: `${title}\n\n${content}`,
  });
  ```
- [ ] Batch insert into Supabase (avoid rate limits)
- [ ] Insert CRAAP scores into `craap_scores` table
- [ ] Insert numerical facts into `numerical_facts` table
- [ ] Verify 275 facts migrated successfully
- [ ] Test vector search queries

#### Search API
- [ ] Create `/app/api/search/route.ts`
- [ ] Implement semantic search via pgvector
  ```sql
  SELECT * FROM facts
  ORDER BY embedding <=> query_embedding
  LIMIT 20;
  ```
- [ ] Add project filter
- [ ] Add type filter (fact, pattern, synthesis, gap)
- [ ] Add confidence slider filter (min confidence)
- [ ] Add date range filter
- [ ] Server-side query highlighting (`<mark>` tags)
- [ ] Return structured JSON response
  ```json
  {
    "results": [{
      "id": "uuid",
      "title": "...",
      "snippetHtml": "<mark>highlighted</mark>",
      "project": "...",
      "type": "fact",
      "confidence": 0.82,
      "updatedAt": "ISO",
      "relationCount": 3
    }],
    "tookMs": 123
  }
  ```
- [ ] Add error handling (400, 500)
- [ ] Add rate limiting (optional)

#### Search Page UI
- [ ] Create `/app/(dashboard)/search/page.tsx`
- [ ] Implement SearchBar component
  - [ ] Debounced input (250ms)
  - [ ] Enter submits
  - [ ] Esc clears
  - [ ] `cmd/ctrl+k` global shortcut
  - [ ] Loading indicator
  - [ ] Query token support (tag:foo, project:bar)
- [ ] Implement FilterPanel component
  - [ ] Project multi-select (search within list)
  - [ ] Type checkboxes (fact, pattern, synthesis, gap)
  - [ ] Confidence slider (0.0-1.0, step 0.1)
  - [ ] Date range pickers (created, updated)
  - [ ] "Has relations" toggle
  - [ ] "Reset all" button
  - [ ] Persist filters to localStorage
- [ ] Implement ResultList component
  - [ ] Map API results to ResultCard
  - [ ] Virtualization for >50 items (react-window)
  - [ ] Skeleton loading state (5 rows)
  - [ ] Empty state ("No results for 'q'")
  - [ ] Error state (inline alert with retry)
- [ ] Implement ResultCard component
  - [ ] Title (truncate 1 line)
  - [ ] Snippet (2 lines, with highlights)
  - [ ] Project chip
  - [ ] Type badge
  - [ ] Confidence meter (gradient bar)
  - [ ] Last updated (relative time)
  - [ ] Relation count
  - [ ] Hover state (shadow-2)
  - [ ] Click → navigate to detail

#### Keyboard Navigation
- [ ] Global shortcut listener (`cmd/ctrl+k`)
- [ ] Arrow key navigation (↑/↓)
- [ ] Enter to open result
- [ ] Esc to clear search
- [ ] Focus trap in filter drawer (mobile)

#### States & Error Handling
- [ ] Idle state (show recent searches or popular facts)
- [ ] Loading state (skeleton + spinner)
- [ ] Results state (display list)
- [ ] Empty state (suggestions: remove filters, broaden query)
- [ ] Error state (network, server, rate limit)
- [ ] Partial state (some filters excluded results)

---

### Week 3: Detail Page + Polish ⏳

#### Knowledge Detail Page
- [ ] Create `/app/(dashboard)/knowledge/[id]/page.tsx`
- [ ] Fetch fact + CRAAP + numerical facts + relations (server component)
- [ ] Implement layout (main content + sidebar)
- [ ] Header section:
  - [ ] Title
  - [ ] Project chip
  - [ ] Type badge
  - [ ] Last updated
  - [ ] Confidence meter
- [ ] Content section:
  - [ ] Markdown rendering (react-markdown + rehype plugins)
  - [ ] Syntax highlighting (shiki or prism)
  - [ ] Tables (responsive, zebra stripes)
  - [ ] Code blocks (copy button)
  - [ ] External links (icon + rel="noopener")
- [ ] Sidebar:
  - [ ] Metadata section (ID, tags, created by)
  - [ ] CRAAP accordion (expandable)
  - [ ] Numerical facts table (if present)
  - [ ] Relations panel (grouped by type)
- [ ] Bottom section:
  - [ ] Related items ("More like this" - semantic)
  - [ ] Source links (open in new tab)
- [ ] Actions:
  - [ ] Copy ID button
  - [ ] Copy deep link button
  - [ ] Share button (Phase 3)
  - [ ] "Open in Graph" button (Phase 4)

#### Markdown Rendering
- [ ] Install react-markdown + plugins
  ```bash
  npm install react-markdown remark-gfm rehype-highlight
  ```
- [ ] Create Markdown component
- [ ] Style headings (h1-h4)
- [ ] Style lists (ul, ol)
- [ ] Style blockquotes
- [ ] Style tables (responsive, sticky header)
- [ ] Style code blocks (syntax highlighting)
- [ ] Style inline code
- [ ] Add table of contents (optional)

#### CRAAP Accordion
- [ ] Display 5 dimensions (authority, accuracy, currency, trustworthiness, purpose)
- [ ] Show score (1-10) with visual bar
- [ ] Tooltips explaining each dimension
- [ ] Calculated confidence (sum/50)
- [ ] Compare to stated confidence (highlight mismatch)

#### Relations Panel
- [ ] Group by type (depends_on, supports, blocks, conflicts_with)
- [ ] Display linked fact titles
- [ ] Click → navigate to related fact
- [ ] Show count per type
- [ ] Collapsible sections

#### Keyboard Shortcuts
- [ ] `[` → previous result (if from search)
- [ ] `]` → next result (if from search)
- [ ] `Esc` → back to search
- [ ] `?` → show shortcuts modal

#### Navigation
- [ ] Breadcrumbs (Search ▸ {project} ▸ {title})
- [ ] Back to search (preserve filters + scroll)
- [ ] Previous/next arrows
- [ ] Persistent search query in header

#### Loading & Error States
- [ ] Skeleton for title/meta/content
- [ ] Missing sections (hide with placeholder)
- [ ] 404 page (fact not found)
- [ ] Error boundary (500 errors)

---

#### Telemetry
- [ ] Set up PostHog (https://posthog.com)
- [ ] Add event tracking:
  - [ ] `search_submitted` {query, filters, resultsCount, durationMs}
  - [ ] `result_opened` {id, rank, from}
  - [ ] `filter_changed` {name, value}
  - [ ] `auth_login` {method}
  - [ ] `error_shown` {code, surface}
- [ ] Create analytics dashboard
- [ ] Set up Sentry for error tracking

#### Dark Mode
- [ ] Implement theme toggle (header)
- [ ] Persist preference (localStorage)
- [ ] Sync with system preference
- [ ] Test all components in dark mode
- [ ] Adjust contrast for WCAG AA

#### Performance Optimization
- [ ] Lighthouse audit (target >90)
- [ ] Optimize images (next/image)
- [ ] Code splitting (dynamic imports)
- [ ] Prefetch links (next/link)
- [ ] Add loading.tsx files
- [ ] Minimize JavaScript bundle
- [ ] Enable compression (Vercel)

#### Testing
- [ ] Write unit tests for API routes
- [ ] Write integration tests for auth flow
- [ ] Write E2E tests (Playwright):
  - [ ] Login → search → open detail
  - [ ] Keyboard navigation
  - [ ] Filter changes
  - [ ] Dark mode toggle
- [ ] Test on real devices (iOS Safari, Chrome Android)

#### Documentation
- [ ] Write README.md
- [ ] Document environment setup
- [ ] Create keyboard shortcuts reference
- [ ] Create search syntax guide
- [ ] Add troubleshooting section

---

## 🎯 Phase 1.5: Mobile Polish (Week 4)

### Mobile Interactions
- [ ] Pull-to-refresh on search results
  ```typescript
  const onRefresh = async () => {
    setRefreshing(true);
    await refetch();
    setRefreshing(false);
  };
  ```
- [ ] Swipe gestures on ResultCard
  - [ ] Swipe left → save/bookmark (future)
  - [ ] Swipe right → open detail
- [ ] Mobile keyboard behavior
  - [ ] Auto-scroll input into view on focus
  - [ ] Use `inputmode="search"`
  - [ ] Add `autocomplete` attributes
  - [ ] Hide footer on keyboard open
- [ ] Sticky search bar (scroll)
- [ ] Compact card layout (mobile)
- [ ] Haptic feedback (Web Vibration API)
  ```typescript
  navigator.vibrate?.(10); // 10ms tap
  ```

### Responsive Testing
- [ ] Test on iPhone (Safari)
- [ ] Test on Android (Chrome)
- [ ] Test on tablet (iPad)
- [ ] Fix any layout issues
- [ ] Verify touch targets (44px min)
- [ ] Test landscape orientation

### Performance
- [ ] Lighthouse mobile audit (target >85)
- [ ] Optimize for 3G networks
- [ ] Lazy load images below fold
- [ ] Reduce bundle size for mobile

---

## 🎯 Phase 2.0: Team Collaboration (Weeks 5-6)

### Team Access
- [ ] Add "Member" role to profiles table
- [ ] Create team invite system
  - [ ] Invite by email
  - [ ] Generate invite link
  - [ ] Track pending invites
- [ ] Implement Row Level Security (RLS)
  ```sql
  CREATE POLICY "Users see team knowledge"
  ON facts FOR SELECT
  USING (
    project IN (
      SELECT project FROM team_members
      WHERE user_id = auth.uid()
    )
  );
  ```
- [ ] Create Settings page (`/app/(dashboard)/settings/page.tsx`)
  - [ ] Profile tab (name, email, avatar)
  - [ ] Team tab (members list, invite)
  - [ ] API keys tab (generate, revoke)

### Inline Comments
- [ ] Add comments table to schema
- [ ] Create comment API routes
  - [ ] POST `/api/comments` (create)
  - [ ] GET `/api/comments?factId=...` (list)
  - [ ] DELETE `/api/comments/:id` (delete own)
- [ ] Implement comment UI
  - [ ] Text selection → comment bubble
  - [ ] Click → drawer with thread
  - [ ] Reply to comments (1-level threading)
  - [ ] Edit/delete own comments
  - [ ] Real-time updates (Supabase Realtime)

### @Mentions
- [ ] Parse `@username` in comment text
- [ ] Show autocomplete dropdown
- [ ] Highlight mentions
- [ ] Send notifications

### Notifications
- [ ] Create notifications table
- [ ] In-app notification bell (header)
- [ ] Mark as read
- [ ] Email notifications (optional)
- [ ] Notification settings

### Activity Feed
- [ ] Create activity table (fact updates, comments, etc)
- [ ] Build activity feed page (`/app/(dashboard)/activity/page.tsx`)
- [ ] Group by date
- [ ] Filter by type
- [ ] Real-time updates

### Realtime Sync
- [ ] Set up Supabase Realtime subscriptions
- [ ] Subscribe to facts table changes
- [ ] Subscribe to comments table
- [ ] Update UI on changes
- [ ] Add polling fallback (if Realtime fails)

---

## 🎯 Phase 2.5: Data Access Layer (Week 7)

### Export to CSV
- [ ] Add "Export" button on search results
- [ ] Generate CSV from results
  ```typescript
  const csv = results.map(r => [r.title, r.project, r.confidence].join(','));
  ```
- [ ] Stream download (don't block UI)
- [ ] Limit to 5K rows (prevent timeout)
- [ ] Add export to detail page (single fact)

### API Keys
- [ ] Generate API keys (Settings page)
- [ ] Store hashed keys in database
- [ ] Show key once on creation
- [ ] Revoke keys
- [ ] Track usage per key

### Public API
- [ ] Create `/app/api/v1/search/route.ts`
- [ ] Create `/app/api/v1/facts/[id]/route.ts`
- [ ] Add API key authentication
  ```typescript
  const apiKey = req.headers.get('X-API-Key');
  if (!isValidApiKey(apiKey)) return 401;
  ```
- [ ] Add rate limiting (100 req/min per key)
- [ ] Generate OpenAPI spec (Swagger)
- [ ] Create API documentation portal

### Webhooks (Optional)
- [ ] Add webhooks table
- [ ] Register webhook URLs (Settings)
- [ ] Trigger on fact insert/update
- [ ] Retry failed webhooks
- [ ] Webhook logs (delivery status)

---

## 🎯 Phase 3.0: Advanced AI & Graph (Week 8+)

### Neo4j Integration
- [ ] Set up Neo4j Aura instance
- [ ] Sync facts to Neo4j (nodes)
- [ ] Sync relationships to Neo4j (edges)
- [ ] Create API route for graph queries
  ```typescript
  const session = driver.session();
  const result = await session.run(`
    MATCH (n {id: $nodeId})-[r]->(m)
    RETURN m
  `, { nodeId });
  ```

### Graph View Page
- [ ] Install react-force-graph
  ```bash
  npm install react-force-graph
  ```
- [ ] Create `/app/(dashboard)/graph/page.tsx`
- [ ] Render nodes (color by type, size by confidence)
- [ ] Render edges (label by relationship type)
- [ ] Add zoom/pan controls
- [ ] Click node → show detail panel
- [ ] Search within graph
- [ ] Filters (type, confidence, depth)
- [ ] Optimize for 2K nodes (downsample if needed)

### AI Summarization
- [ ] Add "Summarize" button on detail page
- [ ] Call OpenAI API (gpt-4o-mini)
  ```typescript
  const summary = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [{
      role: 'system',
      content: 'Summarize this knowledge fact in 1-2 sentences.'
    }, {
      role: 'user',
      content: fact.content
    }]
  });
  ```
- [ ] Display summary above content
- [ ] Cache summaries (avoid re-generating)

### Query Reformulation
- [ ] Detect natural language queries
- [ ] Show hint: "interpreting as: X"
- [ ] Improve search results with rephrased query

### Conversational Layer
- [ ] Add floating "Ask" button (bottom-right)
- [ ] Create chat drawer
- [ ] Send query + current context to OpenAI
- [ ] Display AI response with sources
- [ ] Allow follow-up questions
- [ ] Track conversation history (session)

### AI Feedback Loop
- [ ] Add thumbs up/down on AI responses
- [ ] Store feedback in database
- [ ] Show helpfulness rating
- [ ] Improve prompts based on feedback

---

## 🧪 Testing Checklist

### Unit Tests
- [ ] API route handlers
- [ ] Utility functions
- [ ] Hooks (useSearch, useKnowledge)
- [ ] Components (isolated)

### Integration Tests
- [ ] Auth flow (signup → login → logout)
- [ ] Search flow (query → results → detail)
- [ ] Filter changes
- [ ] Comment creation

### E2E Tests (Playwright)
- [ ] Login → search → detail
- [ ] Keyboard navigation (cmd+k, ↑/↓, Enter)
- [ ] Filter panel (open, change, reset)
- [ ] Dark mode toggle
- [ ] Mobile gestures (swipe, pull-to-refresh)

### Accessibility Tests
- [ ] Keyboard-only navigation
- [ ] Screen reader compatibility
- [ ] ARIA labels
- [ ] Color contrast (WCAG AA)
- [ ] Focus states visible

### Performance Tests
- [ ] Lighthouse audit (>90 desktop, >85 mobile)
- [ ] Search latency (<400ms p75)
- [ ] Typing responsiveness (60fps)
- [ ] List virtualization (5K items)
- [ ] Bundle size (<200KB gzipped)

---

## 📊 Success Metrics

### Phase 1.0 (MVP)
- [ ] Search → open conversion > 50%
- [ ] Avg time to first insight < 10s
- [ ] Session depth ≥ 3 views
- [ ] User trust > 70%

### Phase 1.5 (Mobile)
- [ ] Mobile completion > 80%
- [ ] Pull-to-refresh usage > 15%
- [ ] Touch target compliance 100%

### Phase 2.0 (Collaboration)
- [ ] Comment engagement > 20%
- [ ] @mention response < 4hr median
- [ ] Activity feed DAU > 40%

### Phase 2.5 (API)
- [ ] CSV export usage > 10%
- [ ] API adoption > 5 integrations

### Phase 3.0 (AI + Graph)
- [ ] AI helpfulness > 4/5
- [ ] Graph engagement > 30%
- [ ] Conversational queries > 20%

---

## 🚨 Blockers & Risks

- [ ] Supabase pgvector performance (test with 500+ nodes)
- [ ] OpenAI rate limits (batch embeddings)
- [ ] Neo4j Aura cost (monitor usage)
- [ ] Real-time sync reliability (add polling fallback)
- [ ] Mobile keyboard bugs (test on real devices)

---

**Status Legend:**
- ✅ Complete
- ⏳ In Progress
- ⚠️ Blocked
- 🔴 Critical
- 🟡 Important
- 🟢 Nice to Have

---

**Last Updated:** 2025-10-20
**Maintained By:** Claude Code AI Assistant
