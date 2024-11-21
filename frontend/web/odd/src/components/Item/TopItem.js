import { useEffect, useState } from "react";
import {
  TopPurchase,
  TopView,
  TopRePurchase,
  TopCart,
} from "../../apis/Item/TopItemApi";
import "./TopItem.css";

const TopItem = ({ platform, type }) => {
  const [items, setItems] = useState([]);
  const [error, setError] = useState("");

  const fetchData = async () => {
    const typeMap = {
      재구매순: "repurchase",
      조회순: "view",
      장바구니: "cart",
      구매순: "purchase",
    };

    const apiMap = {
      repurchase: () => TopRePurchase(platform),
      view: () => TopView(platform),
      cart: () => TopCart(platform),
      purchase: () => TopPurchase(platform),
    };

    const apiKey = typeMap[type];
    try {
      if (apiMap[apiKey]) {
        const data = await apiMap[apiKey]();
        console.log(`${type} 데이터:`, data);
        setItems(data || []);
        setError("");
      } else {
        console.error("유효하지 않은 타입:", type);
      }
    } catch (error) {
      console.error(`${type} 요청 실패:`, error);
      setError("데이터를 가져오는 데 실패했습니다.");
      setItems([]);
    }
  };

  useEffect(() => {
    fetchData();
  }, [platform, type]);

  return (
    <div className="topitem">
      <div className="topitem-container">
        {error ? (
          <p className="no-items-message">{error}</p>
        ) : items.length > 0 ? (
          <table className="topitem-table">
            <thead>
              <tr>
                <th style={{ width: "70%" }}>상품명</th>
                <th style={{ width: "30%" }}>수</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id}>
                  <td>{item.itemName}</td>
                  <td>{item.count}</td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p className="no-items-message">상품 리스트가 없습니다.</p>
        )}
      </div>
    </div>
  );
};

export default TopItem;
