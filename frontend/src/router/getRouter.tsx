import { createBrowserRouter } from "react-router-dom";
import MintPage from "../views/mint/MintPage";
export const getRouter = () => {
  return createBrowserRouter([
    {
      path: "/",
      element: <MintPage />,
      children: [],
    },
  ]);
};
