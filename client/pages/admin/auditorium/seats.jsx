import Head from "next/head";
import Layout from "../../../components/Layout";
import SeatLayoutDesign from "../../../components/SeatLayoutDesign";
import axiosClient from "../../../utils/axiosClient";

const Seats = ({ cinemas }) => {
  return (
    <Layout>
      <Head>
        <title>QFT Admin | Configure Seats</title>
      </Head>
      <SeatLayoutDesign cinemas={cinemas} />
    </Layout>
  );
};

export default Seats;
export const getServerSideProps = async () => {
  try {
    const cinemasRes = await axiosClient.get("/cinema?auditorium=1");

    const { data: cinemas } = cinemasRes.data;

    const cinemasObj = {};
    cinemas.forEach((cinema) => {
      cinemasObj[cinema.id] = cinema;
    });

    return {
      props: {
        cinemas: cinemasObj,
        error: false,
      },
    };
  } catch (err) {
    console.error(err);
    return {
      props: {
        cinemas: {},
        error: true,
      },
    };
  }
};
