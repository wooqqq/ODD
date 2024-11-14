// src/apis/info.js
import axios from "axios";
// 베이스url 추가해야함.
export const fetchUserInfo = async (userId) => {
  try {
    const response = await axios.get(`/api/evaluation/${userId}`);
    return response.data; // { nickname: "가나다", age: 12, gender: "F" }
  } catch (error) {
    console.error("Failed to fetch user info:", error);
    return null;
  }
};
