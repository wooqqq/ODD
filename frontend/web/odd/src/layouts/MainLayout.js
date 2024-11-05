import Sidebar from "../components/Sidebar";
import { Outlet } from "react-router-dom";
import "./MainLayout.css";
import Header from "../components/Header";

const MainLayout = () => {
  return (
    <div className="layout">
      <Sidebar />
      <Header />
      <div className="main">
        <Outlet />
      </div>
    </div>
  );
};

export default MainLayout;
