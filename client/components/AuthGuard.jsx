import Link from "next/link";
import { useSelector } from "react-redux";
import { getSession } from "../store/slices/sessionSlice";

export default function AuthGuard({ children }) {
  const session = useSelector(getSession);

  return (
    <div>
      {!session ? (
        <div className="max-w-5xl mx-auto py-20 text-center text-xl">
          Requires Authentication Please{" "}
          <Link href="/signin" legacyBehavior>
            <span className="text-blue-500 cursor-pointer hover:underline">
              sign in.
            </span>
          </Link>
        </div>
      ) : (
        children
      )}
    </div>
  );
}
