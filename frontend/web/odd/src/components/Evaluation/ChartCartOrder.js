import { useState, useEffect } from "react";
import useUserStore from "../../stores/userStore";
import { fetchPlatformStats } from "../../apis/Evaluation/ChartApi";
import { AppColors } from "../../constants/AppColors";
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
import "./ChartCartOrder.css";
import "../../components/Dashboard/Loading.css";

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const ChartCartOrder = () => {
  const [data, setData] = useState(null);
  const { userId } = useUserStore();

  useEffect(() => {
    if (!userId) {
      console.error("userId가 설정되지 않았습니다.");
      return;
    }

    const fetchData = async () => {
      const platformStats = await fetchPlatformStats(userId); // userId 전달
      if (platformStats) {
        const { cart, order } = platformStats; // cart와 order만 사용
        setData({ cart, order });
      }
    };

    fetchData();
  }, [userId]);

  if (!data) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
      </div>
    );
  }

  const cartData = [
    data.cart[0].GS25_pickup,
    data.cart[0].GS25_delivery,
    data.cart[1].GS더프레시_pickup,
    data.cart[1].GS더프레시_delivery,
    data.cart[2].wine25,
  ];

  const orderData = [
    data.order[0].GS25_pickup,
    data.order[0].GS25_delivery,
    data.order[1].GS더프레시_pickup,
    data.order[1].GS더프레시_delivery,
    data.order[2].wine25,
  ];

  // 최대값 계산 (여유값 10% 추가)
  const maxDataValue = Math.ceil(Math.max(...cartData, ...orderData) * 1.1);

  const chartData = {
    labels: [
      ["GS25", "픽업"],
      ["GS25", "배달"],
      ["GS더프레시", "픽업"],
      ["GS더프레시", "배달"],
      ["wine25"],
    ],
    datasets: [
      {
        label: "장바구니 수",
        data: cartData,
        backgroundColor: AppColors.freshPrimary,
        borderRadius: 8,
        barThickness: 40,
      },
      {
        label: "구매 수",
        data: orderData,
        backgroundColor: AppColors.accent,
        borderRadius: 8,
        barThickness: 40,
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: "bottom",
        labels: {
          font: {
            size: 14,
          },
          color: AppColors.darkgrey,
        },
      },
    },
    scales: {
      x: {
        grid: {
          display: false,
        },
        ticks: {
          font: {
            size: 14,
          },
          color: AppColors.darkgrey,
        },
      },
      y: {
        beginAtZero: true,
        max: maxDataValue,
        ticks: {
          stepSize: Math.ceil(maxDataValue / 5),
          font: {
            size: 14,
          },
          color: AppColors.darkgrey,
        },
      },
    },
  };

  return (
    <div className="chart-container">
      <Bar data={chartData} options={options} />
    </div>
  );
};

export default ChartCartOrder;
