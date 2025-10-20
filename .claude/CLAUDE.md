# KB Frontend - Claude Code Instructions

**Project:** Knowledge Base Team Interface
**Tech Stack:** Next.js 14+ (App Router), TypeScript, Tailwind CSS, shadcn/ui, Supabase, Neo4j Aura
**Deployment:** Vercel

---

## 📋 Project Context

You are working on the **frontend interface** for a knowledge base system. The backend validation work is happening in parallel in the parent directory (`../knowledge-base/`).

**Your mission:** Build a Next.js + Supabase web app so teams can search, view, and interact with 275+ validated knowledge nodes.

---

## 🎯 Core Principles

### 1. **Ship Fast, Iterate**
- MVP in 3 weeks (auth + search + detail)
- Deploy skeleton immediately (get feedback early)
- Perfect is the enemy of done

### 2. **Content > Chrome**
- Calm, system-y design (not flashy)
- Low-chroma colors, clear typography
- WCAG AA accessibility minimum

### 3. **Trust Signals Everywhere**
- Confidence scores visible in search results
- CRAAP scores on detail pages
- Source attribution at every touchpoint

### 4. **Keyboard-First UX**
- `cmd/ctrl+k` → focus search (global)
- `↑/↓` → navigate results
- `Enter` → open detail
- `[` / `]` → prev/next

### 5. **Performance Matters**
- Search latency < 400ms p75
- 60fps while typing
- Virtualize lists >50 items
- Zero layout shift (CLS < 0.1)

---

## 📁 Project Structure

```
kb-frontend/
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   └── signup/page.tsx
│   ├── (dashboard)/
│   │   ├── search/page.tsx         # Main landing
│   │   ├── knowledge/[id]/page.tsx # Detail view
│   │   └── graph/page.tsx          # Phase 4
│   ├── api/
│   │   ├── search/route.ts         # Semantic search
│   │   ├── knowledge/[id]/route.ts # Fact detail
│   │   └── embed/route.ts          # Generate embeddings
│   ├── layout.tsx                  # Global shell
│   └── globals.css                 # Design tokens
├── components/
│   ├── ui/ (shadcn/ui components)
│   ├── SearchBar.tsx
│   ├── FilterPanel.tsx
│   ├── ResultCard.tsx
│   └── GraphView.tsx               # Phase 4
├── lib/
│   ├── supabase/
│   │   ├── client.ts               # Browser client
│   │   └── server.ts               # Server client
│   ├── utils.ts
│   └── hooks/
│       ├── useSearch.ts
│       └── useKnowledge.ts
├── public/
│   ├── favicon.ico
│   └── og-image.png
├── docs/
│   ├── ui-requirements.md
│   ├── design-system.md
│   ├── ux-ai-interaction.md
│   ├── gaps-and-recommendations.md
│   └── roadmap.md
└── supabase/
    ├── migrations/
    └── seed.sql
```

---

## 🗄️ Database Schema (Supabase)

### Main Tables

```sql
-- Knowledge facts (main table)
CREATE TABLE facts (
  id TEXT PRIMARY KEY,
  type TEXT CHECK (type IN ('fact', 'pattern', 'synthesis', 'gap')),
  confidence REAL CHECK (confidence >= 0 AND confidence <= 1),
  project TEXT,
  content TEXT,
  embedding vector(1536),  -- OpenAI text-embedding-3-small
  frontmatter JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Numerical facts (for deterministic validation)
CREATE TABLE numerical_facts (
  fact_id TEXT REFERENCES facts(id) ON DELETE CASCADE,
  metric_name TEXT,
  value REAL,
  unit TEXT,
  PRIMARY KEY (fact_id, metric_name)
);

-- CRAAP scores (quality tracking)
CREATE TABLE craap_scores (
  fact_id TEXT REFERENCES facts(id) ON DELETE CASCADE PRIMARY KEY,
  authority INTEGER CHECK (authority >= 1 AND authority <= 10),
  accuracy INTEGER CHECK (accuracy >= 1 AND accuracy <= 10),
  currency INTEGER CHECK (currency >= 1 AND currency <= 10),
  trustworthiness INTEGER CHECK (trustworthiness >= 1 AND trustworthiness <= 10),
  purpose INTEGER CHECK (purpose >= 1 AND purpose <= 10),
  calculated_confidence REAL GENERATED ALWAYS AS (
    (authority + accuracy + currency + trustworthiness + purpose) / 50.0
  ) STORED
);

-- User profiles (for team access)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  role TEXT CHECK (role IN ('owner', 'member', 'viewer')) DEFAULT 'member',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Comments (Phase 2)
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fact_id TEXT REFERENCES facts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Indexes

```sql
-- Vector similarity search
CREATE INDEX ON facts USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Project + type filtering
CREATE INDEX ON facts (project, type);

