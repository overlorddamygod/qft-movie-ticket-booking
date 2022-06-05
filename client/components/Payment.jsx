import { useState, useEffect } from "react";
import {
  Elements,
  CardElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import axiosClient from "../utils/axiosClient";
import { supabase } from "../utils/supabaseClient";
import Spinner from "./Spinner";
import Router, { useRouter } from "next/router";

const Payment = ({ onCancel, data, onSuccess }) => {
  const router = useRouter()
  const [isPaymentLoading, setPaymentLoading] = useState(false);
  const stripe = useStripe();
  const elements = useElements();

  const onPay = async (e) => {
    setPaymentLoading(true);
    try {
      const res = await axiosClient.post(
        "/api/v1/transaction/pay",
        {
          transaction_id: data.transactionId,
          amount: data.amount,
        },
        {
          headers: {
            Authorization: `${supabase.auth.currentSession.access_token}`,
          },
        }
      );
      // setClientSecret(res.data.data.client_secret)
      const clientSecret = res.data.data.client_secret;

      e.preventDefault();
      const paymentResult = await stripe.confirmCardPayment(clientSecret, {
        payment_method: {
          card: elements.getElement(CardElement),
          billing_details: {
            name: "Yusuff Faruq",
          },
        },
      });
      if (paymentResult.error) {
        alert(paymentResult.error.message);
        console.log(paymentResult.error.message);
      } else {
        if (paymentResult.paymentIntent.status === "succeeded") {
          // alert("Success!");
          // console.log(paymentResult);
          confirmPayment(paymentResult.paymentIntent.id);
        }
      }
    } catch (error) {
      console.log(error);
      setPaymentLoading(false);
    }
  };

  const confirmPayment = (patmentIntentId) => {
    axiosClient
      .post(
        "/api/v1/transaction/confirm",
        {
          payment_intent_id: patmentIntentId,
          transaction_id: data.transactionId,
        },
        {
          headers: {
            Authorization: `${supabase.auth.currentSession.access_token}`,
          },
        }
      )
      .then((res) => {
        onSuccess()
        onCancel()
        setPaymentLoading(false);
        alert("Payment Successful");
        console.log(res.data.data)
        // Router.replace(`profile/tickets/${res.data.data.transaction_id}`);
        Router.replace({
          pathname: `profile/tickets/[id]`,
          query: {
            id: res.data.data.transaction_id,
          },
        })
        // router.replace
      })
      .catch((err) => {
        console.log(err);
        setPaymentLoading(false);
      });
  };

  return (
    <div>
      <h1>Payment</h1>
      <CardElement
        className="card"
        options={{
          style: {
            base: {
              backgroundColor: "white",
            },
          },
        }}
      />
      <div className="my-4">
      {isPaymentLoading ? (
        <Spinner />
      ) : (
        <>
          <button
            className="bg-[#E56E7F] mb-4 hover:opacity-90 w-full text-[#110A02] font-bold py-3 text-md rounded-md disabled:cursor-not-allowed"
            onClick={onPay}
            disabled={isPaymentLoading}
          >
            Pay
          </button>
          <button
            className="bg-gray-300 hover:opacity-90 w-full text-[#110A02] font-bold py-3 text-md rounded-md disabled:cursor-not-allowed"
            disabled={isPaymentLoading}
            onClick={onCancel}
          >
            Cancel
          </button>
        </>
      )}
      </div>
    </div>
  );
};

export default Payment;
