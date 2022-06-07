import { useEffect } from "react";
import { useDispatch } from "react-redux";
import { setSession } from "../store/slices/sessionSlice";
import { supabase } from "../utils/supabaseClient";
import Header from "./Header";

function Layout({ auto = true, children }) {
  const dispatch = useDispatch();

  useEffect(() => {
    // console.log(supabase.auth.session())
    dispatch(setSession(supabase.auth.session()));
    // console.log(supabase.auth.session())

    supabase.auth.onAuthStateChange((_event, session) => {
      dispatch(setSession(session));
    });
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
        <Header />
      </header>
      {children}
    </div>
  );
}

export default Layout;
