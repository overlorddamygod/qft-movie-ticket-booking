import { useState } from "react";
import { supabase } from "../utils/supabaseClient";
import Layout from "../components/Layout";
import Spinner from "../components/Spinner";

export default function Auth() {
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleSignin = async (email) => {
    try {
      setLoading(true);
      const { error } = await supabase.auth.signIn({ email });
      if (error) throw error;
      setMessage("Check your email for the login link!");
    } catch (error) {
      setMessage(error.error_description || error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div className="row flex flex-center justify-center items-center h-64">
        <form className="w-full max-w-sm text-center">
          <h2 className="text-3xl">Sign in via Magic Link.</h2>
          <h3 className="my-6 text-red-500">{message}</h3>
          <div className="md:flex md:items-center mb-6">
            <input
              className="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
              value={email}
              placeholder={"Enter your email"}
              onChange={(e) => setEmail(e.target.value)}
              type="email"
            />
          </div>
          <div className="flex justify-center">
            {loading ? (
              <Spinner />
            ) : (
              <button
                className="shadow bg-purple-500 hover:bg-purple-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
                type="button"
                onClick={(e) => {
                  e.preventDefault();
                  handleSignin(email);
                }}
              >
                Sign In
              </button>
            )}
          </div>
        </form>
      </div>
    </Layout>
  );
}
