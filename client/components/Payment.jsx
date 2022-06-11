import { CardElement, useElements, useStripe } from "@stripe/react-stripe-js";
import Router from "next/router";
import { useState } from "react";
import axiosClient from "../utils/axiosClient";
import client from "../utils/goAuth";
import Spinner from "./Spinner";

const Payment = ({ onCancel, data, onSuccess }) => {
  const [isPaymentLoading, setPaymentLoading] = useState(false);
  const stripe = useStripe();
  const elements = useElements();

  const onPay = async (e) => {
    setPaymentLoading(true);
    try {
      const res = await axiosClient.post(
        "/transaction/pay",
        {
          transaction_id: data.transactionId,
          amount: data.amount,
        },
        {
          headers: {
            Authorization: `${client.accessToken}`,
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
        setPaymentLoading(false);
        // console.log(paymentResult.error.message);
      } else {
        if (paymentResult.paymentIntent.status === "succeeded") {
          // alert("Success!");
          // console.log(paymentResult);
          confirmPayment(paymentResult.paymentIntent.id);
        } else {
          alert("Something went wrong. Please try again.");
          setPaymentLoading(false);
        }
      }
    } catch (error) {
      // console.log(error);
      alert("Something went wrong. Please try again.");
      setPaymentLoading(false);
    }
  };

  const confirmPayment = (patmentIntentId) => {
    axiosClient
      .post(
        "/transaction/confirm",
        {
          payment_intent_id: patmentIntentId,
          transaction_id: data.transactionId,
        },
        {
          headers: {
            Authorization: `${client.accessToken}`,
          },
        }
      )
      .then((res) => {
        onSuccess();
        onCancel();
        setPaymentLoading(false);
        alert("Payment Successful");
        Router.push({
          pathname: `../profile/tickets/[id]`,
          query: {
            id: res.data.data.transaction_id,
          },
        });
      })
      .catch((err) => {
        alert("Something went wrong. Please try again.");
        setPaymentLoading(false);
      });
  };

  return (
    <div>
      <h1 className="text-xl mb-2">Payment</h1>
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
              className="bg-[#E56E7F] mb-3 hover:opacity-90 w-full text-[#110A02] font-bold py-3 text-md rounded-md disabled:cursor-not-allowed"
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
