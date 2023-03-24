import { BigNumber, ethers } from "ethers";
import { useSigner } from "wagmi";
import { Advertiser, BAYC, CampaignContract, L1Forwarder } from "../contracts";
//THE BAYC CONTRACT deployed on goerli

//optimism goerli
const destinationDomain = "1735356532";

//TODO use connext sdk to determine that fee
const relayerFee = ethers.utils.parseEther("0.1");
export const useAd = () => {
  const { data: signer } = useSigner();

  const executeAd = async (value: BigNumber) => {
    const iface = new ethers.utils.Interface(["function mintApe(uint numberOfTokens) public payable"]);
    //We mint just one ape at the time
    const calldata = iface.encodeFunctionData("mintApe", [1]);
    const contract = new ethers.Contract(
      L1Forwarder,
      [
        " function executeAd(address target,bytes calldata _calldata,address l2CampaignContract,address advertiser,uint32 destinationDomain,uint256 relayerFee) external payable",
      ],
      signer!
    );

    await contract.executeAd(BAYC, calldata, CampaignContract, Advertiser, destinationDomain, relayerFee, {
      value: value.add(relayerFee),
      gasLimit: 1000000,
    });
  };
  return { executeAd };
};
