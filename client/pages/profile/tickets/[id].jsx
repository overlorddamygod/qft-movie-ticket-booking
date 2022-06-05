import React, { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import { getSession } from "../../../store/slices/sessionSlice";
import Layout from "../../../components/Layout";
import axios from "../../../utils/axiosClient";
import { useRouter } from 'next/router'
import BookedTicket from "../../../components/BookedTicket";
import Spinner from "../../../components/Spinner";

const Bookings = () => {
  const router = useRouter()
  const session = useSelector(getSession);
  const [booking, setBooking] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (session?.access_token && router.query.id) {
      console.log("HERE")
      getBooking()
    }
  }, [session, router.query.id]);

  const getBooking = async () => {
    try {
      const res = await axios.get("/api/v1/transaction/"+router.query.id, {
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
    <Layout>
       {loading ? <Spinner/> : (booking ? <BookedTicket booking={booking}/> :  <p>No booking found</p>)}
    </Layout>
  );
};

export default Bookings;
