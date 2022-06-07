import Head from "next/head";
import Layout from "../components/Layout";
import MovieCard from "../components/MovieCard";
import { supabase } from "../utils/supabaseClient";

export default function Home({ movies, nowshowing }) {
  // console.log(movies, nowshowing)
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
