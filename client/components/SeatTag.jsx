const SeatTag = ({ seat, noRows }) => {
  return (
    <div className="text-[#AF9A54] bg-[#142F4D] px-2.5 py-0.5 mr-2 mb-2 rounded-md">
      {String.fromCharCode(65 + noRows - seat.row) + seat.number}
    </div>
  );
};

export default SeatTag;
