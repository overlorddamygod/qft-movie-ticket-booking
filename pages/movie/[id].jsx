import Link from "next/link";
import { useState, useEffect } from "react";
import { useRouter } from "next/router";
import { supabase } from "../../utils/supabaseClient";
import { Seat, colorMap, getColor } from "../../components/SeatsSetup";
import Layout from "../../components/Layout";
import Banner from "../../components/Banner";
import moment from "moment";

const ShowPage = ({ movie,cinemas }) => {
  const [seatsGrid, setSeatsGrid] = useState([[]]);
  const [selectedSeats, setSelectedSeats] = useState([]);
  const [seatIdToGridMap, setSeatIdToGridMap] = useState({});
  const [dates, setDates] = useState([]);
  const [selectedDate, setSelectedDate] = useState(0);
  const [selectedCinemaId, setSelectedCinemaId] = useState(cinemas.length > 0 ? cinemas[0].id : 0);
  const [selectedTime, setSelectedTime] = useState("");
  const [message, setMessage] = useState()
  const [loading, setLoading] = useState(true);
  const [screenings, setScreenings] = useState({});

  console.log(selectedCinemaId)
  useEffect(() => {
    const screening = screenings[selectedTime]
    if (!screening) {
      // setSelectedSeats(screening.seats);
      return
    }
    // const now = moment()
    // setDates(dates => [...dates, now])
    // for (let i = 0; i < 5; i++) {
    //   const date = now.clone().add(i+1, 'd')
    //   setDates(dates => [...dates, date])
    // }
    // console.log(now.format("MMM-DD-ddd"))
    // console.log(now)
    const grid = Array(screening.auditorium.rows)
      .fill(null)
      .map(() => Array(screening.auditorium.columns).fill(1));

    const gridMap = {};

    for (let seat of screening.auditorium.seat) {
      seat.status = seat.available ? 1 : 0;
      if (screening.booking[seat.id]) {
        seat.status = screening.booking[seat.id].status;
      }

      grid[seat.row - 1][seat.number - 1] = seat;
      gridMap[seat.id] = grid[seat.row - 1][seat.number - 1];
    }
    setSeatIdToGridMap(gridMap);
    // console.log(gridMap)

    setSeatsGrid(grid);
    // console.log(`bookings:screening_id=eq.${screening.id}`)
    const bookings = supabase
      .from(`bookings:screening_id=eq.${screening.id}`)
      .on("INSERT", (payload) => {
        console.log("Change received!", payload);
        const { new: newBooking } = payload;
        // ))
      })
      .subscribe();

    return () => {
      bookings.unsubscribe();
    };
  }, [selectedTime]);

  useEffect(() => {
    const now = moment();
    setDates((dates) => [...dates, now]);
    for (let i = 0; i < 5; i++) {
      const date = now.clone().add(i + 1, "d");
      setDates((dates) => [...dates, date]);
    }

    return () => {
      setDates((dates) => []);
    };
  }, []);

  const onGridClick = (rowIndex, columnIndex) => {
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
  };

  const onPurchase = async () => {
    console.log(selectedSeats);
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
    const screening = screenings[selectedTime]
    if (!screening) {
      return
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
   
    onDateSelected()
    return () => {
      
    }
  }, [dates, selectedDate, selectedCinemaId])

  const onDateSelected = async () => {
    setLoading(true)
    setMessage("")
    setScreenings({})
    const d = dates[selectedDate]
    if (!d) {
      setLoading(false)
      return
    }
    console.log(d.toString())
    const {data, err} = await supabase.from("screenings").select(`
      id,
      start_time,
      movie:movie_id (id, name, release_date, trailer, banner, description, length ),
      cinema:cinema_id (id, name, address),
      booking:bookings!bookings_screening_id_fkey (id, seat_id, status),
      auditorium:auditorium_id ( id, name, rows, columns, seat:seats!seats_auditorium_id_fkey (id, row, number, available) )
    `).eq("movie_id", movie.id)
      .eq("cinema_id", selectedCinemaId)
      .lt('start_time', d.endOf('day').toDate().toISOString())
      .gt('start_time', d.startOf('day').toDate().toISOString())
    if (err) {
      console.log(err)
    }
    if (data.length === 0) {
      // setScreenings([])
      setMessage("No screenings at this date")
      setLoading(false)
      return
    }

    const obj = {}

    for (let i = 0; i < data.length; i++) {
      const screening = data[i]
      obj[screening.id] = screening
    }

    
    setScreenings(obj)
    setSelectedTime(data[0].id)

    setLoading(false)
  }


  return (
    <Layout auto={false}>
      <div>
        <div className="flex items-center max-w-5xl mx-auto my-8">
          <Banner src={movie.banner} alt={movie.name} />
          <div className="ml-12">
            <h1 className="text-4xl">{movie.name}</h1>
            <p className="mt-2">
              🕗 {movie.length} mins{" "}
              <span className="ml-3 ">
                {new Date(movie.release_date).getFullYear()}
              </span>
            </p>
            <p className="my-3 text-sm text-[#455B77]">
              {movie.description}
            </p>
            <Link href={movie.trailer}><button className="border-[#C6AA55] border-2 py-2 px-2 mt-4 rounded-md hover:scale-105">Watch Trailer</button></Link>
            {/* <h2>{screening.auditorium.name}</h2> */}
          </div>
        </div>

        <div className="bg-[#0B2039] h-24">
          <div className="flex max-w-5xl mx-auto h-full">
            <div className="flex-1 flex">
              <div className="flex items-center mr-4">
                <div className="text-2xl">Date</div>
              </div>
              <div className="flex">
                {dates.map((d, index) => {
                  const formatetd = d.format("MMM-DD-ddd").split("-");
                  return (
                    <div key={index} className="flex" onClick={() => {
                      setSelectedDate(index);
                    }}>
                      <div className="flex justify-center items-center text-white hover:bg-[#1A427C] select-none cursor-pointer" style={{
                        background: selectedDate == index ? "#1A427C" : "",
                      }}>
                        <div className="px-6 flex flex-col justify-center items-center">
                          <div className="text-sm">{formatetd[0]}</div>
                          <div className="text-2xl">{formatetd[1]}</div>
                          <div className="text-sm">{formatetd[2]}</div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
            <div className="w-1/5 flex flex-col justify-center">
              <div className="text-2xl">Time</div>
              <div>
                <select id="time" className="bg-transparent text-[#455B77] mt-1 text-lg w-full" onChange={
                  (e) => {
                    setSelectedTime(e.target.value)
                  }
                }>
                  {Object.keys(screenings).length == 0 && <option value="none">None</option>}
                  {Object.entries(screenings).map(([id, screening], index) => {
                    return (
                      <option key={id} value={id} selected={index == 0}>
                        {moment(screening.start_time).format('LT')}
                      </option>
                    );
                  }
                  )}
                </select>
              </div>
            </div>
            <div className="w-10 flex justify-center items-center">
              <div className="w-0.5 h-3/4 bg-[#17283D]"></div>
            </div>
            <div className="w-1/5 flex flex-col justify-center">
              <div className="text-2xl">Cinema</div>
              <div>
                <select className="bg-transparent text-[#455B77] mt-1 text-lg w-full" onChange={() => {
                  setSelectedCinemaId(event.target.value)
                }}>
                  {cinemas.map((cinema, index) => {
                    return <option selected={index == 0} key={cinema.id} value={cinema.id}>{cinema.name}</option>
                  })}
                </select>
              </div>
            </div>
          </div>
        </div>

        { loading ? <div className="max-w-5xl mx-auto py-20 text-center text-xl">Loading</div> : 
          message ? <div className="max-w-5xl mx-auto py-20 text-center text-xl">{message}</div> :
          <div className="max-w-5xl mx-auto">
          <div className="flex my-4 justify-end">
            {Object.values(colorMap).map((color, i) => {
              return (
                <div
                  key={color.name}
                  className="flex items-center mr-2 cursor-pointer select-none"
                >
                  <Seat colors={color} />
                  <p>{color.name}</p>
                </div>
              );
            })}
          </div>

          <div className="bg-[#09192C] flex my-4">
            <div className="w-1/4">
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
}
      </div>
    </Layout>
  );
};

export default ShowPage;

export const getServerSideProps = async ({params, res}) => {

  const movieId = params.id;
  const { data: movie, error } = await supabase
    .from("movies")
    .select("*")
    .eq("id", movieId)
    .single();

  if (error) {
    console.log(error);
  }

  const { data: cinemas, error: cinemaerr } = await supabase.from("cinemas").select(`id, name, address`)

  if (cinemaerr) {
    console.log(error)
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
