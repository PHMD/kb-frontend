# Setup Instructions - KB Frontend

**Start here!** Step-by-step guide to get the frontend running.

---

## ✅ You Are Here

The project structure is created. Now you'll set up Next.js + Supabase.

**Current directory:** `/Users/patrickmeehan/kb-frontend/`

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Node.js 18+ installed (`node --version`)
- [ ] npm or yarn installed
- [ ] Git installed
- [ ] Supabase account (https://supabase.com)
- [ ] OpenAI API key (https://platform.openai.com/api-keys)
- [ ] Vercel account (optional, for deployment)

---

## 🚀 Step-by-Step Setup

### Step 1: Create Next.js Project

**Open new terminal in this directory:**
```bash
cd /Users/patrickmeehan/kb-frontend
```

**Create Next.js app:**
```bash
npx create-next-app@latest . \
  --typescript \
  --tailwind \
  --app \
  --no-src-dir \
  --import-alias "@/*"
```

**Answer prompts:**
- Would you like to use ESLint? → **Yes**
- Would you like to use `src/` directory? → **No**
- Would you like to use App Router? → **Yes**
- Would you like to customize the default import alias? → **No**

---

### Step 2: Install Dependencies

```bash
# Supabase
npm install @supabase/supabase-js @supabase/auth-helpers-nextjs

# OpenAI
npm install openai

# Utilities
npm install gray-matter lucide-react date-fns

# Development
npm install -D @types/node
```

---

### Step 3: Initialize shadcn/ui

```bash
npx shadcn-ui@latest init
```

**Answer prompts:**
- Style → **Default**
- Base color → **Slate**
- CSS variables → **Yes**

**Install components:**
```bash
npx shadcn-ui@latest add button input badge card skeleton alert drawer tooltip accordion
```

---

### Step 4: Set Up Supabase Project

**Go to:** https://supabase.com/dashboard

1. **Create new project**
   - Organization: Your name
   - Project name: `kb-frontend`
   - Database password: (save this!)
   - Region: Choose closest to you

2. **Wait for project to initialize** (~2 minutes)

3. **Enable pgvector extension**
   - Go to Database → Extensions
   - Search "vector"
   - Enable `vector` extension

4. **Get API keys**
   - Go to Settings → API
   - Copy `Project URL` (NEXT_PUBLIC_SUPABASE_URL)
   - Copy `anon public` key (NEXT_PUBLIC_SUPABASE_ANON_KEY)
   - Copy `service_role` key (SUPABASE_SERVICE_ROLE_KEY)

---

### Step 5: Configure Environment Variables

**Copy example:**
```bash
cp .env.example .env.local
```

**Edit `.env.local`:**
```bash
# Supabase (from Step 4)
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# OpenAI (get from https://platform.openai.com/api-keys)
OPENAI_API_KEY=sk-proj-...

# App Config
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

---

### Step 6: Run Database Migrations

**Create Supabase migration file:**
```bash
mkdir -p supabase/migrations
```

**Create file:** `supabase/migrations/20251020_initial_schema.sql`

**Copy schema from:** `.claude/CLAUDE.md` (Database Schema section)

**Run migration via Supabase Dashboard:**
1. Go to Database → SQL Editor
2. Paste migration SQL
3. Run query

---

### Step 7: Implement Design System

**Copy tokens to `app/globals.css`:**

Replace contents with tokens from `docs/design-system.md`

**Update `tailwind.config.ts`:**

Copy Tailwind config from `docs/design-system.md`

---

### Step 8: Start Development Server

```bash
npm run dev
```

**Open:** http://localhost:3000

You should see the Next.js welcome page.

---

## ✅ Verify Setup

**Check these work:**

1. **Next.js running:**
   - Open http://localhost:3000
   - See Next.js default page

2. **Supabase connected:**
   - Create `app/api/test/route.ts`
   - Try fetching from `facts` table
   - Should return empty array (table is empty)

3. **Design system working:**
   - Dark mode toggle works
   - Colors match design system
   - Fonts load (Inter, IBM Plex Mono)

---

## 🎯 Next Steps (Week 1)

**Now that setup is complete:**

1. **Build auth pages** (`app/(auth)/login/page.tsx`)
2. **Deploy skeleton to Vercel**
3. **Create coming soon page**

**Follow:** `docs/TODO.md` (Week 1 checklist)

---

## 🐛 Troubleshooting

### "Module not found: @supabase/supabase-js"
```bash
npm install @supabase/supabase-js
```

### "CORS error when calling Supabase"
- Check `NEXT_PUBLIC_SUPABASE_URL` is correct
- Verify Supabase project is active
- Check API key matches project

### "OpenAI API error"
- Verify `OPENAI_API_KEY` starts with `sk-proj-`
- Check you have credits: https://platform.openai.com/account/billing

### "Dark mode not working"
- Check `tailwind.config.ts` has `darkMode: ['class']`
- Verify `globals.css` has `.dark` styles

---

## 📚 Resources

- **Next.js Docs:** https://nextjs.org/docs
- **Supabase Docs:** https://supabase.com/docs
- **shadcn/ui:** https://ui.shadcn.com
- **Tailwind CSS:** https://tailwindcss.com/docs

---

## 🆘 Need Help?

**Open Claude Code in this directory:**
```bash
cd /Users/patrickmeehan/kb-frontend
# New terminal tab, run claude-code
```

Claude Code will load `.claude/CLAUDE.md` and help you with:
- Next.js questions
- Supabase setup
- Design system implementation
- Component development

---

**Ready?** Start with Step 1! 🚀
