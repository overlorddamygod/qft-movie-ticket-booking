import '../styles/globals.css'
import { useState, useEffect } from 'react'
import { supabase } from '../utils/supabaseClient'
import Auth from '../components/Auth'

function MyApp({ Component, pageProps }) {
  return <Component {...pageProps} />
}

export default MyApp
