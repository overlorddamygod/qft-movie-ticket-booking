import Head from "next/head";
import BookedTicket from "../../../components/BookedTicket";
import Layout from "../../../components/Layout";
import { ssrAxiosClient } from "../../../utils/axiosClient";
// import ProtectedRoute from "../../../components/ProtectedRoute";
// import { useRouter } from "next/router";

const Bookings = ({ bookings }) => {
  // const session = useSelector(getSession);

  // useEffect(() => {
  //   if (session.id != "" || session.id != null) getBookings();
  // }, [session]);

  return (
    // <ProtectedRoute router={router}>
    <Layout>
      <Head>
        <title>QFT | My Tickets</title>
      </Head>
      <div className="text-4xl mb-1">My Tickets</div>
      <div className="py-2">
        {bookings.length > 0 ? (
          bookings.map((booking) => {
            return <BookedTicket key={booking.id} booking={booking} />;
          })
        ) : (
          <div>No tickets found</div>
        )}
      </div>
    </Layout>
    // </ProtectedRoute>
  );
};

export default Bookings;

export const getServerSideProps = async ({ req }) => {
  const accessToken = req.cookies["authToken"];
  try {
    const {
      data: { data: bookings },
    } = await ssrAxiosClient.get("/transaction", {
      headers: {
        Authorization: `${accessToken}`,
      },
    });
    return {
      props: {
        bookings,
        error: false,
      },
    };
  } catch (err) {
    console.error(err);

    return {
      props: {
        booking: null,
        error: true,
      },
    };
  }
};
