import React from 'react'
import SeatGrid from "../../components/SeatLayoutDesign"

const Grid = () => {
  return (
    <div>
        <SeatGrid onSeatClick={(rowIndex, colIndex) => {
            console.log("SEAT CLICK:", rowIndex, colIndex)
        }} onTypeChange={(type) => {
            console.log("CHANGED: TYPE", type)
        }} onSelectedSeatStatusChange={(status) => {
            console.log("CHANGED: STATUS", status)
        }}/>
    </div>
  )
}

export default Grid