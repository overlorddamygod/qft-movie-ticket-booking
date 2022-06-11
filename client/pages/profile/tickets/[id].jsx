import Head from "next/head";
import { useRouter } from "next/router";
import { useSelector } from "react-redux";
import BookedTicket from "../../../components/BookedTicket";
import Layout from "../../../components/Layout";
// import ProtectedRoute from "../../../components/ProtectedRoute";
import { getSession } from "../../../store/slices/sessionSlice";
import axios from "../../../utils/axiosClient";

const Bookings = ({ booking }) => {
  const router = useRouter();
  const session = useSelector(getSession);
  // const [booking, setBooking] = useState(null);
  // const [loading, setLoading] = useState(true);

  // useEffect(() => {
  //   if (session && router.query.id) {
  //     // console.log("HERE");
  //     getBooking();
  //   }
  // }, [session, router.query.id]);

  // const getBooking = async () => {
  //   try {
  //     const res = await axios.get("/api/v1/transaction/" + router.query.id, {
  //       headers: {
  //         Authorization: `${client.accessToken}`,
  //       },
  //     });
  //     setBooking(res.data.data);
  //     console.log(booking);
  //   } catch (error) {
  //     console.log(error);
  //   } finally {
  //     setLoading(false);
  //   }
  // };
  return (
    // <ProtectedRoute router={router}>
    <Layout>
      <Head>
        <title>QFT | Ticket</title>
      </Head>
      {booking ? <BookedTicket booking={booking} /> : <p>No booking found</p>}
    </Layout>
    // </ProtectedRoute>
  );
};

export default Bookings;

export const getServerSideProps = async ({ req, params }) => {
  const transactionId = params.id;
  const accessToken = req.cookies["authToken"];
  try {
    const {
      data: { data: transaction },
    } = await axios.get("/api/v1/transaction/" + transactionId, {
      headers: {
        Authorization: `${accessToken}`,
      },
    });
    return {
      props: {
        booking: transaction,
      },
    };
  } catch (err) {
    console.error(err);

    return {
      props: {
        booking: null,
      },
    };
  }
};
