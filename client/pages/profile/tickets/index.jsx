import React, { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import BookedTicket from "../../../components/BookedTicket";
import Layout from "../../../components/Layout";
import Spinner from "../../../components/Spinner";
import { getSession } from "../../../store/slices/sessionSlice";
import axios from "../../../utils/axiosClient";
import Head from "next/head";
import ProtectedRoute from "../../../components/ProtectedRoute";
import { useRouter } from "next/router";

const Bookings = () => {
  const router = useRouter();
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
      <ProtectedRoute router={router}>
    <Layout>
      <Head>
        <title>QFT | My Tickets</title>
      </Head>
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
    </ProtectedRoute>
  );
};

export default Bookings;
