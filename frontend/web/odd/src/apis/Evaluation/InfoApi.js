import axios from "axios";
import useUserStore from "../../stores/userStore";

const baseUrl = process.env.REACT_APP_BASE_URL;

export const fetchUserInfo = async (userId) => {
  try {
    const response = await axios.get(`${baseUrl}/evaluation/${userId}`);

    console.log("사용자 정보 받아오기 성공! ! :", response.data);

    const { setNickname } = useUserStore.getState();
    setNickname(response.data.nickname);

    return response.data;
  } catch (error) {
    console.error("사용자 정보 받아오기 실패 :", error);
    return null;
  }
};
