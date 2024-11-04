import {
  createBrowserRouter,
  RouterProvider,
  Navigate,
} from "react-router-dom";
import Login from "./pages/Admin/Login";
import UserTotal from "./pages/Dashboard/UserTotal";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Navigate to="/login" replace />,
  },
  {
    path: "/login",
    element: <Login />,
  },
  {
    path: "/user/total",
    element: <UserTotal />,
  },
]);

function App() {
  return <RouterProvider router={router} />;
}

export default App;
