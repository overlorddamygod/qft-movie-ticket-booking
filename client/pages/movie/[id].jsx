import Link from "next/link";
import { useState, useEffect } from "react";
import Router, { useRouter } from "next/router";
import { supabase } from "../../utils/supabaseClient";
import { Seat, colorMap, getColor } from "../../components/SeatsSetup";
import Layout from "../../components/Layout";
import Banner from "../../components/Banner";
import moment from "moment";
import Head from "next/head";
import axiosClient from "../../utils/axiosClient";

const ShowPage = ({ movie, cinemas }) => {
  const [seatsGrid, setSeatsGrid] = useState([[]]);
  const [selectedSeats, setSelectedSeats] = useState([]);
  const [seatIdToGridMap, setSeatIdToGridMap] = useState({});
  const [dates, setDates] = useState([]);
  const [selectedDate, setSelectedDate] = useState(0);
  const [selectedCinemaId, setSelectedCinemaId] = useState(
    cinemas.length > 0 ? cinemas[0].id : 0
  );
  const [selectedTime, setSelectedTime] = useState("");
  const [message, setMessage] = useState();
  const [loading, setLoading] = useState(true);
  const [screenings, setScreenings] = useState({});
  const [screening, setScreening] = useState({});


  useEffect(() => {
    const now = moment();
    const _dates = []

    for (let i = 0; i < 6; i++) {
      const date = now.clone().add(i, "d");
      _dates.push(date)
    }

    setDates(_dates)

    console.log("BEGINNING")
    console.log(supabase.auth)

    
    const { query } = Router
    console.log(query)
    const queries = ["date", "date_index", "cinema_id", "screening_id"]
    console.log(queries.every(q => Object.keys(query).includes(q)))
    if (queries.every(q => Object.keys(query).includes(q))) { 
      console.log("FOUND QUERY")
      setSelectedDate(+query.date_index)
      setSelectedCinemaId(query.cinema_id)
      console.log(query)
      setSelectedTime(query.screening_id);

      // getScreeningById(query.screening_id)
    } else {
      console.log("NO QUERY")
      setSelectedDate(0);
      const q = {
        date_index: 0,
        date: _dates[0].format("YYYY-MM-DD"),
      }
      if (cinemas.length > 0) {
        setSelectedCinemaId(cinemas.length > 0 ? cinemas[0].id : 0);
        q["screening_id"]= cinemas[0].id
      }
      updateQuery(q)
    }
    return () => {
      setDates((dates) => []); 
    };
  }, []);

  const updateQuery = (keyVal) => {
    for (let key in keyVal) {
      keyVal[key] = encodeURI(keyVal[key]);
    }

    Router.push({
      pathname: Router.pathname,
      query: {
        ...Router.query,
        ...keyVal
      },
    });
  };

  useEffect(() => {
    if (selectedTime == "") return
    setSelectedSeats([]);
    console.log("FETCHING SCREENING FOR ID", selectedTime)
    getScreeningById(selectedTime)
  }, [selectedTime]);

  useEffect(()=> {
    if (Object.keys(screening).length == 0 ) return

    console.log("FOUND SCREENING FOR ID", selectedTime)
    console.log("SCREENING", screening)

     const grid = Array(screening.auditorium.rows)
      .fill(null)
      .map(() => Array(screening.auditorium.columns).fill(1));

    const gridMap = {};

 
    for (let seat of screening.auditorium.seats) {
      // seat.status = seat.available ? 1 : 0;
      // if (screening.booking[seat.id]) {
      //   seat.status = screening.booking[seat.id].status;
      // }

      grid[seat.row - 1][seat.number - 1] = seat;
      gridMap[seat.id] = grid[seat.row - 1][seat.number - 1];
    }
    setSeatIdToGridMap(gridMap);
    // console.log(gridMap)

    setSeatsGrid(grid);
    // console.log(`bookings:screening_id=eq.${screening.id}`)
    // const bookings = supabase
    //   .from(`bookings:screening_id=eq.${screening.id}`)
    //   .on("INSERT", (payload) => {
    //     console.log("Change received!", payload);
    //     const { new: newBooking } = payload;
    //     // ))
    //   })
    //   .subscribe();
  }, [screening])

  const getScreeningById = async (id) => {
    axiosClient.get(`api/v1/screening/${id}`, {
      headers: {
        Authorization: `${supabase.auth.currentSession.access_token}`,
      }
    })
      .then(res => {
        console.log(res)
        setScreening(res.data.data)
      })
      .catch(err => {
        console.error(err)
      })
  }


  // useEffect(()=> {
  //   updateQuery("date", dates[0].format("yyyy-MM-DD"));
  // }, [selectedDate])

  const onGridClick = async (rowIndex, columnIndex) => {
    const response = axiosClient
      .post("api/v1/booking", {
        user_id: supabase.auth.currentUser.id,
        seat_id: seatsGrid[rowIndex][columnIndex].id,
        screening_id: screening.id,
        auditorium_id: screening.auditorium.id,
      }, {
        headers: {
          Authorization: `${supabase.auth.currentSession.access_token}`,
        }
      })
      .then((res) => {
        console.log(res);

        const status = seatsGrid[rowIndex][columnIndex].status;
        if (status === 0 || status == 3 || status == 4) {
          return;
        }

        const grid = [...seatsGrid];
        grid[rowIndex][columnIndex].status =
          grid[rowIndex][columnIndex].status === 1 ? 2 : 1;
        const selected = [...selectedSeats];

        if (status === 1) {
          selected.push(grid[rowIndex][columnIndex]);
        } else {
          selected = selected.filter(
            (s) => s.id !== grid[rowIndex][columnIndex].id
          );
        }
        setSeatsGrid(grid);
        setSelectedSeats(selected);
        // onDateSelected();
        getScreeningById(selectedTime)
      })
      .catch((err) => {
        console.log(err);
      });
  };

  const onPurchase = async () => {
    const screening = screenings[selectedTime];
    if (!screening) {
      return;
    }
    // console.log(selectedSeats);
    const { data, err } = await supabase.from("bookings").insert(
      selectedSeats.map((s) => {
        return {
          seat_id: s.id,
          screening_id: screening.id,
          auditorium_id: screening.auditorium.id,
          status: 4,
        };
      })
    );

    setSelectedSeats([]);

    if (err) {
      console.log(err);
      return;
    }
    alert("Purchase successful!");
  };

  const onReserve = async () => {
    const screening = screenings[selectedTime];
    if (!screening) {
      return;
    }
    const { data, err } = await supabase.from("bookings").insert(
      selectedSeats.map((s) => {
        return {
          seat_id: s.id,
          screening_id: screening.id,
          auditorium_id: screening.auditorium.id,
          status: 3,
        };
      })
    );

    setSelectedSeats([]);

    if (err) {
      console.log(err);
      return;
    }
    console.log(data);
    alert("Reserve successful!");
  };

  useEffect(() => {
    console.log(selectedDate, dates,selectedCinemaId)
    if (dates.length == 0 ) return
    console.log("GETTING SCREENIGNS", dates, selectedDate, selectedCinemaId)
    // onDateSelected();
    getScreenings(movie.id, selectedCinemaId, dates[selectedDate].format("YYYY-MM-DD"));
    return () => {};
  }, [dates, selectedDate, selectedCinemaId]);

  const getScreenings = (movie_id, cinema_id, date, setTime = true) => {
    setLoading(true);
    setMessage("");
    setScreenings({});

    const url = `api/v1/screening?movie_id=${movie_id}&cinema_id=${cinema_id}`

    if (date) {
      url += `&date=${date}`
    }
    axiosClient.get(url, {
      headers: {
        Authorization: `${supabase.auth.currentSession.access_token}`,
      }
    }).then(res => {
      const {data} = res.data
      console.log("SAD",res.data.data)

      if (data.length === 0) {
        // setScreenings([])
        setMessage("No screenings at this date");
        setLoading(false);
        return;
      }

      const obj = {};

      for (let i = 0; i < data.length; i++) {
        const screening = data[i];
        obj[screening.id] = screening;
      }

      setScreenings(res.data.data)
      if (setTime) {
        setSelectedTime(data[0].id);
      }
      setLoading(false)
    }).catch(err => {
      console.error(err)
      setMessage("Error")
      setLoading(false)
    })
  }

  // const onDateSelected = async () => {
  //   setLoading(true);
  //   setMessage("");
  //   setScreenings({});
  //   const d = dates[selectedDate];
  //   if (!d) {
  //     setLoading(false);
  //     return;
  //   }
  //   console.log(d.toString());
  //   const { data, err } = await supabase
  //     .from("screenings")
  //     .select(
  //       `
  //     id,
  //     start_time,
  //     movie:movie_id (id, name, release_date, trailer, banner, description, length ),
  //     cinema:cinema_id (id, name, address),
  //     booking:bookings!bookings_screening_id_fkey ( seat_id, status),
  //     auditorium:auditorium_id ( id, name, rows, columns, seat:seats!seats_auditorium_id_fkey (id, row, number, available) )
  //   `
  //     )
  //     .eq("movie_id", movie.id)
  //     .eq("cinema_id", selectedCinemaId)
  //     .lt("start_time", d.endOf("day").toDate().toISOString())
  //     .gt("start_time", d.startOf("day").toDate().toISOString());
  //   if (err) {
  //     console.log(err);
  //   }
  //   if (data.length === 0) {
  //     // setScreenings([])
  //     setMessage("No screenings at this date");
  //     setLoading(false);
  //     return;
  //   }

  //   for (let i = 0; i < data.length; i++) {
  //     const bookingObj = {};

  //     for (let booking of data[i].booking) {
  //       bookingObj[booking.seat_id] = booking;
  //     }
  //     data[i].booking = bookingObj;
  //   }

  //   const obj = {};

  //   for (let i = 0; i < data.length; i++) {
  //     const screening = data[i];
  //     obj[screening.id] = screening;
  //   }

  //   setScreenings(obj);
  //   setSelectedTime(data[0].id);

  //   setLoading(false);
  // };

  return (
    <Layout auto={false}>
      <Head>
        <title>{movie.name}</title>
      </Head>
      <div>
        <div className="flex flex-col justify-center items-center max-w-5xl mx-auto my-8 md:flex-row">
          <Banner src={movie.banner} alt={movie.name} />
          <div className="mx-5 mt-3 md:ml-12">
            <h1 className="text-4xl">{movie.name}</h1>
            <p className="mt-2">
              🕗 {movie.length} mins{" "}
              <span className="ml-3 ">
                {new Date(movie.release_date).getFullYear()}
              </span>
            </p>
            <p className="my-3 text-sm text-[#455B77]">{movie.description}</p>
            <Link href={movie.trailer}>
              <button className="border-[#C6AA55] border-2 py-2 px-2 mt-4 rounded-md hover:scale-105">
                Watch Trailer
              </button>
            </Link>
            {/* <h2>{screening.auditorium.name}</h2> */}
          </div>
        </div>

        <div className="bg-[#0B2039]">
          <div className="flex max-w-xl md:max-w-5xl mx-auto h-full md:flex-row flex-col px-5 md:px-0">
            <div className="flex-1 flex">
              <div className="flex items-center mr-4">
                <div className="md:text-2xl">Date</div>
              </div>
              <div className="flex justify-center md:justify-start flex-1">
                {dates.map((d, index) => {
                  const formatted = d.format("MMM-DD-ddd").split("-");
                  return (
                    <div
                      key={index}
                      className="flex"
                      onClick={() => {
                        setSelectedDate(index);
                        updateQuery({
                          date: d.format("yyyy-MM-DD"),
                          date_index: index,
                        })
                      }}
                    >
                      <div
                        className="flex py-3 justify-center items-center text-white hover:bg-[#1A427C] select-none cursor-pointer"
                        style={{
                          background: selectedDate == index ? "#1A427C" : "",
                        }}
                      >
                        <div className="px-4 md:px-6 flex flex-col justify-center items-center">
                          <div className="text-xs md:text-sm">
                            {formatted[0]}
                          </div>
                          <div className="text-xl md:text-2xl">
                            {formatted[1]}
                          </div>
                          <div className="text-xs md:text-sm">
                            {formatted[2]}
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
            <div className="flex py-2 md:py-0">
              <div className="flex flex-col justify-center flex-1 min-w-fit">
                <div className="text-2xl">Time</div>
                <div>
                  <select
                    id="time"
                    className="bg-transparent text-[#455B77] mt-1 text-lg w-full"
                    value={selectedTime}
                    onChange={(e) => {
                      console.log("SELECTEDDDD", e.target.value, e.target)
                      setSelectedTime(e.target.value);
                      updateQuery({
                        "screening_id": e.target.value
                      });
                    }}
                  >
                    {Object.keys(screenings).length == 0 && (
                      <option value="none">None</option>
                    )}
                    {Object.entries(screenings).map(
                      ([id, screening], index) => {
                        return (
                          <option key={screening.id} value={screening.id} >
                            {moment(screening.start_time).format("LT")}
                          </option>
                        );
                      }
                    )}
                  </select>
                </div>
              </div>
              <div className="w-12 flex justify-center items-center flex-1">
                <div className="w-0.5 h-3/4 bg-[#17283D]"></div>
              </div>
              <div className=" flex flex-col justify-center min-w-fit">
                <div className="text-2xl">Cinema</div>
                <div>
                  <select
                    className="bg-transparent text-[#455B77] mt-1 text-lg w-full"
                    value={selectedCinemaId}

                    onChange={() => {
                      setSelectedCinemaId(event.target.value);
                      updateQuery({
                        "cinema_id": event.target.value
                      });
                    }}
                  >
                    {cinemas.map((cinema, index) => {
                      return (
                        <option
                          // selected={index == 0}
                          key={cinema.id}
                          value={cinema.id}
                        >
                          {cinema.name}
                        </option>
                      );
                    })}
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>

        {loading ? (
          <div className="max-w-5xl mx-auto py-20 text-center text-xl">
            Loading
          </div>
        ) : message ? (
          <div className="max-w-5xl mx-auto py-20 text-center text-xl">
            {message}
          </div>
        ) : (
          <div className="max-w-5xl px-5 md:px-0 mx-auto">
            <div className="flex my-4 justify-end">
              <div className="grid grid-cols-3 md:grid-cols-5 gap-1">
                {Object.values(colorMap).map((color, i) => {
                  return (
                    <div
                      key={color.name}
                      className="flex items-center mr-2 cursor-pointer select-none"
                    >
                      <Seat colors={color} className="w-8 h-6 mb-0 md:mb-0" />
                      <p className="text-sm">{color.name}</p>
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="bg-[#09192C] flex flex-col-reverse my-4 md:flex-row">
              <div className="md:w-1/4 mt-3 md:mt-0">
                <h3 className="text-2xl">Your Selected Seats</h3>
                <p className="my-2">{selectedSeats.length} seats</p>
                <div className="flex w-full flex-wrap">
                  {selectedSeats.map((seat, i) => {
                    return (
                      <div
                        key={seat.id}
                        className="text-[#AF9A54] bg-[#142F4D] px-2.5 py-0.5 mr-2 mb-2 rounded-md"
                      >
                        {String.fromCharCode(65 + seatsGrid.length - seat.row) +
                          seat.number}
                      </div>
                    );
                  })}
                </div>
                <div className="my-5">
                  <button
                    className="bg-[#C6AA55] hover:opacity-90 w-full mb-2 text-[#110A02] font-bold py-3 text-md rounded-md"
                    onClick={onReserve}
                  >
                    Reserve
                  </button>
                  <button
                    className="bg-[#E56E7F]  hover:opacity-90 w-full text-[#110A02] font-bold py-3 text-md rounded-md"
                    onClick={onPurchase}
                  >
                    Purchase
                  </button>
                </div>
              </div>
              <div className="flex-1 flex flex-col justify-center items-center">
                {seatsGrid.map((row, rowIndex) => {
                  return (
                    <div className="flex flex-row" key={rowIndex}>
                      <div className="flex w-10 h-10 justify-center items-center text-center">
                        {String.fromCharCode(64 + seatsGrid.length - rowIndex)}
                      </div>
                      {row.map((cell, columnIndex) => {
                        const colors = getColor(cell.status);
                        return (
                          <Seat
                            onGridClick={() => {
                              onGridClick(rowIndex, columnIndex);
                            }}
                            colors={colors}
                            columnIndex={cell.number}
                            key={cell.id}
                          />
                        );
                      })}
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
};

export default ShowPage;

export const getServerSideProps = async ({ params, res }) => {
  const movieId = params.id;
  const { data: movie, error } = await supabase
    .from("movies")
    .select("*")
    .eq("id", movieId)
    .single();

  if (error) {
    console.log(error);
  }

  const { data: cinemas, error: cinemaerr } = await supabase
    .from("cinemas")
    .select(`id, name, address`);

  if (cinemaerr) {
    console.log(error);
  }
  // console.log(cinemas)
  //   const { data, error } = await supabase
  //     .from("screenings")
  //     .select(
  //       `
  //         id,
  //         start_time,
  //         movie:movie_id (id, name, release_date, trailer, banner, description, length ),
  //         cinema:cinema_id (id, name, address),
  //         booking:bookings!bookings_screening_id_fkey (id, seat_id, status),
  //         auditorium:auditorium_id ( id, name, rows, columns, seat:seats!seats_auditorium_id_fkey (id, row, number, available) )
  //       `
  //     )
  //     .eq("id", screeningId)
  //     .single();

  //   if (error) {
  //     console.log(error);
  //     res.statusCode = 404
  //     res.end();
  //     return {
  //       error: "Not found"
  //     }
  //   }
  //   // console.log(data)

  //   const bookingObj = {};
  //   data.booking = data.booking || []

  //   for (let i = 0; i < data.booking.length; i++) {
  //     bookingObj[data.booking[i].seat_id] = data.booking[i];
  //   }

  //   data.booking = bookingObj;
  return {
    props: {
      cinemas,
      movie,
      // screening: data,
    },
  };
};
