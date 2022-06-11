import { useState } from "react";
import Spinner from "./Spinner";

const EmailPasswordForm = ({ onSubmit, title, buttonTitle }) => {
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  return (
    <form
      className="w-full max-w-sm text-center"
      onSubmit={async (e) => {
        e.preventDefault();
        setLoading(true);
        const message = await onSubmit(email, password);
        setMessage(message);
        setLoading(false);
      }}
    >
      <h2 className="text-3xl mt-5">{title}</h2>
      <h3 className="my-3 text-red-500">{message}</h3>
      <div className="md:flex md:items-center mb-6">
        <input
          className="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
          value={email}
          placeholder={"Enter your email"}
          onChange={(e) => setEmail(e.target.value)}
          type="email"
        />
      </div>
      <div className="md:flex md:items-center mb-6">
        <input
          className="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
          value={password}
          placeholder={"Enter your password"}
          onChange={(e) => setPassword(e.target.value)}
          type="password"
        />
      </div>
      <div className="flex justify-center">
        {loading ? (
          <Spinner />
        ) : (
          <button
            className="shadow bg-purple-500 hover:bg-purple-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
            type="submit"
          >
            {buttonTitle}
          </button>
        )}
      </div>
    </form>
  );
};

export default EmailPasswordForm;
