import Head from "next/head";
import Link from "next/link";
import Router from "next/router";
import EmailPasswordForm from "../components/EmailPasswordForm";
import Layout from "../components/Layout";
import client from "../utils/goAuth";

export default function Auth() {
  const handleSignin = async (email, password) => {
    try {
      const { error } = await client.signInWithEmail(email, password);
      if (error) throw error;
      Router.push("/");
      return "Successfully signed in";
    } catch (error) {
      return error || error.error_description || error.message;
    }
  };

  return (
    <Layout showNavs={false}>
      <Head>
        <title>QFT | Sign In</title>
      </Head>
      <div className="row flex flex-col flex-center justify-center items-center h-64">
        <EmailPasswordForm
          onSubmit={(email, password) => {
            return handleSignin(email, password);
          }}
          title={"Sign in to your account"}
          buttonTitle={"Sign In"}
        />

        <div className="my-5">
          {"Don't have an account? "}
          <Link href="/signup">
            <button className="shadow ml-2 bg-emerald-500 hover:bg-emerald-400 focus:shadow-outline focus:outline-none text-white font-bold py-0.5 px-1 rounded">
              Sign Up
            </button>
          </Link>
        </div>
      </div>
    </Layout>
  );
}
