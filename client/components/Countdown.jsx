import { useCallback, useEffect, useRef, useState } from "react";
import moment from "moment"
import Router, { useRouter } from "next/router";

const calculateDuration = eventTime => moment.duration(Math.max(eventTime - (Math.floor(Date.now() / 1000)), 0), 'seconds');

const Countdown = ({ eventTime, interval }) => {
  const router = useRouter()
  const [duration, setDuration] = useState(calculateDuration(eventTime));
  const timerRef = useRef(0);
  const timerCallback = useCallback(() => {
    const duration = calculateDuration(eventTime)
    
    if (duration.milliseconds() <= 0 ) {
      alert("Session expired please reload.")
      clearInterval(timerRef.current);
      router.reload(window.location.pathname)
    }
    setDuration(duration);
  }, [eventTime])

  useEffect(() => {
    timerRef.current = setInterval(timerCallback, interval);

    return () => {
      clearInterval(timerRef.current);
    }
  }, [eventTime]);

  return (
    <div className="text-xl">
      {duration.minutes()} Minutes {duration.seconds()} Seconds Remaining
    </div>
  )
}

export default Countdown