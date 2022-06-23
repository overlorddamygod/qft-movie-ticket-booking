import Head from "next/head";
import Link from "next/link";
import Router from "next/router";
import EmailPasswordForm from "../components/EmailPasswordForm";
import Layout from "../components/Layout";
import client from "../utils/goAuth";

export default function Auth() {
  const handleSignUp = async (email, password) => {
    try {
      const { error } = await client.signUp(email, "test12345", password);
      if (error) throw error;
      setTimeout(() => {
        Router.push("/signin");
      }, 1000);
      return "Successfully signed up. Please sign in!";
    } catch (error) {
      return error || error.error_description || error.message;
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
