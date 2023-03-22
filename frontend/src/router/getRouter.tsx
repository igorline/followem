import { createBrowserRouter } from "react-router-dom";
import { CreateCampaign } from "../views/createCampaign/CreateCampaign";
import MintPage from "../views/mint/MintPage";
export const getRouter = () => {
  return createBrowserRouter([
    {
      path: "/",
      element: <MintPage />,
      children: [],
    },
    {
      path: "/create",
      element: <CreateCampaign />,
    },
  ]);
};
