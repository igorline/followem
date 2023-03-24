import { Card, Text, Image } from "@chakra-ui/react";
import { Result } from "ethers/lib/utils.js";

export const CampaignTile = ({
  campaign,
  title,
}: {
  campaign: Result;
  title: String | undefined;
}) => {
  const {
    author,
    campaign: campaignAddress,
    commission,
    target,
    totalReward,
  } = campaign;
  return (
    <Card direction={{ base: "column", sm: "row" }}>
      <Image
        objectFit="cover"
        maxW={{ base: "100%", sm: "200px" }}
        src="https://ipfs.io/ipfs/QmPbxeGcXhYQQNgsC6a36dDyYUcHgMLnGKnF8pVFmGsvqi"
        alt="Caffe Latte"
      />
      <Text>{title || campaignAddress}</Text>
      <Text>{author}</Text>
      <Text>{commission.toString()}</Text>
      <Text>{target}</Text>
      <Text>{totalReward.toString()}</Text>
    </Card>
  );
};
