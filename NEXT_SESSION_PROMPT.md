# Next Session: Week 2 - Search Interface Implementation

## Project Context

**Repository:** https://github.com/PHMD/kb-frontend
**Live Site:** https://kb-frontend-kfnbvjufc-patricks-projects-50630fa9.vercel.app
**GitHub Issue:** https://github.com/PHMD/kb-frontend/issues/1

**Project:** KB Frontend - Knowledge Base Team Interface
**Tech Stack:** Next.js 14+ (App Router), TypeScript, Tailwind CSS, shadcn/ui, Supabase + pgvector, OpenAI

---

## What's Already Done (Week 1)

✅ **Next.js Project:** TypeScript, Tailwind, App Router configured
✅ **Design System:** Custom tokens implemented in `app/globals.css` + `tailwind.config.ts`
✅ **shadcn/ui:** 9 components installed (button, input, badge, card, skeleton, alert, drawer, tooltip, accordion)
✅ **Supabase Backend:** 5 tables created with pgvector extension enabled
  - `facts` (main table with vector embeddings)
  - `numerical_facts`, `craap_scores`, `profiles`, `comments`
✅ **Database Migration:** Successfully deployed via Supabase CLI
✅ **Environment Variables:** Configured in Vercel and `.env.local`
✅ **Component Structure:** `components/search/`, `components/knowledge/`, `components/common/`
✅ **Deployed to Vercel:** Production ready with all integrations

**Database:**
- Supabase URL: `https://szgwhhkjttkwmnxrfsme.supabase.co`
- Tables verified and accessible
- pgvector extension enabled
- RLS policies configured

---

## What to Build Next (Week 2)

**Goal:** Implement semantic search with OpenAI embeddings + pgvector

### Task 1: Data Migration Script
Create `scripts/migrate-markdown.ts` to:
1. Find all markdown files in `../knowledge-base/**/*.md`
2. Parse frontmatter (id, type, confidence, project, CRAAP scores)
3. Generate OpenAI embeddings using `text-embedding-3-small`
4. Insert into Supabase `facts` and `craap_scores` tables
5. Target: Migrate 275+ validated knowledge nodes

**Key Files:**
- Source: `../knowledge-base/` (parent directory)
- Migration script: `scripts/migrate-markdown.ts`
- Use: `@supabase/supabase-js` (service_role key), `openai`, `gray-matter`

### Task 2: Search API Endpoint
Create `app/api/search/route.ts` with:
1. Accept: `{ query: string, filters: { project?, type?, minConfidence? } }`
2. Generate query embedding via OpenAI
3. Call `match_documents()` RPC function (already exists in DB)
4. Return results with similarity scores
5. Server-side snippet highlighting
6. **Performance target:** <400ms p75 latency

### Task 3: Search Page UI
Create `app/(dashboard)/search/page.tsx` with components:
- **SearchBar** (`components/search/SearchBar.tsx`):
  - Global keyboard shortcut (cmd/ctrl+k)
  - Debounced input (300ms)
  - Loading spinner during search
- **FilterPanel** (`components/search/FilterPanel.tsx`):
  - Project dropdown
  - Type checkboxes (fact, pattern, synthesis, gap)
  - Confidence slider (0-100%)
  - Clear filters button
- **ResultCard** (`components/search/ResultCard.tsx`):
  - Title + snippet (2 lines max)
  - Project & type badges
  - Confidence meter (gradient bar)
  - Keyboard navigation (↑/↓ arrows, Enter to open)

### Task 4: Testing & Polish
- Test with sample queries
- Verify keyboard navigation (cmd+k, ↑/↓, Enter)
- Mobile responsive testing
- Performance testing (search latency)
- Empty/loading/error states

---

## Design System Reference

**All styling tokens in:** `docs/design-system.md`

**Key colors:**
- Primary: `hsl(var(--primary))` - Blue for actions
- Success: `hsl(var(--success))` - Green for confidence
- Muted: `hsl(var(--muted))` - Gray for secondary text
- Border: `hsl(var(--border))` - Subtle borders

**Components:**
- Cards: Use `.card` class or shadcn Card component
- Badges: Use `.badge` class or shadcn Badge component
- Inputs: Use shadcn Input component

---

## Important Notes

1. **Database Connection:** Supabase client utilities already exist in `lib/supabase/`
   - Browser: `lib/supabase/client.ts`
   - Server: `lib/supabase/server.ts`

2. **Environment Variables:** Already configured (don't need to set up again)
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `OPENAI_API_KEY`

3. **Design Principles:**
   - Server components by default (only use `'use client'` when necessary)
   - Keyboard-first UX (accessibility priority)
   - Performance matters (search latency < 400ms)
   - Trust signals everywhere (confidence scores visible)

4. **Existing Database Function:**
   - `match_documents()` RPC function already exists
   - Accepts: query_embedding, match_threshold, match_count, filter_project, filter_type, min_confidence
   - Returns: facts with similarity scores

---

## Quick Start Commands

```bash
# Start dev server
npm run dev

# Test Supabase connection
curl http://localhost:3000/api/test

# Verify database tables
curl http://localhost:3000/api/verify-tables

# Deploy to Vercel
vercel --prod
```

---

## Recommended Approach

**Start with:**
1. Create the migration script first (get data into Supabase)
2. Build the search API endpoint
3. Create the search page UI components
4. Test and polish

**Use this prompt:**
> "I'm ready to start Week 2: Search Interface Implementation. Let's begin with Task 1 - creating the markdown migration script to load 275+ knowledge nodes into Supabase with OpenAI embeddings. Check the GitHub issue at https://github.com/PHMD/kb-frontend/issues/1 for full details."

---

**Last Updated:** 2025-10-20
**Phase:** 1.0 Week 2 - Search Interface
**GitHub Issue:** #1
