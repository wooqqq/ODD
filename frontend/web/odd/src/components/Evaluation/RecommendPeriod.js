import { useEffect, useState } from "react";
import "./Recommend.css";
import { Period } from "../../apis/Evaluation/RecommendApi";

const RecommendPeriod = ({ userId }) => {
  const [items, setItems] = useState([]);
  const [error, setError] = useState("");

  const fetchRecommendData = async () => {
    try {
      const data = await Period(userId);
      console.log(`주기별 추천 데이터:`, data);
      setItems(data || []);
      setError("");
    } catch (error) {
      console.error(`주기별 추천 요청 실패:`, error);
      setError(`주기별 데이터를 가져오는 데 실패했습니다.`);
      setItems([]);
    }
  };

  useEffect(() => {
    if (userId) {
      fetchRecommendData();
    }
  }, [userId]);

  return (
    <div>
      <div className="recommend">
        <div className="recommend-container">
          {error ? (
            <p className="no-items-message">{error}</p>
          ) : items.length > 0 ? (
            <table className="recommend-table">
              <thead>
                <tr>
                  <th style={{ width: "25%" }}>itemId</th>
                  <th style={{ width: "35%" }}>itemName</th>
                  <th style={{ width: "35%" }}>recommendation date</th>
                  <th style={{ width: "35%" }}>purchase date</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => (
                  <>
                    {/* 첫 번째 행 */}
                    <tr key={`${item.id}-header`}>
                      <td>{item.id}</td>
                      <td>{item.itemName}</td>
                      <td>{item.recommendationDate}</td>
                      <td>{item.purchaseDates[0]}</td>
                    </tr>
                    {/* 나머지 구매 날짜 */}
                    {item.purchaseDates.slice(1).map((date, index) => (
                      <tr key={`${item.id}-date-${index}`}>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>{date}</td>
                      </tr>
                    ))}
                  </>
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

export default RecommendPeriod;
