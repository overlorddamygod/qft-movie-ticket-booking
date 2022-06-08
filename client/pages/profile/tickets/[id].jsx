import Head from "next/head";
import { useRouter } from "next/router";
import React, { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import BookedTicket from "../../../components/BookedTicket";
import Layout from "../../../components/Layout";
import ProtectedRoute from "../../../components/ProtectedRoute";
import Spinner from "../../../components/Spinner";
import { getSession } from "../../../store/slices/sessionSlice";
import axios from "../../../utils/axiosClient";

const Bookings = () => {
  const router = useRouter();
  const session = useSelector(getSession);
  const [booking, setBooking] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (session?.access_token && router.query.id) {
      // console.log("HERE");
      getBooking();
    }
  }, [session, router.query.id]);

  const getBooking = async () => {
    try {
      const res = await axios.get("/api/v1/transaction/" + router.query.id, {
        headers: {
          Authorization: `${session.access_token}`,
        },
      });
      setBooking(res.data.data);
      console.log(booking);
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
          <title>QFT | Ticket</title>
        </Head>
        {loading ? (
          <Spinner />
        ) : booking ? (
          <BookedTicket booking={booking} />
        ) : (
          <p>No booking found</p>
        )}
      </Layout>
    </ProtectedRoute>
  );
};

export default Bookings;
