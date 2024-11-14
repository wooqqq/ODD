import "./Card.css";

const Card = ({ children, width, height }) => {
  return (
    <div className="card" style={{ width: width, height: height }}>
      {children}
    </div>
  );
};

export default Card;
