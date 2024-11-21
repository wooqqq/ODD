import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

export const CategoryCount = async (platform) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/dashboard/item/categories/stats`,
      {
        params: {
          data: "odd",
          platform: platform,
          category: "전체",
        },
      }
    );

    console.log("카테고리 데이터 요청 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("카테고리 데이터 요청 오류", e);
    throw e;
  }
};
