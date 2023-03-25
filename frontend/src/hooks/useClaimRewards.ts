import { ethers } from "ethers";
import { useEffect, useState } from "react";
import { useAccount, useProvider, useSigner } from "wagmi";
import { CampaignContract } from "../contracts";

export const useClaimRewards = () => {
  const provider = useProvider({ chainId: 420 });
  const { address } = useAccount();

  const [claimable, setclaimable] = useState("0");

  useEffect(() => {
    const fetchClaimable = async () => {
      const contract = new ethers.Contract(CampaignContract, ["function balances(address) view returns (uint)"], provider!);

      const claimable = await contract.balances(address);
      console.log(claimable);
      setclaimable(ethers.utils.formatEther(claimable));
    };
    fetchClaimable();
  }, [provider]);

  const claimRewards = () => {};

  return { claimable, claimRewards };
};
