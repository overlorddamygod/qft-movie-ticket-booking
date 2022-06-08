import React from 'react'
import Layout from '../../../components/Layout'
import SeatsSetup from '../../../components/SeatsSetup'
import { supabase } from '../../../utils/supabaseClient'
import Head from 'next/head'

const Seats = ({cinemas}) => {
  return (
    <Layout>
            <Head>
        <title>QFT Admin | Configure Seats</title>
      </Head>
        <SeatsSetup cinemas={cinemas}/>
    </Layout>
  )
}

export default Seats

export const getServerSideProps = async () => {
    const { data: cinemas, error } = await supabase
      .from("cinemas")
      .select(`
        id,
        name,
        address,
        auditoriums!auditorium_cinema_id_fkey (id, cinema_id, name)
      `)
      
    if (error) {
      console.log(error);
    }

    // turn to key value pair
    const cinemasObj = {}
    cinemas.forEach(cinema => {
        cinemasObj[cinema.id] = cinema
    })

    // }
    return {
      props: {
        cinemas: cinemasObj,
      },
    };
  };