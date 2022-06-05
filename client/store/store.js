import { configureStore } from '@reduxjs/toolkit';
import sessionSlice from './slices/sessionSlice';
import {
  useDispatch as useDispatchBase,
  useSelector as useSelectorBase,
} from 'react-redux';

/**
 * Creates a store and includes all the slices as reducers.
 */
export const store = configureStore({
  reducer: {
    userSession: sessionSlice,
  },
});
// Since we use typescript, lets utilize `useDispatch`
export const useDispatch = () => useDispatchBase();

// And utilize `useSelector`
export const useSelector = (
  selector
) => useSelectorBase(selector);