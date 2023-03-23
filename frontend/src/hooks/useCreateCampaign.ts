import { BigNumber, ethers } from "ethers";
import { useSigner } from "wagmi";
import { L2CampaingFactory } from "../contracts";

export const useCreateCampaign = () => {
  const { data: signer } = useSigner();

  const deployCampaign = async (commision: BigNumber, target: string, totalReward: BigNumber) => {
    const contract = new ethers.Contract(L2CampaingFactory, ["function deployCampaign(uint256 _commission,address _target) external payable"], signer!);

    const deployRes = await contract.deployCampaign(commision, target, { value: totalReward });
    console.log("deployRes", deployRes);
  };

  return { deployCampaign };
};
