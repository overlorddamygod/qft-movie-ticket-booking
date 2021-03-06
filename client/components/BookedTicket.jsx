import moment from "moment";
import SeatTag from "./SeatTag";

const BookedTicket = ({ booking }) => {
  return (
    <div className="my-3 flex py-3 cursor-pointer hover:scale-105 bg-[#0B2039] overflow-hidden drop-shadow-md shadow-slate-400 p-3 rounded-2xl transition-all">
      <div className="mr-4">
        <img src={booking.screening.movie.banner} className="w-36 md:w-44" />
      </div>
      <div className="text-md flex-1">
        <h2 className="text-md md:text-xl">{booking.screening.movie.name}</h2>
        <div className="text-[#455B77] text-sm md:text-base ">
          <div>
            Show Time:{" "}
            {moment(booking.screening.start_time).format(
              "h:mm a, MMMM Do YYYY"
            )}
          </div>
          <div>
            {booking.screening.cinema.name} {booking.screening.auditorium.name}
          </div>
          <div>{booking.bookings.length} seats</div>
          <div>Status: {booking.paid ? "Paid" : "Payment Pending.."}</div>
          <div>Total: Nrs. {booking.total_price}</div>
          <div>Bought At: {moment(booking.expires_at).format(
              "LLL"
            )}</div>
        </div>
        <div className="flex mt-2">
          <div className="mr-2">Seats: </div>
          <span className="grid grid-cols-3 md:grid-cols-4">
          {booking.bookings.map(({ seat }) => {
            return (
              <SeatTag
                key={seat.id}
                seat={seat}
                noRows={booking.screening.auditorium.rows}
              />
            );
          })}
          </span>
        </div>
        <a
          href={getReceiptUrl(booking.id)}
          download
          className="hover:underline my-1"
        >
          Download Ticket
        </a>
      </div>
      {/* <div className="px-5">
        <a
          href={getReceiptUrl(booking.id)}
          download
          className="hover:underline"
        >
          Download Ticket
        </a>
      </div> */}
    </div>
  );
};

const getReceiptUrl = (id) => {
  return `${process.env.NEXT_PUBLIC_STORAGE_URL}tran_${id}.pdf`;
};

export default BookedTicket;
