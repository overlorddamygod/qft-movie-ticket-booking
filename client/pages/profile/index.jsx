import React from "react";
import { useSelector } from "react-redux";
import { getSession } from "../../store/slices/sessionSlice";
import Layout from "../../components/Layout";
import Head from "next/head";
import ProtectedRoute from "../../components/ProtectedRoute";
import { useRouter } from "next/router";

const Profile = () => {
  const router = useRouter();
  const session = useSelector(getSession);
  return (
    <ProtectedRoute router={router}>
      <Layout>
        <Head>
          <title>QFT | My Profile</title>
        </Head>
        <div>Profile</div>
        <div>Email: {session?.user.email}</div>
      </Layout>
    </ProtectedRoute>
  );
};

export default Profile;
