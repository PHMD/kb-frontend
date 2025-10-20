# KB Frontend - Knowledge Base Team Interface

**Status:** 🚧 In Development (Phase 1.0 - Week 1)

A Next.js web application for searching, viewing, and interacting with validated knowledge nodes.

---

## 🎯 Project Vision

**"A calm, credible, AI-enhanced research copilot that helps teams find, trust, and connect validated knowledge."**

---

## 🛠️ Tech Stack

- **Frontend:** Next.js 14+ (App Router), TypeScript, Tailwind CSS
- **UI Components:** shadcn/ui
- **Backend:** Supabase (Postgres + pgvector + Auth + Realtime)
- **Graph DB:** Neo4j Aura (Phase 4)
- **Embeddings:** OpenAI (text-embedding-3-small)
- **Deployment:** Vercel
- **Analytics:** PostHog + Sentry

---

## 📚 Documentation

All design specs and planning docs are in `/docs/`:

- **[UI Requirements](./docs/ui-requirements.md)** - Functional specifications
- **[Design System](./docs/design-system.md)** - Visual styling & tokens
- **[UX & AI Interaction](./docs/ux-ai-interaction.md)** - UX strategy & AI patterns
- **[Gaps & Recommendations](./docs/gaps-and-recommendations.md)** - Future enhancements
- **[Roadmap](./docs/roadmap.md)** - 8-week phase-by-phase plan
- **[TODO](./docs/TODO.md)** - Comprehensive task checklist (275+ items)

**For Claude Code AI:** See [`.claude/CLAUDE.md`](./.claude/CLAUDE.md) for project-specific instructions.

---

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ and npm
- Supabase account (https://supabase.com)
- OpenAI API key (https://platform.openai.com)
- Vercel account (https://vercel.com) - optional

### Setup (Week 1)

```bash
# 1. Create Next.js project
npx create-next-app@latest . \
  --typescript --tailwind --app --no-src-dir

# 2. Install dependencies
npm install @supabase/supabase-js @supabase/auth-helpers-nextjs
npm install openai gray-matter lucide-react

# 3. Initialize shadcn/ui
npx shadcn-ui@latest init

# 4. Set up environment variables
cp .env.example .env.local
# Edit .env.local with your API keys

# 5. Run development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

---

## 📁 Project Structure (Planned)

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
│   │   └── knowledge/[id]/route.ts # Fact detail
│   ├── layout.tsx
│   └── globals.css                 # Design tokens
├── components/
│   ├── ui/ (shadcn/ui)
│   ├── SearchBar.tsx
│   ├── FilterPanel.tsx
│   ├── ResultCard.tsx
│   └── GraphView.tsx
├── lib/
│   ├── supabase/
│   └── utils.ts
├── docs/                           # Design specs
├── scripts/
│   └── migrate-markdown.ts         # KB → Supabase
└── supabase/
    └── migrations/
```

---

## 🗄️ Database Schema (Supabase)

See [`.claude/CLAUDE.md`](./.claude/CLAUDE.md#database-schema-supabase) for full schema.

**Core tables:**
- `facts` - Knowledge nodes with vector embeddings
- `craap_scores` - Source quality metrics
- `numerical_facts` - Structured metrics
- `profiles` - User data
- `comments` - Team collaboration (Phase 2)

---

## 🎨 Design System

Based on calm, system-y aesthetic with WCAG AA accessibility.

**Key tokens:**
- Primary: `hsl(221 83% 53%)` - Blue
- Font: Inter (sans), IBM Plex Mono (mono)
- Spacing: 8px grid
- Shadows: Subtle elevation (1-3 levels)

See [docs/design-system.md](./docs/design-system.md) for complete token reference.

---

## 🗓️ Roadmap

### Phase 1.0 (MVP) - Weeks 1-3 ⏳
- Auth (email/password)
- Semantic search (pgvector)
- Knowledge detail page
- Dark mode
- Deployed to Vercel

### Phase 1.5 - Week 4
- Mobile polish (pull-to-refresh, swipe gestures)

### Phase 2.0 - Weeks 5-6
- Team collaboration (comments, @mentions)
- Activity feed

### Phase 2.5 - Week 7
- API + CSV export

### Phase 3.0 - Week 8+
- Graph visualization (Neo4j)
- Conversational AI

See [docs/roadmap.md](./docs/roadmap.md) for detailed timeline.

---

## 🧪 Testing

```bash
# Unit tests
npm run test

# E2E tests (Playwright)
npm run test:e2e

# Lighthouse audit
npm run lighthouse
```

---

## 🚀 Deployment

### Vercel (Recommended)

1. Connect GitHub repo to Vercel
2. Set environment variables
3. Deploy on every push to `main`

```bash
# Manual deploy
vercel --prod
```

---

## 📊 Success Metrics (Phase 1.0)

- [ ] Search → open conversion > 50%
- [ ] Avg time to first insight < 10s
- [ ] Session depth ≥ 3 views per session
- [ ] Search latency < 400ms p75
- [ ] Lighthouse score > 90

---

## 🔗 Related Projects

- **Knowledge Base** (parent): `../knowledge-base/`
  - Data validation & quality assurance
  - Markdown source files
  - Python scripts

---

## 📝 License

Private project - not open source (yet)

---

## 🤝 Contributing

Internal project. For questions or improvements:
- Open an issue
- Submit a pull request
- Contact: Patrick Meehan

---

**Last Updated:** 2025-10-20
**Current Phase:** 1.0 (MVP - Week 1)
**Status:** Setup & foundation
