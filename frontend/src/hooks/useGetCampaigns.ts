import { ethers } from "ethers";
import { Result } from "ethers/lib/utils.js";
import { useEffect, useState } from "react";
import { useProvider } from "wagmi";
import { L2CampaingFactory } from "../contracts";
import { useGetMetadata } from "./useGetMetadata";

export const useGetCampaigns = () => {
  const provider = useProvider();
  const [campaigns, setCampaigns] = useState<Result>([]);

  useEffect(() => {
    const fetchEvents = async () => {
      const contract = new ethers.Contract(
        L2CampaingFactory,
        [
          "event CampaignCreated(address indexed target,address indexed author,address campaign,uint256 commission,uint256 totalReward);",
        ],
        provider!
      );
      //We're going to query the last 100000 blocks
      const blocks = 100000;
      const blockNr = await provider.getBlockNumber();

      const events = await contract.queryFilter("*", blockNr - blocks, blockNr);
      setCampaigns(events.map((e) => e.args));
    };
    fetchEvents();
  }, [provider]);

  const names = useGetMetadata(campaigns);
  return { campaigns, names };
};
