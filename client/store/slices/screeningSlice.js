import { createSlice, Draft, PayloadAction } from "@reduxjs/toolkit";
import { supabase } from "../../utils/supabaseClient";

const initialState = {
};

export const userSlice = createSlice({
  name: "session",
  initialState,
  reducers: {
    setSession: (state, action) => {
      if (action.payload) {
        state.userSession = action.payload;
      } else {
        state.userSession = null;
      }
    },
  },
});

// A small helper of user state for `useSelector` function.
export const getSession = (state) => state.userSession.userSession;

// Exports all actions
export const { setSession } = userSlice.actions;

export default userSlice.reducer;
