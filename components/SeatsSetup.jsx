import { useEffect, useState } from "react";
import { supabase } from "../utils/supabaseClient";

export const colorMap = {
  0: {
    name: "Unavailable",
    border: "#313131", // Unavailable
    text: "#313131",
    backgroundColor: "#313131",
  },
  1: {
    name: "Available",
    border: "#163869", // Available
    text: "white",
    backgroundColor: "",
  },
  2: {
    name: "Selected",
    border: "#BA55D3", // Available
    text: "white",
    backgroundColor: "",
  },
  3: {
    name: "Reserved",
    border: "#F1B778", // Reserved
    text: "#F1B778",
    backgroundColor: "",
  },
  4: {
    name: "Sold",
    border: "#E56E7F", // Sold
    text: "#E56E7F",
    backgroundColor: "#E56E7F",
  },
};

export const getColor = (num) => {
  return colorMap[num] || colorMap[0];
};

const SeatsSetup = ({cinemas}) => {
  const [rows, setRows] = useState(5);
  const [columns, setColumns] = useState(5);
  const [selected, setSelected] = useState(0);
  const [cinemaId, setCinemaId] = useState("none");
  const [audiId, setAudiId] = useState("none");

  // console.log(Array(rows))
  const [grid, setGrid] = useState(
    Array(rows)
      .fill(null)
      .map(() => Array(columns).fill(1))
  );

  useEffect(() => {
    const g = [...grid];
    const prevRow = g.length;
    const prevCol = g[0].length;

    for (let i = 0; i < Math.abs(prevRow - rows); i++) {
      // grid.push(Array(prevCol).fill(1));
      if (prevRow < rows) {
        g.push(Array(prevCol).fill(1));
      } else {
        g.pop();
      }
    }
    for (let i = 0; i < g.length; i++) {
      // grid.push(Array(prevCol).fill(1));
      for (let j = 0; j < Math.abs(prevCol - columns); j++) {
        if (prevCol < columns) {
          g[i].push(1);
        } else {
          g[i].pop();
        }
      }
    }
    setGrid(g);
  }, [rows, columns]);

  const onGridClick = (r, c) => {
    const newGrid = grid.map((row, i) => {
      return row.map((col, j) => {
        if (i === r && j === c) {
          // console.log((col+1) % 4)
          // console.log(((col+1)%4) -1)
          return selected;
        }
        return col;
      });
    });
    setGrid(newGrid);
  };

  useEffect(()=> {
    if (audiId == "none") {
      return
    }
    getRowsCols();
  }, [audiId])

  const getColor = (num) => {
    return colorMap[num] || colorMap[0];
  };

  const getRowsCols = async () => {
    const {data, err} =  await supabase.from("auditoriums").select("*").eq("id", audiId).single()
    if(err) {
      console.log(err)
    }
    setRows(data.rows);
    setColumns(data.columns);
  }

  const onSubmit = async () => {
    console.log(audiId)
    const {data: d, err:e} = await supabase.from("auditoriums").update({
      rows: rows,
      columns: columns,
    }).match({
      "id": audiId})
    console.log(d, e)
    const seatsData = [];
    grid.forEach((row, i) => {
        row.forEach((col, j) => {
            seatsData.push({
                row: i+1,
                number: j+1,
                available: col != 0,
                auditorium_id: audiId
            })
        })
    })
    const { data, error } = await  supabase.from("seats").insert(seatsData)
    console.log(data, error)
  }

  return (
      <main className="flex flex-col items-center">
        <div>
          <div>
            <label>Cinema</label>
            <select onChange={(e) => {
              setCinemaId(e.target.value)
              setAudiId("none")
            }} className="text-black">
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
            <select onChange={(e) => {
              setAudiId(e.target.value)
            }} className="text-black">
            <option key={"none"} value={"none"}>
                  None
                </option>
              {cinemas[cinemaId] && cinemas[cinemaId].auditoriums.map((aud) => (
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
                onChange={(e) => setRows(e.target.value)}
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
                onChange={(e) => setColumns(e.target.value)}
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
                  setSelected(i);
                }}
                className="flex items-center mr-2 cursor-pointer select-none"
                style={{
                  opacity: selected === i ? 1 : 0.25,
                }}
              >
                <Seat colors={color} />
                <p>{color.name}</p>
              </div>
            );
          })}
        </div>
        <div className="bg-[#09192C]">
          <div>
            {grid.map((row, rowIndex) => {
              return (
                <div className="flex flex-row" key={rowIndex}>
                  <div className="flex w-10 h-10 justify-center items-center text-center">
                    {String.fromCharCode(64 + grid.length - rowIndex)}
                  </div>
                  {row.map((cell, columnIndex) => {
                    const colors = getColor(cell);
                    return (
                      <Seat
                        onGridClick={() => {
                          onGridClick(rowIndex, columnIndex);
                        }}
                        colors={colors}
                        columnIndex={columnIndex + 1}
                        key={columnIndex}
                      />
                    );
                  })}
                </div>
              );
            })}
          </div>
        </div>

        <button onClick={onSubmit}>Submit</button>
      </main>
  );
};

export default SeatsSetup;

export const Seat = ({
  onGridClick = () => {},
  className="",
  colors = colorMap[0],
  columnIndex = "",
}) => {
  return (
    <div
      className={`${className} flex flex-col mr-1 mb-1 md:mr-2 md:mb-2 w-10 h-8 justify-center items-center border-4 rounded-t-xl rounded-b hover:scale-110 cursor-pointer select-none`}
      onClick={onGridClick}
      style={{
        borderColor: colors.border || "",
        color: colors.text || "",
        backgroundColor: colors.backgroundColor || "",
      }}
    >
      <div>{columnIndex}</div>
    </div>
  );
};
