import "./Sidebar.css";
import gslogo from "../assets/images/gsretail-logo.png";
import {
  LuPieChart,
  LuBarChart4,
  // LuShoppingCart,
  // LuSearch,
  // LuUser,
  LuLogOut,
} from "react-icons/lu";
import { useNavigate } from "react-router-dom";
import { ROUTES } from "../constants/routes";
import dashboardStore from "../stores/dashboardStore";
import useAdminStore from "../stores/adminStore";

const Sidebar = () => {
  const navigate = useNavigate();
  const { changeMenu, selectedMenu } = dashboardStore();
  const { setLogout } = useAdminStore();

  const handleLogout = () => {
    setLogout();
    navigate(ROUTES.LOGIN);
  };

  const handleNavigation = (path, menu) => {
    changeMenu(menu);
    navigate(path);
  };

  return (
    <div className="sidebar">
      <div className="sidebar-logo">
        <img src={gslogo} alt="GS logo" />
        <h3>우리동네단골</h3>
      </div>
      <div className="sidebar-menu">
        {/* <button
          onClick={() =>
            handleNavigation(
              `${ROUTES.DASHBOARD}/${ROUTES.USER}`,
              "사용자 정보"
            )
          }
          className={selectedMenu === "사용자 정보" ? "active" : ""}
        >
          <LuPieChart className="button-icon" />
          <p className="button-title">사용자 정보</p>
        </button> */}

        <button
          onClick={() =>
            handleNavigation(`${ROUTES.DASHBOARD}/${ROUTES.ITEM}`, "대시보드")
          }
          className={selectedMenu === "대시보드" ? "active" : ""}
        >
          <LuBarChart4 className="button-icon" />
          <p className="button-title">대시보드</p>
        </button>

        <button
          onClick={() =>
            handleNavigation(`${ROUTES.DASHBOARD}/${ROUTES.EVALUATION}`, "평가")
          }
          className={selectedMenu === "평가" ? "active" : ""}
        >
          <LuPieChart className="button-icon" />
          <p className="button-title">평가</p>
        </button>
      </div>
      <div className="logout">
        <button onClick={handleLogout}>
          <LuLogOut className="logout-icon" />
          <p className="logout-title">로그아웃</p>
        </button>
      </div>
    </div>
  );
};

export default Sidebar;
