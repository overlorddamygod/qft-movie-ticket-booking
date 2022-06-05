import React from "react";
import { useSelector } from "react-redux";
import { getSession } from "../../store/slices/sessionSlice";
import LayoutWithProvider from "../../components/Layout";
import Link from "next/link";

const Profile = () => {
  const session = useSelector(getSession);
  console.log(session)
  return (
    <LayoutWithProvider>
      <div>Profile</div>
      <div>Email: {session?.user.email}</div>
    </LayoutWithProvider>
  );
};

export default Profile;
