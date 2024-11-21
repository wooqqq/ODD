import React, { useEffect, useState } from "react";
import { Bar } from "react-chartjs-2";
import { fetchAgeGenderReorderData } from "../../apis/Item/AgeGenderApi";
import "./AgeGender.css";

const AgeGender = ({ platform }) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetchAgeGenderReorderData(platform);
        setData(response);
      } catch (err) {
        setError(err);
        console.error("데이터 불러오기 오류:", err);
      } finally {
        setLoading(false);
      }
    };

    if (platform) {
      fetchData();
    }
  }, [platform]);

  if (loading) return <div>로딩 중...</div>;
  if (error)
    return <div>오류가 발생했습니다. 데이터를 불러올 수 없습니다.</div>;

  // 데이터 준비
  const chartData = {
    labels: ["10대", "20대", "30대", "40대", "기타"],
    datasets: [
      {
        label: "여성",
        data: [
          data.female.teens,
          data.female.twenties,
          data.female.thirties,
          data.female.forties,
          data.female.other,
        ],
        backgroundColor: "rgba(255, 99, 132, 0.6)",
      },
      {
        label: "남성",
        data: [
          data.male.teens,
          data.male.twenties,
          data.male.thirties,
          data.male.forties,
          data.male.other,
        ],
        backgroundColor: "rgba(54, 162, 235, 0.6)",
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: true,
        position: "top",
        labels: {
          font: {
            size: 14,
          },
        },
      },
    },
    scales: {
      x: {
        stacked: true,
        ticks: {
          font: {
            size: 12,
          },
        },
      },
      y: {
        stacked: true,
        beginAtZero: true,
        ticks: {
          font: {
            size: 12,
          },
        },
      },
    },
  };

  return (
    <div className="age-gender-chart">
      <Bar data={chartData} options={options} />
    </div>
  );
};

export default AgeGender;
