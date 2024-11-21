import { useState, useEffect } from "react";
import { fetchPurchaseLogs } from "../../apis/Evaluation/LogApi.js";
import useUserStore from "../../stores/userStore";
import PlatformDropdown from "../Dashboard/PlatformDropdown";
import "./Log.css";
import "../../components/Dashboard/Loading.css";

const PurchaseLog = () => {
  const { userId } = useUserStore();
  const [selectedPlatform, setSelectedPlatform] = useState("GS25");
  const [purchaseLogs, setPurchaseLogs] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getPurchaseLogs = async () => {
      setIsLoading(true);
      setError(null);
      console.log(`purchase log 선택된 플랫폼: ${selectedPlatform}`);
      console.log("상품 구매 로그 호출 시작");

      try {
        const data = await fetchPurchaseLogs(userId, selectedPlatform);
        console.log("상품 구매 로그 호출 성공:", data);
        setPurchaseLogs(data);
      } catch (err) {
        console.error("상품 구매 로그 호출 실패:", err.message);
        setError(err.message);
      } finally {
        setIsLoading(false);
        console.log("상품 구매 로그 호출 종료");
      }
    };

    getPurchaseLogs();
  }, [selectedPlatform, userId]);

  return (
    <div className="log-container">
      {/* 드롭다운 */}
      <PlatformDropdown
        selectedPlatform={selectedPlatform}
        setSelectedPlatform={(platform) => {
          console.log(`플랫폼 변경: ${platform}`);
          setSelectedPlatform(platform);
        }}
      />

      {/* 구매 로그 테이블 */}
      <div className="table-container purchase-log-container">
        {isLoading ? (
          <div className="loading-container">
            <div className="loading-spinner"></div>
          </div>
        ) : error ? (
          <p className="error">{error}</p>
        ) : purchaseLogs.length === 0 ? (
          <p className="table-name">로그가 없습니다.</p>
        ) : (
          <table className="table">
            <thead>
              <tr>
                <th style={{ width: "25%" }}>date</th>
                <th style={{ width: "25%" }}>itemId</th>
                <th style={{ width: "35%" }}>itemName</th>
                <th style={{ width: "10%" }}>count</th>
              </tr>
            </thead>
            <tbody>
              {purchaseLogs.map((log) =>
                log.items.map((item, index) => (
                  <tr key={`${log.id}-${item.id}`}>
                    <td>{index === 0 ? log.purchaseDate : ""}</td>
                    <td>{item.id}</td>
                    <td>{item.itemName}</td>
                    <td>{item.count}</td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default PurchaseLog;
