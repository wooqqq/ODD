import {
  createBrowserRouter,
  RouterProvider,
  Navigate,
} from "react-router-dom";
import { ROUTES } from "./constants/routes";
import Login from "./pages/Admin/Login";
import User from "./pages/Dashboard/User";
import MainLayout from "./layouts/MainLayout";
import Item from "./pages/Dashboard/Item";
import Evaluation from "./pages/Dashboard/Evaluation";
import ProtectedRoute from "./components/Routing/ProtectedRoute";
import PublicRoute from "./components/Routing/PublicRoute";
import useAdminStore from "./stores/adminStore";
import { useEffect } from "react";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Navigate to={ROUTES.LOGIN} replace />,
  },
  {
    path: ROUTES.LOGIN,
    element: (
      <PublicRoute>
        <Login />
      </PublicRoute>
    ),
  },
  {
    path: ROUTES.DASHBOARD,
    element: (
      <ProtectedRoute>
        <MainLayout />
      </ProtectedRoute>
    ),
    children: [
      {
        path: ROUTES.USER,
        element: <User />,
      },
      {
        path: ROUTES.ITEM,
        element: <Item />,
      },
      {
        path: ROUTES.EVALUATION,
        element: <Evaluation />,
      },
    ],
  },
]);

function App() {
  const resetState = useAdminStore((state) => state.resetState);

  useEffect(() => {
    // 브라우저를 닫을 때 상태 초기화
    const handleBeforeUnload = (event) => {
      if (performance.navigation.type === 0) {
        resetState();
      }
    };

    window.addEventListener("beforeunload", handleBeforeUnload);

    return () => {
      window.removeEventListener("beforeunload", handleBeforeUnload);
    };
  }, [resetState]);

  return <RouterProvider router={router} />;
}

export default App;
