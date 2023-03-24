import { ethers } from "ethers";
import { Result } from "ethers/lib/utils.js";
import { useEffect, useState } from "react";
import { useBlockNumber, useProvider } from "wagmi";

export const useGetMetadata = (campaigns: Result) => {
  // TODO: Switch to mainnet
  const provider = useProvider({ chainId: 5 });
  const [names, setNames] = useState<Result>([]);

  // TODO: Use multicall
  useEffect(() => {
    const fetchEvents = async () => {
      for (let campaign of campaigns) {
        console.log("campaign");
        const contract = new ethers.Contract(
          campaign.target,
          ["function name() external view returns(string memory)"],
          provider!
        );

        const name = await contract.name();
        const updatedNames = [...names];
        let index = campaigns.indexOf(campaign);
        updatedNames[index] = name;
        setNames(updatedNames);
        console.log(updatedNames);
      }
    };
    fetchEvents();
  }, [campaigns]);

  return names;
};
