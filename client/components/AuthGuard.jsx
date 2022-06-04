import Link from 'next/link'
import { useState, useEffect } from 'react'
import { supabase } from '../utils/supabaseClient'


export default function AuthGuard({children}) {
  const [session, setSession] = useState(null)

  useEffect(() => {
    setSession(supabase.auth.session())

    supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
    })
  }, [])

  return (
    <div>
      {!session ? <div className="max-w-5xl mx-auto py-20 text-center text-xl">
      Requires Authentication Please <Link href="/signin" ><span className="text-blue-500 cursor-pointer hover:underline">login</span></Link>
      </div> : children}
    </div>
  )
}