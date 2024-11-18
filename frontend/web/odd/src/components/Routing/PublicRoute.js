import { Navigate } from "react-router-dom";
import useAdminStore from "../../stores/adminStore";

const PublicRoute = ({ children }) => {
  const isLogin = useAdminStore((state) => state.isLogin);

  if (isLogin) {
    // 로그인 o -> 대시보드 페이지로 이동
    return <Navigate to="/dashboard/item" replace />;
  }

  return children;
};

export default PublicRoute;
