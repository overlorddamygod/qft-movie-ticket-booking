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
        <div className="text-5xl py-2 cursor-pointer">QFT</div>
      </Link>
      {session?.user ? (
        <div className="flex justify-end">
          {/* <div className="text-2xl">{session.user.name}</div> */}
          <div className="text-xl mr-2">{session.user.email}</div>
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
