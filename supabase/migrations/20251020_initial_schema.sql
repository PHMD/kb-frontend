-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

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

-- Indexes for performance

-- Vector similarity search (using ivfflat index for pgvector)
CREATE INDEX facts_embedding_idx ON facts USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Project + type filtering
CREATE INDEX facts_project_type_idx ON facts (project, type);

-- Confidence filtering
CREATE INDEX facts_confidence_idx ON facts (confidence DESC);

-- Full-text search (fallback)
CREATE INDEX facts_content_fts_idx ON facts USING gin(to_tsvector('english', content));

-- Timestamp indexes
CREATE INDEX facts_created_at_idx ON facts (created_at DESC);
CREATE INDEX facts_updated_at_idx ON facts (updated_at DESC);

-- Comment indexes
CREATE INDEX comments_fact_id_idx ON comments (fact_id);
CREATE INDEX comments_user_id_idx ON comments (user_id);
CREATE INDEX comments_created_at_idx ON comments (created_at DESC);

-- Function for semantic search using pgvector
CREATE OR REPLACE FUNCTION match_documents(
  query_embedding vector(1536),
  match_threshold float DEFAULT 0.7,
  match_count int DEFAULT 20,
  filter_project text DEFAULT NULL,
  filter_type text DEFAULT NULL,
  min_confidence float DEFAULT 0.0
)
RETURNS TABLE (
  id text,
  type text,
  confidence real,
  project text,
  content text,
  frontmatter jsonb,
  similarity float,
  created_at timestamptz,
  updated_at timestamptz
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    f.id,
    f.type,
    f.confidence,
    f.project,
    f.content,
    f.frontmatter,
    1 - (f.embedding <=> query_embedding) as similarity,
    f.created_at,
    f.updated_at
  FROM facts f
  WHERE
    (filter_project IS NULL OR f.project = filter_project)
    AND (filter_type IS NULL OR f.type = filter_type)
    AND f.confidence >= min_confidence
    AND 1 - (f.embedding <=> query_embedding) >= match_threshold
  ORDER BY f.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- Enable Row Level Security (RLS)
ALTER TABLE facts ENABLE ROW LEVEL SECURITY;
ALTER TABLE numerical_facts ENABLE ROW LEVEL SECURITY;
ALTER TABLE craap_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Facts: Readable by authenticated users
CREATE POLICY "Facts are viewable by authenticated users"
  ON facts FOR SELECT
  TO authenticated
  USING (true);

-- Facts: Only service role can insert/update
CREATE POLICY "Facts are insertable by service role"
  ON facts FOR INSERT
  TO service_role
  WITH CHECK (true);

CREATE POLICY "Facts are updatable by service role"
  ON facts FOR UPDATE
  TO service_role
  USING (true);

-- Numerical facts: Follow facts permissions
CREATE POLICY "Numerical facts are viewable by authenticated users"
  ON numerical_facts FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Numerical facts are insertable by service role"
  ON numerical_facts FOR INSERT
  TO service_role
  WITH CHECK (true);

-- CRAAP scores: Follow facts permissions
CREATE POLICY "CRAAP scores are viewable by authenticated users"
  ON craap_scores FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "CRAAP scores are insertable by service role"
  ON craap_scores FOR INSERT
  TO service_role
  WITH CHECK (true);

-- Profiles: Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Profiles are insertable by authenticated users"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Comments: Users can view all comments
CREATE POLICY "Comments are viewable by authenticated users"
  ON comments FOR SELECT
  TO authenticated
  USING (true);

-- Comments: Users can insert their own comments
CREATE POLICY "Users can insert own comments"
  ON comments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Comments: Users can update their own comments
CREATE POLICY "Users can update own comments"
  ON comments FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Comments: Users can delete their own comments
CREATE POLICY "Users can delete own comments"
  ON comments FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Trigger to auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role)
  VALUES (new.id, new.email, 'member');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_facts_updated_at
  BEFORE UPDATE ON facts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
