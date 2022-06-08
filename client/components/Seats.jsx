const Box = (props) => {
  const { children, ...rest } = props;
  return (
    <div
      className={`mr-1 mb-1 md:mr-2 md:mb-2 w-9 h-7 md:w-10 md:h-8 flex justify-center items-center text-center`}
      {...rest}
    >
      {children}
    </div>
  );
};
const Seat = ({
  onClick = () => {},
  className = "",
  colors = colorMap[0],
  text = "",
}) => {
  return (
    <Box>
      <div
        className={`${className} flex flex-col text-center w-full h-full text-xs justify-center items-center border-4 rounded-t-xl rounded-b hover:scale-110 cursor-pointer select-none`}
        onClick={onClick}
        style={{
          borderColor: colors.border || "",
          color: colors.text || "black",
          backgroundColor: colors.backgroundColor || "",
        }}
      >
        {text}
      </div>
    </Box>
  );
};

const SeatRow = ({
  rowIndex,
  row,
  onSeatClick,
  onRowClick,
  colorFunc,
  rowNameFunc,
}) => {
  return (
    <div className="flex flex-row items-center" key={rowIndex}>
      <Box onClick={onRowClick}>{rowNameFunc(rowIndex)}</Box>
      {row.map((cell, columnIndex) => {
        const colors = colorFunc(cell);

        return (
          <div className="flex-col" key={columnIndex}>
            <Seat
              onClick={() => {
                onSeatClick(rowIndex, columnIndex);
              }}
              colors={colors}
              text={columnIndex + 1}
            ></Seat>
          </div>
        );
      })}
    </div>
  );
};

export { Seat, SeatRow, Box };
