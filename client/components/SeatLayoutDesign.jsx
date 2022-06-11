import { useEffect, useState } from "react";
import axiosClient from "../utils/axiosClient";
import { Box, Seat, SeatRow } from "./Seats";

const SeatLayoutDesign = ({ cinemas }) => {
  const [rows, setRows] = useState(10);
  const [columns, setColumns] = useState(10);
  const [selectedType, setSelectedType] = useState("normal");
  const [selectedSeatStatus, setSelectedSeatStatus] = useState(0);

  const [cinemaId, setCinemaId] = useState("none");
  const [audiId, setAudiId] = useState("none");

  const [grid, setGrid] = useState(
    Array(rows)
      .fill(null)
      .map(() =>
        Array(columns).fill({
          status: 1,
          type: "normal",
          //   price: selectedPrice,
        })
      )
  );

  useEffect(() => {
    const g = [...grid];
    const prevRow = g.length;
    const prevCol = g[0].length;

    for (let i = 0; i < Math.abs(prevRow - rows); i++) {
      // grid.push(Array(prevCol).fill(1));
      if (prevRow < rows) {
        g.push(
          Array(prevCol).fill({
            status: 1,
            type: "normal",
            // price: selectedPrice,
          })
        );
      } else {
        g.pop();
      }
    }
    for (let i = 0; i < g.length; i++) {
      // grid.push(Array(prevCol).fill(1));
      for (let j = 0; j < Math.abs(prevCol - columns); j++) {
        if (prevCol < columns) {
          g[i].push({
            value: 1,
            type: "normal",
            // price: selectedPrice,
          });
        } else {
          g[i].pop();
        }
      }
    }
    setGrid(g);
  }, [rows, columns]);

  const handleSeatClick = (rowIndex, columnIndex) => {
    const newGrid = grid.map((row, i) => {
      return row.map((cell, j) => {
        if (i === rowIndex && j === columnIndex) {
          return {
            ...cell,
            status: selectedType != cell.type ? 1 : cell.status == 1 ? 0 : 1,
            type: selectedType,
          };
        }
        return cell;
      });
    });
    // onSeatClick(rowIndex, columnIndex);
    setGrid(newGrid);
  };

  const handleRowColClick = (index, isRow = true) => {
    const newGrid = grid.map((row, i) => {
      return row.map((cell, j) => {
        if ((i === index && isRow) || (j === index && !isRow)) {
          return { ...cell, status: selectedSeatStatus, type: selectedType };
        }
        return cell;
      });
    });
    setGrid(newGrid);
  };

  const onSubmit = async () => {
    console.log(audiId);

    // console.log(d, e);
    const seatsData = [];
    grid.forEach((row, i) => {
      row.forEach((col, j) => {
        // console.log(typeMap[col.type])
        seatsData.push({
          row: i + 1,
          number: j + 1,
          available: col.status != 0,
          type: col.type,
          price: typeMap[col.type].price,
          auditorium_id: +audiId,
        });
      });
    });

    try {
      const res = await axiosClient.post(`/api/v1/auditorium/${audiId}/seats`, {
        rows,
        columns,
        seats: seatsData,
      });
      alert("Succesfully changed layout");
    } catch (err) {
      alert("Error setting layout");
    }
  };

  return (
    <main className="flex flex-col items-center">
      <div>
        <div>
          <label>Cinema</label>
          <select
            onChange={(e) => {
              setCinemaId(e.target.value);
              setAudiId("none");
            }}
            className="text-black"
          >
            <option key={"none"} value={"none"}>
              None
            </option>
            {Object.keys(cinemas).map((cinema) => (
              <option key={cinemas[cinema].id} value={cinemas[cinema].id}>
                {cinemas[cinema].name}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label>Auditorium</label>
          <select
            onChange={(e) => {
              setAudiId(e.target.value);
            }}
            className="text-black"
          >
            <option key={"none"} value={"none"}>
              None
            </option>
            {cinemas[cinemaId] &&
              cinemas[cinemaId].auditoriums.map((aud) => (
                <option key={aud.id} value={aud.id}>
                  {aud.name}
                </option>
              ))}
          </select>
        </div>

        <div>
          <div>Rows</div>
          <div>
            <input
              className="text-black"
              type="number"
              value={rows}
              onChange={(e) => {
                let val = +e.target.value;

                if (typeof val != "number" || val == 0) {
                  setRows(1);
                  return;
                }

                val = Math.min(val, 15);
                setRows(val);
              }}
              min="1"
            />
          </div>
        </div>
        <div>
          <div>Columns</div>
          <div>
            <input
              className="text-black"
              type="number"
              value={columns}
              onChange={(e) => {
                let val = +e.target.value;

                if (typeof val != "number" || val == 0) {
                  setColumns(1);
                  return;
                }
                val = Math.min(val, 15);
                setColumns(val);
              }}
              min="1"
            />
          </div>
        </div>
        {/* <button onClick={() => {
            onClick()
          }}>Submit</button> */}
      </div>
      <div className="flex my-3">
        {Object.values(colorMap).map((color, i) => {
          return (
            <div
              key={color.name}
              onClick={() => {
                setSelectedSeatStatus(i);
              }}
              className="flex items-center mr-2 cursor-pointer select-none"
              style={{
                opacity: selectedSeatStatus === i ? 1 : 0.25,
              }}
            >
              <Seat colors={color} />
              <p>{color.name}</p>
            </div>
          );
        })}
      </div>
      <div className="flex my-3">
        {Object.entries(typeMap).map(([typeKey, type], i) => {
          return (
            <div
              key={type.name}
              onClick={() => {
                setSelectedType(typeKey);
              }}
              className="flex items-center mr-2 cursor-pointer select-none"
              style={{
                opacity: selectedType === typeKey ? 1 : 0.25,
              }}
            >
              <Seat colors={type} />
              <p>{type.name}</p>
            </div>
          );
        })}
      </div>
      <div className="bg-[#09192C]">
        <div>
          <div className="flex">
            {Array.from({ length: grid[0].length + 1 }).map((_, i) => {
              return (
                <Box
                  key={i}
                  onClick={() => {
                    if (i == 0) return;
                    handleRowColClick(i - 1, false);
                  }}
                >
                  {i != 0 && i}
                </Box>
              );
            })}
          </div>
          {grid.map((row, rowIndex) => {
            return (
              <SeatRow
                key={rowIndex}
                row={row}
                rowIndex={rowIndex}
                onRowClick={() => {
                  handleRowColClick(rowIndex, true);
                }}
                onSeatClick={handleSeatClick}
                colorFunc={getColor}
                rowNameFunc={(rowIndex) => {
                  return String.fromCharCode(64 + grid.length - rowIndex);
                }}
              ></SeatRow>
            );
          })}
        </div>
      </div>
      <button
        className="bg-emerald-500 mb-3 hover:opacity-90 px-4 text-black font-bold py-1 text-md rounded-md disabled:cursor-not-allowed"
        onClick={onSubmit}
      >
        Submit
      </button>
    </main>
  );
};

export default SeatLayoutDesign;

const getColor = (seat) => {
  if (seat.status == 0) {
    return colorMap[0];
  }

  return typeMap[seat.type] || colorMap[0];
};
export const colorMap = {
  0: {
    name: "Unavailable",
    border: "#313131",
    text: "#313131",
    backgroundColor: "#313131",
  },
  1: {
    name: "Available",
    border: "#163869",
    text: "white",
    backgroundColor: "",
  },
};

export const typeMap = {
  normal: {
    name: "Normal",
    border: "#F1B778",
    price: 300,
    backgroundColor: "#F1B778",
  },
  deluxe: {
    name: "Deluxe",
    border: "#E56E7F",
    price: 550,
    backgroundColor: "#E56E7F",
  },
  "super-deluxe": {
    name: "Super deluxe",
    border: "#BA55D3",
    price: 750,
    backgroundColor: "#BA55D3",
  },
};
