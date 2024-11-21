import { useState } from "react";
import "./PlatformDropdown.css";

const PlatformDropdown = ({ selectedPlatform, setSelectedPlatform }) => {
  const [isOpen, setIsOpen] = useState(false);
  const platforms = ["GS25", "GS더프레시", "wine25"];

  const handleSelect = (platform) => {
    setSelectedPlatform(platform);
    setIsOpen(false);
  };

  return (
    <div className="dropdown-container">
      <div className="dropdown">
        <button className="dropdown-toggle" onClick={() => setIsOpen(!isOpen)}>
          {selectedPlatform} <span className="arrow">▼</span>
        </button>
        {isOpen && (
          <ul className="dropdown-menu">
            {platforms.map((platform) => (
              <li
                key={platform}
                onClick={() => handleSelect(platform)}
                className="dropdown-item"
              >
                {platform}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default PlatformDropdown;
