import React from "react";

const SelectInput = (props) => {
  const { children, ...rest } = props;
  return (
    <select
      className="form-select form-select-sm
      appearance-none
      block
      px-2
      py-1
      text-sm
      font-normal
      text-gray-700
      bg-white bg-clip-padding bg-no-repeat
      border border-solid border-gray-300
      rounded
      transition
      ease-in-out
      m-0
      focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
      aria-label=".form-select-sm example"
      {...rest}
    >
      {children}
    </select>
  );
};

export default SelectInput;
