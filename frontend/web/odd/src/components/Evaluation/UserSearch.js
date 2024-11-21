import { useState } from "react";
import "./UserSearch.css";
import { LuSearch } from "react-icons/lu";
import { userSearch } from "../../apis/Evaluation/UserSearchApi";
import useUserStore from "../../stores/userStore";

const UserSearch = () => {
  const [searchEmail, setSearchEmail] = useState("");
  const [showModal, setShowModal] = useState(false); // 모달 상태 추가
  const [errorMessage, setErrorMessage] = useState(""); // 에러 메시지 상태
  const setUserId = useUserStore((state) => state.setUserId);
  const setEmail = useUserStore((state) => state.setEmail);

  const handleSearch = async () => {
    try {
      const data = await userSearch(searchEmail); // API 요청
      setEmail(searchEmail);
      setUserId(data.userId);
      setShowModal(false);
    } catch (err) {
      console.error("검색 실패:", err);
      setErrorMessage("가입하지 않은 이메일입니다.");
      setShowModal(true);
      setUserId(null);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === "Enter") {
      handleSearch();
    }
  };

  return (
    <div className="user-search">
      <LuSearch className="search-icon" />
      <input
        type="text"
        value={searchEmail}
        onChange={(e) => setSearchEmail(e.target.value)}
        onKeyDown={handleKeyDown}
        placeholder="회원의 이메일을 입력해주세요."
        className="user-search-input"
      />
      <button onClick={handleSearch} className="search-button">
        검색
      </button>

      {showModal && (
        <div className="modal-overlay">
          <div className="modal">
            <p>{errorMessage}</p>
            <button onClick={() => setShowModal(false)} className="button">
              확인
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default UserSearch;
