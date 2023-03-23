import { Box, Heading } from "@chakra-ui/react";
import { useEffect } from "react";
import { Header } from "../../components/Header/Header";
import { useGetCampaigns } from "../../hooks/useGetCampaigns";
import { CampaignTile } from "./CampaignTile";

export const AllCampaigns = () => {
  const { campaigns } = useGetCampaigns();

  return (
    <Box>
      <Header />
      <Box px="8rem">
        <Heading>All Campaigns</Heading>
        <Box p="4" pt="16"></Box>
        {campaigns.map((campaign) => (
          <CampaignTile campaign={campaign} />
        ))}
      </Box>
    </Box>
  );
};