-- Confidence filtering
CREATE INDEX ON facts (confidence DESC);

-- Full-text search (fallback)
CREATE INDEX ON facts USING gin(to_tsvector('english', content));
```

---

## 🔑 Environment Variables

Create `.env.local`:

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# OpenAI (for embeddings)
OPENAI_API_KEY=sk-...

# Neo4j Aura (Phase 4)
NEO4J_URI=neo4j+s://your-instance.databases.neo4j.io
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=your-password

# Analytics (optional)
NEXT_PUBLIC_POSTHOG_KEY=phc_...
SENTRY_DSN=https://...
```

---

## 🎨 Design System Reference

**All styling tokens are in `/docs/design-system.md**

### Quick Reference

```css
/* Colors */
--primary: 221 83% 53%;      /* Blue */
--success: 160 84% 34%;      /* Green */
--warning: 38 92% 50%;       /* Amber */
--danger: 0 72% 51%;         /* Red */

/* Spacing (8px grid) */
--space-1: 0.5rem;  /* 8px */
--space-2: 1rem;    /* 16px */
--space-3: 1.5rem;  /* 24px */

/* Typography */
--font-sans: Inter, system-ui, sans-serif;
--font-mono: "IBM Plex Mono", monospace;

/* Shadows */
--shadow-1: 0 1px 2px rgba(0,0,0,.05);
--shadow-2: 0 2px 8px rgba(0,0,0,.06);
--shadow-3: 0 8px 24px rgba(0,0,0,.08);
```

---

## 🔍 Key Workflows

### 1. Semantic Search Flow

```typescript
// app/api/search/route.ts
import { createClient } from '@/lib/supabase/server';
import { openai } from '@/lib/openai';

export async function POST(req: Request) {
  const { query, filters } = await req.json();

  // 1. Generate embedding
  const embedding = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: query,
  });

  // 2. Query pgvector
  const supabase = createClient();
  const { data } = await supabase.rpc('match_documents', {
    query_embedding: embedding.data[0].embedding,
    match_threshold: 0.7,
    match_count: 20,
    filter_project: filters.project,
    filter_type: filters.type,
    min_confidence: filters.minConfidence,
  });

  // 3. Highlight matches (server-side)
  const resultsWithHighlights = data.map(result => ({
    ...result,
    snippetHtml: highlightMatches(result.content, query),
  }));

  return Response.json({ results: resultsWithHighlights });
}
```

### 2. Knowledge Detail Page

```typescript
// app/(dashboard)/knowledge/[id]/page.tsx
import { createClient } from '@/lib/supabase/server';
import { Markdown } from '@/components/Markdown';
import { CRAPAccordion } from '@/components/CRAAPAccordion';
import { RelationsPanel } from '@/components/RelationsPanel';

export default async function KnowledgePage({ params }: { params: { id: string } }) {
  const supabase = createClient();

  // Fetch fact with CRAAP + relations
  const { data: fact } = await supabase
    .from('facts')
    .select(`
      *,
      craap_scores (*),
      numerical_facts (*),
      relations:facts!inner(id, title, type)
    `)
    .eq('id', params.id)
    .single();

  return (
    <div className="grid grid-cols-[1fr_300px] gap-6">
      <main>
        <header>
          <h1>{fact.frontmatter.title}</h1>
          <div className="flex gap-2">
            <Badge>{fact.project}</Badge>
            <Badge>{fact.type}</Badge>
            <ConfidenceMeter value={fact.confidence} />
          </div>
        </header>

        <Markdown content={fact.content} />
      </main>

      <aside>
        <CRAPAccordion scores={fact.craap_scores} />
        <RelationsPanel relations={fact.relations} />
      </aside>
    </div>
  );
}
```

### 3. Markdown Migration Script

```typescript
// scripts/migrate-markdown.ts
import { createClient } from '@supabase/supabase-js';
import { openai } from 'openai';
import { glob } from 'glob';
import matter from 'gray-matter';

