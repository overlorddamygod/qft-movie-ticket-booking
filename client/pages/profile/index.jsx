import Head from "next/head";
import { useSelector } from "react-redux";
import Layout from "../../components/Layout";
import { getSession } from "../../store/slices/sessionSlice";
// import ProtectedRoute from "../../components/ProtectedRoute";
// import { useRouter } from "next/router";

const Profile = () => {
  // const router = useRouter();
  const session = useSelector(getSession);
  return (
    // <ProtectedRoute router={router}>
    <Layout>
      <Head>
        <title>QFT | My Profile</title>
      </Head>
      <div>Profile</div>
      <div>Email: {session?.email}</div>
    </Layout>
    // </ProtectedRoute>
  );
};

export default Profile;
