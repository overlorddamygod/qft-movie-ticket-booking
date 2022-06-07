import React, { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import { getSession } from "../../../store/slices/sessionSlice";
import Layout from "../../../components/Layout";
import Link from "next/link";
import axios from "../../../utils/axiosClient";
import { supabase } from "../../../utils/supabaseClient";
import SeatTag from "../../../components/SeatTag";
import moment from "moment";
import BookedTicket from "../../../components/BookedTicket";
import Spinner from "../../../components/Spinner";

const Bookings = () => {
  const session = useSelector(getSession);
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (session?.access_token) getBookings();
  }, [session]);

  const getBookings = async () => {
    try {
      const res = await axios.get("/api/v1/transaction", {
        headers: {
          Authorization: `${session.access_token}`,
        },
      });
      setBookings(res.data.data);
      console.log(bookings);
    } catch (error) {
      console.log(error);
    } finally {
      setLoading(false);
    }
  };
  return (
    <Layout>
      <div className="text-4xl mb-1">My Tickets</div>
      <div className="py-2">
      {loading ? (
        <Spinner />
      ) : bookings.length > 0 ? (
        bookings.map((booking) => {
          return <BookedTicket key={booking.id} booking={booking} />;
        })
      ) : (
        <div>No tickets found</div>
      )}
      </div>
    </Layout>
  );
};

export default Bookings;