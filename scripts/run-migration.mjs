#!/usr/bin/env node

import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Load .env.local manually
const envPath = join(__dirname, '../.env.local')
const envContent = readFileSync(envPath, 'utf-8')
const envVars = {}
envContent.split('\n').forEach(line => {
  const match = line.match(/^([^=]+)=(.*)$/)
  if (match) {
    envVars[match[1].trim()] = match[2].trim()
  }
})

// Get credentials
const SUPABASE_URL = envVars.NEXT_PUBLIC_SUPABASE_URL
const SUPABASE_SERVICE_KEY = envVars.SUPABASE_SERVICE_ROLE_KEY

if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
  console.error('❌ Missing Supabase credentials in .env.local')
  process.exit(1)
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

async function runMigration() {
  console.log('📦 Reading migration file...')

  const migrationPath = join(__dirname, '../supabase/migrations/20251020_initial_schema.sql')
  const sql = readFileSync(migrationPath, 'utf-8')

  console.log('🔄 Running migration...\n')

  try {
    // Execute the SQL using Supabase's RPC
    const { data, error } = await supabase.rpc('exec_sql', { sql_query: sql })

    if (error) {
      // If exec_sql doesn't exist, we need to use postgres connection
      console.log('⚠️  Direct SQL execution not available via REST API')
      console.log('📝 Please run the migration manually:')
      console.log('\n1. Go to: https://supabase.com/dashboard/project/szgwhhkjttkwmnxrfsme/sql/new')
      console.log('2. Copy the contents of: supabase/migrations/20251020_initial_schema.sql')
      console.log('3. Paste and click "Run"\n')
      process.exit(1)
    }

    console.log('✅ Migration completed successfully!')
    console.log('\n📊 Tables created:')
    console.log('  - facts')
    console.log('  - numerical_facts')
    console.log('  - craap_scores')
    console.log('  - profiles')
    console.log('  - comments')

  } catch (err) {
    console.error('❌ Migration failed:', err.message)
    console.log('\n📝 Please run the migration manually via Supabase dashboard')
    process.exit(1)
  }
}

runMigration()
