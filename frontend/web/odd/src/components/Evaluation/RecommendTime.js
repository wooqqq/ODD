import { useEffect, useState } from "react";
import "./Recommend.css";
import { Time } from "../../apis/Evaluation/RecommendApi";

const RecommendTime = ({ userId }) => {
  const [items, setItems] = useState([]);
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const fetchTimeData = async () => {
    setIsLoading(true);
    try {
      const data = await Time(userId);
      console.log("시간대 추천 데이터:", data);

      // 병합 및 시간대 추가
      const mergedData = Object.entries(data).flatMap(([time, items]) =>
        items.map((item) => ({ ...item, time }))
      );
      console.log("병합된 데이터:", mergedData);

      setItems(mergedData);
      setError("");
    } catch (error) {
      console.error("시간대 추천 요청 실패:", error);
      setError("시간대 추천 데이터를 가져오는 데 실패했습니다.");
      setItems([]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchTimeData();
  }, [userId]);

  return (
    <div className="recommend">
      {/* 시간대 추천상품 테이블 */}
      <div className="recommend-container">
        {isLoading ? (
          <div className="loading-container">
            <div className="loading-spinner"></div>
          </div>
        ) : error ? (
          <p className="error">{error}</p>
        ) : items.length === 0 ? (
          <p className="no-items-message">추천 리스트가 없습니다.</p>
        ) : (
          <table className="recommend-table">
            <thead>
              <tr>
                <th style={{ width: "12.5%" }}>hour</th>
                <th style={{ width: "35%" }}>itemId</th>
                <th style={{ width: "40%" }}>itemName</th>
                <th style={{ width: "12.5%" }}>count</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item, index) => (
                <tr key={`${item.time}-${item.id}`}>
                  <td>
                    {index === 0 || item.time !== items[index - 1].time
                      ? item.time
                      : ""}
                  </td>
                  <td>{item.id}</td>
                  <td>{item.itemName}</td>
                  <td>{item.purchaseCount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default RecommendTime;
