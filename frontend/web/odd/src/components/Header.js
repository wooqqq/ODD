import dashboardStore from "../stores/dashboardStore";
import UserSearch from "./Evaluation/UserSearch";
import "./Header.css";

const Header = ({ title }) => {
  const { selectedPlatform, changePlatform, selectedMenu } = dashboardStore();

  const handleMemberSearch = (searchTerm) => {
    console.log("회원 검색어:", searchTerm);
    // 여기에 검색 로직 추가 가능
  };

  return (
    <div className="header">
      <h2 className="header-title">{title}</h2>
      {(selectedMenu === "사용자 정보" || selectedMenu === "대시보드") && (
        <div className="header-buttons">
          {["GS25", "GS더프레시", "wine25"].map((platform) => (
            <button
              key={platform}
              onClick={() => changePlatform(platform)}
              className={selectedPlatform === platform ? "active" : ""}
            >
              {platform}
            </button>
          ))}
        </div>
      )}
      {selectedMenu === "평가" && (
        <div className="header-search">
          <UserSearch onSearch={handleMemberSearch} />
        </div>
      )}
    </div>
  );
};

export default Header;
