import { Outlet } from "react-router-dom";
import dashboardStore from "../stores/dashboardStore";
import Sidebar from "../components/Sidebar";
import Header from "../components/Header";
import "./MainLayout.css";

const MainLayout = () => {
  const { selectedMenu } = dashboardStore();

  return (
    <div className="layout">
      <Sidebar setSelectedMenu={selectedMenu} />
      <Header title={selectedMenu} />
      <div className="main">
        <Outlet />
      </div>
    </div>
  );
};

export default MainLayout;
