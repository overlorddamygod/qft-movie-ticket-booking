import Head from "next/head";
import { useState } from "react";
import Layout from "../../../components/Layout";
import SelectInput from "../../../components/SelectInput";
import axiosClient from "../../../utils/axiosClient";

const AddScreening = ({ cinemas, movies }) => {
  const [cinemaId, setCinemaId] = useState("none");
  const [audiId, setAudiId] = useState("none");
  const [time, setTime] = useState();
  const [selectedMovie, setSelectedMovie] = useState(null);

  const onAdd = async (e) => {
    e.preventDefault();
    if (
      cinemaId === "none" ||
      audiId === "none" ||
      time === null ||
      selectedMovie === null
    ) {
      alert("Please fill all the fields");
      return;
    }

    const screening = {
      cinema_id: cinemaId,
      auditorium_id: +audiId,
      start_time: new Date(time).toISOString(),
      movie_id: selectedMovie,
    };

    try {
      const res = await axiosClient.post("/screening", screening);

      alert("Added Screening Successfully.");
    } catch (error) {
      console.log(error);
      alert("Error adding screening. Something went wrong.");
    }
  };

  return (
    <Layout>
      <Head>
        <title>QFT Admin | Add Screening</title>
      </Head>
      <h1>Add Screening</h1>
      <form onSubmit={onAdd}>
        <div>
          <label>Cinema</label>
          <SelectInput
            onChange={(e) => {
              setCinemaId(e.target.value);
              setAudiId("none");
            }}
            value={cinemaId}
          >
            <option key={"none"} value={"none"}>
              None
            </option>
            {Object.keys(cinemas).map((cinema) => (
              <option key={cinemas[cinema].id} value={cinemas[cinema].id}>
                {cinemas[cinema].name}
              </option>
            ))}
          </SelectInput>
        </div>
        <div>
          <label>Auditorium</label>
          <SelectInput
            onChange={(e) => {
              setAudiId(e.target.value);
            }}
            value={audiId}
          >
            <option key={"none"} value={"none"}>
              None
            </option>
            {cinemas[cinemaId] &&
              cinemas[cinemaId].auditoriums.map((aud) => (
                <option key={aud.id} value={aud.id}>
                  {aud.name}
                </option>
              ))}
          </SelectInput>
        </div>
        <div>
          <label>Time</label>
          <input
            className="text-black"
            type="datetime-local"
            value={time}
            onChange={(e) => setTime(e.target.value)}
          />
        </div>
        <div>
          <label>Movie</label>
          <div className="flex">
            {movies.map((movie) => {
              console.log(movie);
              return (
                <div
                  key={movie.id}
                  onClick={() => {
                    setSelectedMovie(movie.id);
                  }}
                  style={{
                    border: selectedMovie == movie.id && "1px solid red",
                  }}
                  className="flex flex-col cursor-pointer hover:scale-105 mr-6 bg-[#0B2039] w-64 overflow-hidden drop-shadow-md shadow-slate-400 p-3 rounded-2xl transition-all"
                >
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
              );
            })}
          </div>
        </div>
        <button
          type="submit"
          className="bg-[#E56E7F] mb-4 hover:opacity-90 font-bold py-2 px-2 text-gray-200 text-md rounded-md disabled:cursor-not-allowed"
        >
          Add Screening
        </button>
      </form>
    </Layout>
  );
};

export default AddScreening;

export const getServerSideProps = async () => {
  try {
    const cinemasRes = await axiosClient.get("/cinema?auditorium=1");

    const { data: cinemas } = cinemasRes.data;

    const moviesRes = await axiosClient.get("/movie");

    const { data: movies } = moviesRes.data;

    const cinemasObj = {};
    cinemas.forEach((cinema) => {
      cinemasObj[cinema.id] = cinema;
    });

    return {
      props: {
        cinemas: cinemasObj,
        movies,
        error: false,
      },
    };
  } catch (err) {
    console.error(err);
    return {
      props: {
        cinemas: {},
        movies: [],
        error: true,
      },
    };
  }
};
