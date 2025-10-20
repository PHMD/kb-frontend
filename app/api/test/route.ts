import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

export async function GET() {
  try {
    const supabase = await createClient()

    // Test connection by querying facts table
    const { data, error } = await supabase
      .from('facts')
      .select('id')
      .limit(1)

    if (error) {
      return NextResponse.json({
        status: 'error',
        message: error.message,
        hint: 'Make sure you have run the database migration in Supabase SQL Editor'
      }, { status: 500 })
    }

    return NextResponse.json({
      status: 'success',
      message: 'Supabase connection working!',
      factsCount: data?.length || 0
    })
  } catch (error) {
    return NextResponse.json({
      status: 'error',
      message: error instanceof Error ? error.message : 'Unknown error',
      hint: 'Check your .env.local file has correct Supabase credentials'
    }, { status: 500 })
  }
}
