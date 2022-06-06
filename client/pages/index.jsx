// import Head from 'next/head'
// import Image from 'next/image'
// import styles from '../styles/Home.module.css'
import Image from "next/image";
import { useState, useEffect } from "react";
import { supabase } from "../utils/supabaseClient";
import Link from "next/link";
import Layout from "../components/Layout";
import Head from "next/head";
import MovieCard from "../components/MovieCard";

export default function Home({ movies, nowshowing }) {
  console.log(movies, nowshowing)
  return (
    <Layout>
      <Head>
        <title>QFT | Home</title>
      </Head>
      <>
      <ShowCase header="Now Showing" movies={nowshowing}/>
      <ShowCase header="Movies" movies={movies}/>
      </>
    </Layout>
  );
}

const ShowCase = ({ header = "", movies }) => {
  return (
    <>
      <div>
        <h2 className="text-3xl py-3">{header}</h2>
      </div>
      <div className="flex">
        {movies.map((movie) => {
          return <MovieCard movie={movie} key={movie.id}/>;
        })}
      </div>
    </>
  );
};


// get props
export const getServerSideProps = async () => {
  const { data: movies, error } = await supabase.from("movies").select("*");
  if (error) {
    console.error(error);
  }

  const { data: nowshowing, error: err } = await supabase
    .rpc("nowshowing")
  if (err) {
    console.error(err);
  }
  return {
    props: {
      movies,
      nowshowing,
    },
  };
};
