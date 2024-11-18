import { Navigate } from "react-router-dom";
import useAdminStore from "../../stores/adminStore";

const ProtectedRoute = ({ children }) => {
  const isLogin = useAdminStore((state) => state.isLogin);

  if (!isLogin) {
    // 로그인 x -> 로그인 페이지로 이동
    return <Navigate to="/login" replace />;
  }

  return children;
};

export default ProtectedRoute;
