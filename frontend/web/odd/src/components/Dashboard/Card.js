import "./Card.css";

const Card = ({ children, flexGrow = 1 }) => {
  return (
    <div className="card" style={{ flex: flexGrow }}>
      {children}
    </div>
  );
};

export default Card;
