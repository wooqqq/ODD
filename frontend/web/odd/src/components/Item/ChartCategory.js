import React, { useEffect, useState } from "react";
import { Bar } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";
import { CategoryCount } from "../../apis/Item/CategoryApi"; // API 함수 import
import "./ChartCategory.css";
import "../../components/Dashboard/Loading.css";

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const ChartCategory = ({ platform }) => {
  const [chartData, setChartData] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchData = async () => {
    try {
      setIsLoading(true);
      const data = await CategoryCount(platform); // API 요청
      const labels = data.map((item) => item.category);
      const viewCounts = data.map((item) => item.viewCount);
      const cartCounts = data.map((item) => item.cartCount);
      const orderCounts = data.map((item) => item.orderCount);

      setChartData({
        labels,
        datasets: [
          {
            label: "조회수",
            data: viewCounts,
            backgroundColor: "rgba(75, 192, 192, 0.6)",
          },
          {
            label: "장바구니 수",
            data: cartCounts,
            backgroundColor: "rgba(54, 162, 235, 0.6)",
          },
          {
            label: "주문 수",
            data: orderCounts,
            backgroundColor: "rgba(255, 99, 132, 0.6)",
          },
        ],
      });
      setError(null);
    } catch (err) {
      console.error("카테고리 데이터 요청 실패:", err);
      setError("데이터를 가져오는 데 실패했습니다.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [platform]);

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: "left",
      },
    },
    scales: {
      x: {
        grid: {
          display: false,
        },
        ticks: {
          font: {
            size: 12,
          },
          color: "#333",
        },
      },
      y: {
        beginAtZero: true,
        ticks: {
          stepSize: 1,
          font: {
            size: 12,
          },
          color: "#333",
        },
      },
    },
  };

  return (
    <div className="chart-category-container">
      {isLoading ? (
        <div className="loading-container">
          <div className="loading-spinner"></div>
        </div>
      ) : error ? (
        <p className="error-message">{error}</p>
      ) : (
        <div className="chart-scroll-wrapper">
          <div className="chart-wrapper">
            <Bar data={chartData} options={options} />
          </div>
        </div>
      )}
    </div>
  );
};

export default ChartCategory;
