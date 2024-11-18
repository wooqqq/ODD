import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

export const login = async (id, password) => {
  try {
    const url = `${BASE_URL}/user/login`;

    const response = await axios.post(url, {
      id,
      password,
    });

    console.log("로그인 요청 성공:", response.data);
    return response.data;
  } catch (e) {
    console.log("로그인 요청 실패:", e.message);
    return e;
  }
};
