import { useState } from "react";
import "./ItemDropdown.css";

const ItemDropdown = ({ selectedItem, setSelectedItem }) => {
  const [isOpen, setIsOpen] = useState(false);
  const Items = ["조회순", "장바구니", "구매순", "재구매순"];

  const handleSelect = (item) => {
    setSelectedItem(item);
    setIsOpen(false);
  };

  return (
    <div className="item-dropdown-container">
      <div className="item-dropdown">
        <button
          className="item-dropdown-toggle"
          onClick={() => setIsOpen(!isOpen)}
        >
          {selectedItem} <span className="arrow">▼</span>
        </button>
        {isOpen && (
          <ul className="item-dropdown-menu">
            {Items.map((item) => (
              <li
                key={item}
                onClick={() => handleSelect(item)}
                className="item-dropdown-item"
              >
                {item}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default ItemDropdown;
