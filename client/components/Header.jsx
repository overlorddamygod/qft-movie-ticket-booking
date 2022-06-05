import React from "react";
import Link from "next/link";
import { useSelector } from "react-redux";
import { getSession } from "../store/slices/sessionSlice";
import { supabase } from "../utils/supabaseClient";

const Header = () => {
  const session = useSelector(getSession);

  const signOut = () => {
    supabase.auth.signOut()
  };

  return (
    <>
      <Link href="/">
        <a className="text-5xl py-2 cursor-pointer">QFT</a>
      </Link>
      {session?.user ? (
        <div className="flex justify-end items-center">
          {/* <div className="text-2xl">{session.user.name}</div> */}
          <Link href="/profile/tickets">
          <a className="text-md md:text-xl mr-3 hover:underline cursor-pointer" >{"My Tickets"}</a>
          </Link>
          <Link href="/profile">
          <a className="text-md md:text-xl mr-3 hover:underline cursor-pointer" >{"My Profile"}</a>
          </Link>
          <div
            className="bg-[#E56E7F] hover:opacity-90 text-white font-bold py-1 px-2 text-md rounded-md cursor-pointer"
            onClick={signOut}
          >
            Sign Out
          </div>
        </div>
      ) : (
        <Link href="/signin">
          <div className="bg-[#E56E7F] hover:opacity-90 text-white font-bold py-1 px-2 text-md rounded-md cursor-pointer">
            Sign In
          </div>
        </Link>
      )}
    </>
  );
};

export default Header;
