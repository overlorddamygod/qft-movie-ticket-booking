// import Head from 'next/head'
// import Image from 'next/image'
// import styles from '../styles/Home.module.css'
import Image from "next/image";
import { useState, useEffect } from "react";
import { supabase } from "../utils/supabaseClient";
import Link from "next/link";
import Layout from "../components/Layout";
import Head from "next/head";
import LayoutWithProvider from "../components/Layout";

export default function Home({ movies, nowshowing }) {
  console.log(movies, nowshowing)
  return (
    <LayoutWithProvider>
      <Head>
        <title>QFT | Home</title>
      </Head>
      <>
      <ShowCase header="Now Showing" movies={nowshowing}/>
      <ShowCase header="Movies" movies={movies}/>
      </>
    </LayoutWithProvider>
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

const MovieCard = ({ movie }) => {
  return (
    <Link href={`/movie/${movie.id}`} key={movie.id}>
      <div className="flex flex-col cursor-pointer hover:scale-105 mr-6 bg-[#0B2039] w-64 overflow-hidden drop-shadow-md shadow-slate-400 p-3 rounded-2xl transition-all">
        <img
          className="w-full rounded-2xl"
          src={movie.banner}
          alt={movie.name}
        />

        <div className="pt-3 mb-1 flex-1">
          <div className="font-bold text-md mb-1 leading-tight">
            {movie.name}
          </div>
          <p className="text-xs text-[#C4C9CF]">
            {movie.description.slice(0, 50) + "..."}
          </p>
        </div>
        <div className="">
          <span className="inline-block bg-gray-200 rounded-full px-3 py-1 text-xs font-semibold text-gray-700 mr-2 mb-2">
            {movie.length} mins
          </span>
        </div>
      </div>
    </Link>
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
