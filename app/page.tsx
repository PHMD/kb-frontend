export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-8 bg-bg">
      <div className="max-w-2xl text-center space-y-6">
        <div className="space-y-2">
          <h1 className="text-4xl font-bold text-text">Knowledge Base</h1>
          <p className="text-lg text-muted">Team interface for validated knowledge nodes</p>
        </div>

        <div className="space-y-4 text-left bg-surface rounded-md p-6 border border-border">
          <h2 className="text-xl font-semibold text-text">Phase 1.0: Core MVP</h2>
          <ul className="space-y-2 text-sm text-muted">
            <li className="flex items-start gap-2">
              <span className="text-success">✓</span>
              <span>Next.js 14+ with TypeScript & Tailwind CSS</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-success">✓</span>
              <span>Supabase integration with pgvector for semantic search</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-success">✓</span>
              <span>Database schema deployed (5 tables, RLS enabled)</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-success">✓</span>
              <span>Design system implemented with shadcn/ui components</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-muted">○</span>
              <span className="opacity-60">Search interface (Week 2)</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-muted">○</span>
              <span className="opacity-60">Knowledge detail pages (Week 3)</span>
            </li>
          </ul>
        </div>

        <div className="flex gap-4 justify-center pt-4">
          <a
            href="/api/test"
            target="_blank"
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xs bg-primary text-primary-fg hover:opacity-90 transition text-sm font-medium"
          >
            Test API Connection
          </a>
          <a
            href="/api/verify-tables"
            target="_blank"
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xs border border-border text-text hover:bg-surface transition text-sm font-medium"
          >
            Verify Database
          </a>
        </div>

        <p className="text-xs text-muted pt-4">
          Built with Next.js, Supabase, OpenAI, and Neo4j Aura
        </p>
      </div>
    </main>
  )
}
