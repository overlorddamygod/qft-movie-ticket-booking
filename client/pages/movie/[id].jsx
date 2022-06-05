import Link from "next/link";
import { useState, useEffect, useMemo } from "react";
import Router, { useRouter } from "next/router";
import { supabase } from "../../utils/supabaseClient";
import { Seat, colorMap, getColor } from "../../components/SeatsSetup";
import Layout from "../../components/Layout";
import Banner from "../../components/Banner";
import Payment from "../../components/Payment";
import moment from "moment";
import Head from "next/head";
import axiosClient from "../../utils/axiosClient";
import Countdown from "../../components/Countdown";
import AuthGuard from "../../components/AuthGuard";
import { Elements, CardElement } from "@stripe/react-stripe-js";
import { loadStripe } from "@stripe/stripe-js";
import SeatTag from "../../components/SeatTag";

const stripePromise = loadStripe(
  "pk_test_51L6teVLq5jVwlbtcevCzKQeNuzEE8dMzMubWk0vJegT64E9aDdPTohBlN4cyLLkHciEdMrykFcJPHz8m2HuFoVN900oBQxqx9v"
);

const ShowPage = ({ movie, cinemas }) => {
  const [seatsGrid, setSeatsGrid] = useState([[]]);
  const [selectedSeats, setSelectedSeats] = useState([]);
  const [dates, setDates] = useState([]);
  const [selectedDate, setSelectedDate] = useState(0);
  const [selectedCinemaId, setSelectedCinemaId] = useState(
    cinemas.length > 0 ? cinemas[0].id : 0
  );
  const [selectedScreeningId, setSelectedScreeningId] = useState("");
  const [message, setMessage] = useState();
  const [loading, setLoading] = useState(true);
  const [screenings, setScreenings] = useState({});
  const [screening, setScreening] = useState({});
  const [sessionExpiresAt, setSessionExpiresAt] = useState(null);
  const [fromQuery, setFromQuery] = useState(false);
  const [purchasing, setPurchasing] = useState(false);
  const [transaction, setTransaction] = useState({});

  useEffect(() => {
    const now = moment();
    const _dates = [];

    for (let i = 0; i < 6; i++) {
      const date = now.clone().add(i, "d");
      _dates.push(date);
    }

    setDates(_dates);

    console.log("BEGINNING");
    console.log(supabase.auth);

    const { query } = Router;
    console.log(query);
    const queries = ["date", "date_index", "cinema_id", "screening_id"];
    console.log(queries.every((q) => Object.keys(query).includes(q)));
    if (queries.every((q) => Object.keys(query).includes(q))) {
      console.log("FOUND QUERY");
      setSelectedDate(+query.date_index);
      setSelectedCinemaId(query.cinema_id);
      console.log(query);
      setFromQuery(true);
      setSelectedScreeningId(query.screening_id);
      // getScreeningById(query.screening_id)
    } else {
      console.log("NO QUERY");
      setSelectedDate(0);
      const q = {
        date_index: 0,
        date: _dates[0].format("YYYY-MM-DD"),
      };
      if (cinemas.length > 0) {
        setSelectedCinemaId(cinemas.length > 0 ? cinemas[0].id : 0);
        q["cinema_id"] = cinemas[0].id;
      }
      updateQuery(q);
    }
    return () => {
      setDates((dates) => []);
    };
  }, []);

  const updateQuery = (keyVal) => {
    for (let key in keyVal) {
      keyVal[key] = encodeURI(keyVal[key]);
    }

    Router.push(
      {
        pathname: Router.pathname,
        query: {
          ...Router.query,
          ...keyVal,
        },
      },
      undefined,
      { scroll: false }
    );
  };

  useEffect(() => {
    console.log("LOLLLL", selectedScreeningId);
    if (selectedScreeningId == "") return;

    setSelectedSeats([]);
    console.log("FETCHING SCREENING FOR ID", selectedScreeningId);
    getScreeningById(selectedScreeningId);
  }, [selectedScreeningId]);

  useEffect(() => {
    // setLoading(true)
    setPurchasing(false);
    if (Object.keys(screening).length == 0) return;

    console.log("FOUND SCREENING FOR ID", selectedScreeningId);
    console.log("SCREENING", screening);

    updateQuery({
      screening_id: selectedScreeningId,
    });

    const grid = Array(screening.auditorium.rows)
      .fill(null)
      .map(() => Array(screening.auditorium.columns).fill(1));

    for (let seat of screening.auditorium.seats) {
      grid[seat.row - 1][seat.number - 1] = seat;
    }
    setSelectedSeats(screening.auditorium.selected_seats);

    setSeatsGrid(grid);
    // setLoading(false)
  }, [screening]);

  // console.log(transaction)

  const getScreeningById = async (id, getSession = true) => {
    // setLoading(true)
    axiosClient
      .get(`api/v1/screening/${id}?transaction=1`, {
        headers: {
          Authorization: `${supabase.auth.currentSession?.access_token || " "}`,
        },
      })
      .then((res) => {
        const { data } = res.data

        setScreening(data["screening"]);
        if (getSession) {
          setTransaction({
            id: data["transaction"].id,
            expires_at: new Date(data["transaction"].expires_at).getTime() / 1000,
          });
        }
      })
      .catch((err) => {
        console.error(err);
      }).finally(() => {
        // setLoading(false)
        });
  };

  const onGridClick = async (rowIndex, columnIndex) => {
    if (purchasing) {
      alert("Currently on payment page. Please finish or cancel payment before selecting seats.");
      return
    }
    const response = axiosClient
      .post(
        "api/v1/booking",
        {
          user_id: supabase.auth.currentUser.id,
          seat_id: seatsGrid[rowIndex][columnIndex].id,
          screening_id: screening.id,
          auditorium_id: screening.auditorium.id,
        },
        {
          headers: {
            Authorization: `${supabase.auth.currentSession.access_token}`,
          },
        }
      )
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
        getScreeningById(selectedScreeningId, false);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  useEffect(() => {
    console.log(selectedDate, dates, selectedCinemaId);
    if (dates.length == 0) return;

    setTransaction(null);
    console.log("GETTING SCREENIGNS", dates, selectedDate, selectedCinemaId);
    // onDateSelected();
    getScreenings(
      movie.id,
      selectedCinemaId,
      dates[selectedDate].format("YYYY-MM-DD")
    );
    return () => {};
  }, [dates, selectedDate, selectedCinemaId]);

  const getScreenings = (movie_id, cinema_id, date, setScreeningId = true) => {
    setLoading(true);
    setMessage("");
    setScreenings({});
    if (!fromQuery) {
      setSelectedScreeningId("");
    }

    if (fromQuery) {
      setFromQuery(false);
    }

    const url = `api/v1/screening?movie_id=${movie_id}&cinema_id=${cinema_id}`;

    if (date) {
      url += `&date=${date}`;
    }
    axiosClient
      .get(url, {
        headers: {
          Authorization: `${supabase.auth.currentSession?.access_token || " "}`,
        },
      })
      .then((res) => {
        const { data } = res.data;
        console.log("SAD", res.data.data, fromQuery);
        console.log("FROM", fromQuery);

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

        setScreenings(res.data.data);

        if (!fromQuery) {
          if (setScreeningId) {
            setSelectedScreeningId(data[0].id);
          }
          if (fromQuery) {
            setFromQuery(false);
          }
        }
        // console.log("FROM",fromQuery)
        // if (setScreeningId) {
        //   console.log("SELECTED", data[0].id)
        //   setSelectedScreeningId(data[0].id);
        //   // updateQuery({
        //   //   screening_id: data[0].id,
        //   // })
        // }
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        setMessage("Error");
        setLoading(false);
      });
  };

  const seatsData = useMemo(() => {
    return selectedSeats.reduce(
      (acc, seat) => {
        const pascalCase = seat.type[0].toUpperCase() + seat.type.slice(1);

        if (pascalCase in acc.types) {
          acc.types[pascalCase] = {
            count: acc.types[pascalCase].count + 1,
            price: acc.types[pascalCase].price + seat.price,
          };
        } else {
          acc.types[pascalCase] = {
            count: 1,
            price: seat.price,
          };
        }
        acc.total.price += seat.price;
        acc.total.count += 1;
        return acc;
      },
      {
        total: {
          count: 0,
          price: 0,
        },
        types: {},
      }
    );
  }, [selectedSeats]);

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
                        });
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
                    value={selectedScreeningId}
                    onChange={(e) => {
                      console.log("SELECTEDDDD", e.target.value, e.target);
                      setSelectedScreeningId(e.target.value);
                      updateQuery({
                        screening_id: e.target.value,
                      });
                    }}
                  >
                    {Object.keys(screenings).length == 0 && (
                      <option value="none">None</option>
                    )}
                    {Object.entries(screenings).map(
                      ([id, screening], index) => {
                        return (
                          <option key={screening.id} value={screening.id}>
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
                        cinema_id: event.target.value,
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
        <AuthGuard>
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
              <div className="flex justify-center my-4">
                {transaction?.expires_at && (
                  <Countdown eventTime={transaction.expires_at} interval={1000} />
                )}
              </div>
              <div className="flex my-4 justify-end">
                <div className="grid grid-cols-3 md:grid-cols-6 gap-1">
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
                      return <SeatTag key={seat.id} seat={seat} noRows={seatsGrid.length} />
                    })}
                  </div>

                  <div className="mt-3">
                    {Object.entries(seatsData.types).map(([type, val], i) => {
                      return (
                        <div key={type} className="flex justify-between">
                          <div>{type}</div>
                          <div>{val.count}</div>
                          <div>{val.price}</div>
                        </div>
                      );
                    })}
                    <div className="h-px my-2 bg-slate-600"></div>
                    <div className="flex justify-between">
                      <div>{"Total"}</div>
                      <div>Nrs. {seatsData.total.price}</div>
                    </div>
                  </div>
                  <Elements stripe={stripePromise}>
                    <div className="my-5">

                      {!purchasing ? <button
                        className="bg-[#E56E7F]  hover:opacity-90 w-full text-[#110A02] font-bold py-3 text-md rounded-md"
                        onClick={()=> {
                          if (selectedSeats.length > 0)
                          setPurchasing(true)
                        }}
                      >
                        Purchase
                      </button>:
                      <Payment onCancel={()=> {
                        setPurchasing(false)
                      }} data={{
                        transactionId: transaction.id,
                        amount: seatsData.total.price,
                      }} onSuccess={() => {
                        getScreeningById(selectedScreeningId, false);
                      }}/>}
                    </div>
                  </Elements>
                </div>
                <div className="flex-1 flex flex-col justify-center items-center">
                  {seatsGrid.map((row, rowIndex) => {
                    return (
                      <div className="flex flex-row" key={rowIndex}>
                        <div className="flex w-10 h-10 justify-center items-center text-center">
                          {String.fromCharCode(
                            64 + seatsGrid.length - rowIndex
                          )}
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
        </AuthGuard>
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
  return {
    props: {
      cinemas,
      movie,
    },
  };
};
