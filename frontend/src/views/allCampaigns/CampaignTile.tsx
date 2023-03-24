import { Card, Text, Image } from "@chakra-ui/react";
import { ethers } from "ethers";
import Blockies from "react-blockies";
import { Result } from "ethers/lib/utils.js";

export const CampaignTile = ({
  campaign,
  title,
}: {
  campaign: Result;
  title: String | undefined;
}) => {
  const { author, campaign: campaignAddress, commission } = campaign;
  return (
    <Card direction={{ base: "column", sm: "row" }}>
      <Image
        objectFit="cover"
        maxW={{ base: "100%", sm: "200px" }}
        src="https://ipfs.io/ipfs/QmPbxeGcXhYQQNgsC6a36dDyYUcHgMLnGKnF8pVFmGsvqi"
      />
      <Text>{title || campaignAddress}</Text>
      <Text>{ethers.utils.formatEther(commission.toString())} eth/mint</Text>
      <Text>
        <Blockies seed={author} />
        {author.slice(0, 6)}...{author.slice(-4)}
      </Text>
    </Card>
  );
};
