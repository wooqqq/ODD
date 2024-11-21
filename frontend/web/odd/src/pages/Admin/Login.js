import { useState } from "react";
import "./Login.css";
import logo from "../../assets/images/gsretail-sq.png";
import { useNavigate } from "react-router-dom";
import { ROUTES } from "../../constants/routes.js";
import { login } from "../../apis/LoginApi.js";
import useAdminStore from "../../stores/adminStore";

function Login() {
  const { setLogin } = useAdminStore();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const response = await login(username, password);
      console.log(response)

      if (response.success) {
        // 로그인 성공 시
        console.log("로그인 성공:", response.message);
        setLogin();
        navigate(`${ROUTES.DASHBOARD}/${ROUTES.ITEM}`);
      } else {
        // 로그인 실패 시 에러 메시지 설정
        setError(response.message);
      }
    } catch (err) {
      console.error("로그인 요청 실패:", err);
      setError("로그인 요청에 실패했습니다. 다시 시도해주세요.");
    }
  };
  return (
    <div className="login-container">
      <div className="login-box">
        <img src={logo} className="logo" alt="GS Retail Logo" />
        <h2 className="title">우리동네단골</h2>
        <input
          type="text"
          placeholder="아이디"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          className="input"
        />
        <input
          type="password"
          placeholder="비밀번호"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="input"
        />
        {error && <p className="error-message">{error}</p>}
        <button onClick={handleLogin} className="login-button">
          로그인
        </button>
      </div>
    </div>
  );
}

export default Login;
