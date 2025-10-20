# Next Steps - KB Frontend Setup

## ✅ What's Done

1. **Next.js project created** with TypeScript, Tailwind, App Router
2. **Dependencies installed**: Supabase, OpenAI, shadcn/ui components
3. **Design system implemented** in `app/globals.css` and `tailwind.config.ts`
4. **Environment variables configured** in `.env.local`
5. **Supabase client utilities created** in `lib/supabase/`
6. **Database migration file created** at `supabase/migrations/20251020_initial_schema.sql`
7. **Test API endpoint created** at `app/api/test/route.ts`

---

## 🔧 Required Manual Steps

### Step 1: Get Supabase Service Role Key

**Why needed:** The service role key has admin privileges needed for data migrations and server-side operations.

1. Go to your Supabase dashboard: https://supabase.com/dashboard
2. Select your project: `szgwhhkjttkwmnxrfsme`
3. Navigate to **Settings → API**
4. Find the **`service_role`** key (it's a secret, click to reveal)
5. Copy it

**Then update `.env.local`:**
```bash
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... # paste your key here
```

---

### Step 2: Enable pgvector Extension

**Why needed:** pgvector enables semantic search using OpenAI embeddings.

1. In Supabase dashboard, go to **Database → Extensions**
2. Search for **"vector"**
3. Click **Enable** on the `vector` extension
4. Wait ~10 seconds for it to activate

---

### Step 3: Run Database Migration

**Why needed:** Creates all tables (facts, craap_scores, profiles, comments) and indexes.

1. In Supabase dashboard, go to **SQL Editor**
2. Click **"New Query"**
3. Open `supabase/migrations/20251020_initial_schema.sql` in your editor
4. Copy the entire SQL content
5. Paste into Supabase SQL Editor
6. Click **Run** (bottom right)
7. You should see: **"Success. No rows returned"**

**Expected tables created:**
- `facts` (main knowledge table with vector embeddings)
- `numerical_facts` (numerical data)
- `craap_scores` (quality metrics)
- `profiles` (user profiles)
- `comments` (for Phase 2 collaboration)

---

### Step 4: Test the Connection

1. Start the development server:
   ```bash
   npm run dev
   ```

2. Open in browser:
   ```
   http://localhost:3000/api/test
   ```

3. You should see:
   ```json
   {
     "status": "success",
     "message": "Supabase connection working!",
     "factsCount": 0
   }
   ```

   If you see an error, check:
   - `.env.local` has correct keys
   - Database migration ran successfully
   - pgvector extension is enabled

---

## 🚀 What's Next (Week 1 Remaining)

After completing the manual steps above:

### 1. Create Component Structure
```bash
mkdir -p components/ui
mkdir -p components/search
mkdir -p components/knowledge
```

### 2. Build Coming Soon Page
- Update `app/page.tsx` with a polished landing page
- Add project description and timeline
- Deploy to Vercel for early feedback

### 3. Deploy Skeleton to Vercel

**Option A: Automatic (recommended)**
1. Push to GitHub:
   ```bash
   git add .
   git commit -m "Initial Next.js setup with Supabase"
   git push origin main
   ```

2. Connect to Vercel:
   - Go to https://vercel.com/new
   - Import your GitHub repo
   - Add environment variables from `.env.local`
   - Deploy

**Option B: Manual**
```bash
npm run build
vercel --prod
```

---

## 📋 Week 1 Checklist

- [x] Next.js project scaffolded
- [x] Supabase project created
- [x] Design system implemented
- [ ] Get service_role key (Step 1 above)
- [ ] Enable pgvector (Step 2 above)
- [ ] Run migration (Step 3 above)
- [ ] Test connection (Step 4 above)
- [ ] Deploy skeleton to Vercel
- [ ] Coming soon page live

---

## 🐛 Troubleshooting

### "relation 'facts' does not exist"
→ Run the database migration in Supabase SQL Editor

### "extension 'vector' is not available"
→ Enable pgvector in Database → Extensions

### "Invalid API key"
→ Check `.env.local` has correct `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### "Missing service_role key"
→ Some operations require the service_role key, not anon key

---

## 📚 Resources

- **Supabase Dashboard**: https://supabase.com/dashboard
- **Project URL**: https://szgwhhkjttkwmnxrfsme.supabase.co
- **Design System**: `docs/design-system.md`
- **Full Roadmap**: `docs/roadmap.md`
- **UI Requirements**: `docs/ui-requirements.md`

---

## 🎯 After Week 1

**Week 2 Focus:**
- Markdown → Supabase migration script
- Search API endpoint with pgvector
- Search page UI (SearchBar + FilterPanel + ResultList)

**Week 3 Focus:**
- Knowledge detail page
- CRAAP score display
- Keyboard shortcuts (cmd+k)
- Dark mode toggle

---

**Last Updated:** 2025-10-20
**Current Phase:** 1.0 Week 1 - Foundation
