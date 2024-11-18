import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

export const userSearch = async (email) => {
  try {
    const response = await axios.get(`${BASE_URL}/evaluation/search/${email}`);

    console.log("회원검색 성공:", response.data);
    return response.data;
  } catch (error) {
    console.error("회원검색 요청 실패:", error);
    throw error;
  }
};
