import Head from "next/head";
import Link from "next/link";
import Router from "next/router";
import EmailPasswordForm from "../components/EmailPasswordForm";
import Layout from "../components/Layout";
import { supabase } from "../utils/supabaseClient";

export default function Auth() {
  const handleSignUp = async (email, password) => {
    try {
      const { error } = await supabase.auth.signUp({ email, password });
      if (error) throw error;
      Router.push("/");
      return "Successfully signed up and logged in!";
    } catch (error) {
      return error.error_description || error.message;
    }
  };

  return (
    <Layout showNavs={false}>
      <Head>
        <title>QFT | Sign Up</title>
      </Head>
      <div className="row flex flex-center justify-center items-center h-64 flex-col">
        <EmailPasswordForm
          onSubmit={(email, password) => {
            return handleSignUp(email, password);
          }}
          title={"Create an account"}
          buttonTitle={"Sign Up"}
        />
        <div className="my-5">
          {"Already have an account? "}
          <Link href="/signin">
            <button className="shadow ml-2 bg-emerald-500 hover:bg-emerald-400 focus:shadow-outline focus:outline-none text-white font-bold py-0.5 px-1 rounded">
              Sign In
            </button>
          </Link>
        </div>
      </div>
    </Layout>
  );
}
