import {BigNumber, ethers} from "ethers";
import {useSigner} from "wagmi";
import {L2CampaingFactory} from "../contracts";

export const useCreateCampaign = () => {
  const {data: signer} = useSigner();

  const deployCampaign = async (commision: BigNumber, target: string, deadline: BigNumber, totalReward: BigNumber, signature: string) => {
    const contract = new ethers.Contract(
      L2CampaingFactory,
      ["function deployCampaign(uint256 _commission,address _target,uint256 _deadline, string memory _signature) external payable"],
      signer!
    );

    const deployRes = await contract.deployCampaign(commision, target, deadline, signature, {value: totalReward});
    console.log("deployRes", deployRes);
  };

  return {deployCampaign};
};
