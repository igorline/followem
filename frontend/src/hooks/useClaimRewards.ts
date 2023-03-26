import { BigNumber, ethers } from "ethers";
import { useEffect, useState } from "react";
import { useAccount, useNetwork, useProvider, useSigner, useSwitchNetwork } from "wagmi";
import { CampaignContract } from "../contracts";

export const useClaimRewards = () => {
  const provider = useProvider({ chainId: 420 });
  const { address } = useAccount({});
  const { data: signer } = useSigner({ chainId: 420 });

  const { chain } = useNetwork();
  const { switchNetwork } = useSwitchNetwork();

  const [claimable, setclaimable] = useState("0");

  useEffect(() => {
    const fetchClaimable = async () => {
      const contract = new ethers.Contract(
        CampaignContract,
        ["function commission() view returns (uint)", " function claimableRewards(address) view returns (uint) "],
        provider!
      );

      const [commission, claimable] = await Promise.all([contract.commission(), contract.claimableRewards(address)]);

      const amount = commission.mul(claimable);
      setclaimable(ethers.utils.formatEther(amount));
    };
    fetchClaimable();
  }, [provider, address]);

  const claimRewards = async () => {
    if (chain!.id !== 420) {
      return await switchNetwork!(420);
    }
    const contract = new ethers.Contract(CampaignContract, ["function claim() public payable"], signer!);
    const tx = await contract.claim();
    console.log(tx);
    setclaimable("0");
    return tx.hash;
  };

  return { claimable, claimRewards };
};
