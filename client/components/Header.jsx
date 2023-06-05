import Link from "next/link";
import { useSelector } from "react-redux";
import { getSession } from "../store/slices/sessionSlice";
import client from "../utils/goAuth";

const Header = ({ showNavs = true }) => {
  const session = useSelector(getSession);

  const signOut = () => {
    client.signOut();
  };

  return <>
    <Link href="/" className="text-5xl py-2 cursor-pointer">
      QFT
    </Link>
    {showNavs &&
      (session ? (
        <div className="flex justify-end items-center">
          {/* <div className="text-2xl">{session.user.name}</div> */}
          <Link
            href="/profile/tickets"
            className="text-md md:text-xl mr-3 hover:underline cursor-pointer">

            {"My Tickets"}

          </Link>
          <Link
            href="/profile"
            className="text-md md:text-xl mr-3 hover:underline cursor-pointer">

            {"My Profile"}

          </Link>
          <div
            className="bg-[#E56E7F] hover:opacity-90 text-white font-bold py-1 px-2 text-md rounded-md cursor-pointer"
            onClick={signOut}
          >
            Sign Out
          </div>
        </div>
      ) : (
        <Link href="/signin" legacyBehavior>
          <div className="bg-[#E56E7F] hover:opacity-90 text-white font-bold py-1 px-2 text-md rounded-md cursor-pointer">
            Sign In
          </div>
        </Link>
      ))}
  </>;
};

export default Header;
