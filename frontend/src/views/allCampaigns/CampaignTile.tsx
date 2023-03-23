import { Box, Flex, Text } from "@chakra-ui/react";
import { Result } from "ethers/lib/utils.js";

export const CampaignTile = ({ campaign }: { campaign: Result }) => {
  const { author, campaign: campaignAddress, commission, target, totalReward } = campaign;
  return (
    <Flex>
      <Text>{author}</Text>
      <Text>{campaignAddress}</Text>
      <Text>{commission.toString()}</Text>
      <Text>{target}</Text>
      <Text>{totalReward.toString()}</Text>
    </Flex>
  );
};
