import { useEffect } from "react";
import { useSelector } from "react-redux";
import { getSession } from "../store/slices/sessionSlice";

const ProtectedRoute = ({children, router}) => {
  const session = useSelector(getSession);

  useEffect(() => {
    if (!session?.user) {
      router.replace("/signin", null, { shallow: true });
    }
  }, [])

  if (session?.user) {
    return children;
  }
  return null
}

export default ProtectedRoute