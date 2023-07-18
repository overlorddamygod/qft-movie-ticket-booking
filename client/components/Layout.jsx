import axios from "axios";
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import { setSession } from "../store/slices/sessionSlice";
import client from "../utils/goAuth";
import Header from "./Header";

function Layout({ auto = true, showNavs = true, children }) {
  const dispatch = useDispatch();

  useEffect(() => {
    // console.log(supabase.auth.session())
    // dispatch(setSession(supabase.auth.session()));
    // console.log(supabase.auth.session())
    const listener = async (user) => {
    
      // if (user) {
      //   dispatch(setSession(user));
      // }
      // console.log("AUTH CHANGED", user, client);
      dispatch(setSession(user));

      if (!user) {
        const expires = new Date(0).toUTCString();
        document.cookie = `authToken=; path=/; expires=${expires}; SameSite=Lax; secure`
      } else {
        const maxAge = 100 * 365 * 24 * 60 * 60 // 100 years, never expires
        document.cookie = `authToken=${client.accessToken}; path=/; expires=${maxAge}; SameSite=Lax; secure`
      }
    };
    client.onAuthChanged(listener);
    // supabase.auth.onAuthStateChange((_event, session) => {
    //   console.log("AUTHCHANGED", session)
    //   dispatch(setSession(session));
    // });
    return () => {
      console.log("REMOVING LISTENER");
      client.removeListener(listener);
    };
  }, []);

  return (
    <div
      className={`${auto ? "max-w-xl mx-auto md:max-w-5xl px-5 md:px-0" : ""}`}
    >
      <header
        className={`${
          !auto
            ? "max-w-xl mx-auto md:max-w-5xl px-5 md:px-0 flex justify-between items-center"
            : "flex justify-between items-center"
        }`}
      >
        <Header showNavs={showNavs} />
      </header>
      {children}
    </div>
  );
}

export default Layout;
