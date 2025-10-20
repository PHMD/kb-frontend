import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET() {
  try {
    const supabase = await createClient()

    // Test each table exists by selecting from it
    const tables = ['facts', 'numerical_facts', 'craap_scores', 'profiles', 'comments']
    const results: Record<string, boolean> = {}

    for (const table of tables) {
      const { error } = await supabase.from(table).select('*').limit(0)
      results[table] = !error
    }

    const allTablesExist = Object.values(results).every(v => v)

    return NextResponse.json({
      status: allTablesExist ? 'success' : 'partial',
      message: allTablesExist ? 'All tables created successfully!' : 'Some tables missing',
      tables: results
    })
  } catch (error) {
    return NextResponse.json({
      status: 'error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 })
  }
}
