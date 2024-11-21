import { useEffect, useState } from "react";
import PlatformDropdown from "../Dashboard/PlatformDropdown";
import "./RecommendCategory.css";
import "../../components/Dashboard/Loading.css"; // 로딩 스피너 스타일 추가
import { Category } from "../../apis/Evaluation/RecommendApi";

const Recommend = ({ userId }) => {
  const [selectedPlatform, setSelectedPlatform] = useState("GS25");
  const [items, setItems] = useState([]);
  const [isLoading, setIsLoading] = useState(false); // 로딩 상태 추가
  const [error, setError] = useState("");

  const fetchCategory = async () => {
    setIsLoading(true);
    setError(""); // 이전 에러 상태 초기화
    try {
      const data = await Category(userId, selectedPlatform);
      console.log(`카테고리 추천 데이터:`, data);
      setItems(data || []);
    } catch (e) {
      console.error(`카테고리 추천 요청 실패:`, error);
      setError(`카테고리 데이터를 가져오는 데 실패했습니다.`);
      setItems([]);
    } finally {
      setIsLoading(false); // 로딩 상태 종료
    }
  };

  useEffect(() => {
    if (userId) {
      fetchCategory();
    }
  }, [userId, selectedPlatform]);

  return (
    <div>
      <PlatformDropdown
        selectedPlatform={selectedPlatform}
        setSelectedPlatform={setSelectedPlatform}
      />

      <div className="recommend-category">
        <div className="recommend-category-container">
          {isLoading ? (
            <div className="loading-container">
              <div className="loading-spinner"></div>
            </div>
          ) : error ? (
            <p className="no-items-message">{error}</p>
          ) : items.length > 0 ? (
            <table className="recommend-category-table">
              <thead>
                <tr>
                  <th style={{ width: "40%" }}>itemId</th>
                  <th style={{ width: "60%" }}>itemName</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => (
                  <tr key={item.id}>
                    <td>{item.id}</td>
                    <td>{item.itemName}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <p className="no-items-message">추천 리스트가 없습니다.</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default Recommend;
