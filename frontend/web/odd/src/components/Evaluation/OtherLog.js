import { useState, useEffect } from "react";
import useUserStore from "../../stores/userStore";
import { fetchOtherLogs } from "../../apis/Evaluation/LogApi";
import PlatformDropdown from "../Dashboard/PlatformDropdown";
import "./Log.css";
import "../../components/Dashboard/Loading.css";

const OtherLog = () => {
  const { userId } = useUserStore();
  const [selectedPlatform, setSelectedPlatform] = useState("GS25");
  const [otherLogs, setOtherLogs] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const servicetypeMap = {
    gs25: "GS25",
    mart: "GS더프레시",
    wine25: "wine25",
    gs25_pickup: "GS25) 픽업",
    gs25_dlvy: "GS25) 배달",
    mart_pickup: "GS더프레시) 픽업",
    mart_dlvy: "GS더프레시) 배달",
    wine25_pickup: "wine25) 픽업",
  };

  const interMap = {
    view: "조회",
    cart: "장바구니",
    order: "주문",
  };

  useEffect(() => {
    const getOtherLogs = async () => {
      setIsLoading(true);
      setError(null);
      console.log(`Other Log 선택된 플랫폼: ${selectedPlatform}`);
      console.log("Other Log 호출 시작");

      try {
        const data = await fetchOtherLogs(userId, selectedPlatform);
        console.log("Other Log 호출 성공:", data);

        if (Array.isArray(data) && data.length > 0) {
          setOtherLogs(data);
        } else {
          console.warn(
            "API에서 빈 배열 또는 유효하지 않은 데이터를 반환했습니다."
          );
          setOtherLogs([]);
        }
      } catch (err) {
        console.error("Other Log 호출 실패:", err.message);
        setError("Other Log를 불러오는 중 문제가 발생했습니다.");
      } finally {
        setIsLoading(false);
        console.log("Other Log 호출 종료");
      }
    };

    getOtherLogs();
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

      {/* other로그 테이블 */}
      <div className="table-container">
        {isLoading ? (
          <div className="loading-container">
            <div className="loading-spinner"></div>
          </div>
        ) : error ? (
          <p className="error">{error}</p>
        ) : otherLogs.length === 0 ? (
          <p>로그가 없습니다.</p>
        ) : (
          <table className="table">
            <thead>
              <tr>
                <th style={{ width: "15%" }}>inter</th>
                <th style={{ width: "45%" }}>itemName</th>
                <th style={{ width: "20%" }}>serviceType</th>
                <th style={{ width: "20%" }}>date</th>
              </tr>
            </thead>
            <tbody>
              {[...otherLogs].reverse().map((log) => (
                <tr key={log.id}>
                  <td>{interMap[log.inter]}</td>
                  <td>{log.itemName}</td>
                  <td>{servicetypeMap[log.servicetype]}</td>
                  <td>{log.date}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
};

export default OtherLog;
