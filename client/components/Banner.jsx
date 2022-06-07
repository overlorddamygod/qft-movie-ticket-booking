import React from "react";

const Banner = ({ className, ...props }) => {
  return <img className={`${className} w-60 rounded-3xl`} {...props} />;
};

export default Banner;
