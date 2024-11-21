import { useState, useEffect } from "react";
import { fetchPlatformStats } from "../../apis/Evaluation/ChartApi";
import useUserStore from "../../stores/userStore";
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
import "./ChartVisit.css";
import "../../components/Dashboard/Loading.css";

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const ChartVisit = () => {
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
        setData(platformStats.view);
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

  const chartData = {
    labels: ["GS25", "GS더프레시", "와인25"],
    datasets: [
      {
        label: "접속 수",
        data: data.map((item) => Object.values(item)[0]), // 데이터 매핑
        backgroundColor: AppColors.gsPrimary,
        borderRadius: 8,
        barThickness: 60,
      },
    ],
  };

  const maxDataValue = Math.round(
    Math.max(...data.map((item) => Object.values(item)[0])) * 1.1
  );

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

export default ChartVisit;
