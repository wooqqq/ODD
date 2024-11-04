import React from "react";

const Footer = () => {
  const num = 10;

  return (
    <div className="sidebar">
      <h2>Footer {num % 2 === 0 ? "짝수" : "홀수"}</h2>
    </div>
  );
};

export default Footer;