async function migrateMarkdown() {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

  // 1. Find all markdown files
  const files = await glob('../knowledge-base/**/*.md');

  for (const file of files) {
    // 2. Parse frontmatter + content
    const { data: frontmatter, content } = matter(fs.readFileSync(file, 'utf-8'));

    // 3. Generate embedding
    const embedding = await openai.embeddings.create({
      model: 'text-embedding-3-small',
      input: `${frontmatter.title}\n\n${content}`,
    });

    // 4. Insert into Supabase
    await supabase.from('facts').upsert({
      id: frontmatter.id,
      type: frontmatter.type,
      confidence: frontmatter.confidence,
      project: frontmatter.project,
      content,
      embedding: embedding.data[0].embedding,
      frontmatter,
    });

    // 5. Insert CRAAP scores
    if (frontmatter.source_authority) {
      await supabase.from('craap_scores').upsert({
        fact_id: frontmatter.id,
        authority: frontmatter.source_authority,
        accuracy: frontmatter.source_accuracy,
        currency: frontmatter.source_currency,
        trustworthiness: frontmatter.source_trustworthiness,
        purpose: frontmatter.source_purpose,
      });
    }

    console.log(`✅ Migrated: ${frontmatter.id}`);
  }
}
```

---

## 🚨 Common Pitfalls

### 1. **Don't Hardcode Dates**
```typescript
// ❌ Bad
const today = '2025-10-20';

// ✅ Good
const today = new Date().toISOString().split('T')[0];
```

### 2. **Don't Skip Error Boundaries**
```typescript
// app/error.tsx
'use client';

export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <h2>Something went wrong!</h2>
        <button onClick={reset}>Try again</button>
      </div>
    </div>
  );
}
```

### 3. **Always Use Server Components for Data**
```typescript
// ❌ Bad (client-side data fetching)
'use client';
export default function Page() {
  const [data, setData] = useState(null);
  useEffect(() => { fetch('/api/search').then(...) }, []);
}

// ✅ Good (server component)
export default async function Page() {
  const data = await fetchFromSupabase();
  return <Results data={data} />;
}
```

---

## 📊 Performance Targets

| Metric | Target | Phase |
|--------|--------|-------|
| Search latency (p75) | < 400ms | 1.0 |
| Largest Contentful Paint | < 2.5s | 1.0 |
| Cumulative Layout Shift | < 0.1 | 1.0 |
| Time to Interactive | < 3.5s | 1.0 |
| Lighthouse Score | > 90 | 1.0 |
| List virtualization | > 50 items | 1.0 |

---

## 🧪 Testing Strategy

### Unit Tests (Vitest)
```bash
npm run test
```

### E2E Tests (Playwright)
```bash
npm run test:e2e
```

**Key flows to test:**
- Auth (login, signup, logout)
- Search (semantic, filters, empty)
- Detail (markdown rendering, CRAAP, relations)
- Keyboard navigation (cmd+k, ↑/↓, Enter)

---

## 🚀 Deployment

### Vercel (Automatic)

1. Connect GitHub repo to Vercel
2. Set environment variables in dashboard
3. Deploy on every push to `main`

### Manual Deploy
```bash
npm run build
vercel --prod
```

---

## 📚 Reference Documentation

**All design specs:** `/docs/frontend/`
- `ui-requirements.md` - Functional specifications
- `design-system.md` - Visual styling & tokens
- `ux-ai-interaction.md` - UX strategy & AI patterns
- `gaps-and-recommendations.md` - Future enhancements
- `roadmap.md` - Phase-by-phase plan

**Parent KB docs:** `../knowledge-base/CLAUDE.md`

---

## 🎯 Current Phase

**Phase 1.0: Core MVP** (Weeks 1-3)

**This week's focus:**
- [ ] Next.js project scaffolded
- [ ] Supabase project created
- [ ] Design system implemented
- [ ] Auth working
- [ ] Deployed skeleton to Vercel

**Next week's focus:**
- [ ] Markdown migration script
- [ ] Search API endpoint
- [ ] Search page UI
- [ ] Filters working

---

## 💡 AI Assistant Guidelines

**When helping with this project:**

1. **Always check `/docs/frontend/` first** for design decisions
2. **Refer to design system** for styling (don't reinvent colors/spacing)
3. **Implement accessibility** (WCAG AA minimum, keyboard nav, ARIA)
4. **Server components by default** (only use 'use client' when necessary)
5. **TypeScript strict mode** (no `any` types)
6. **Explain trade-offs** (user is product designer, learning technical depth)

**When stuck:**
- Check Supabase docs: https://supabase.com/docs
- Check Next.js App Router docs: https://nextjs.org/docs
- Check shadcn/ui components: https://ui.shadcn.com

---

## 🔗 Quick Links

- [Supabase Dashboard](https://app.supabase.com)
- [Vercel Dashboard](https://vercel.com/dashboard)
- [OpenAI API](https://platform.openai.com/api-keys)
- [Neo4j Aura Console](https://console.neo4j.io)

---

**Last Updated:** 2025-10-20
**Maintained By:** Claude Code AI Assistant
