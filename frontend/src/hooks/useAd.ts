import { ethers } from "ethers";
import { useSigner } from "wagmi";
//THE BAYC CONTRACT deployed on goerli

const forwarderContract = "0x0";
const target = "0xb1e5c3f7898e46277eefafa0e8732760e07ffe21";
const l2campaignContract = "0x0";
const advertiser = "0x0";
//optimism goerli
const destinationDomain = "1735356532";

//TODO use connext sdk to determine that fee
const relayerFee = 1;
export const useAd = () => {
  const { data: signer } = useSigner();

  const executeAd = async () => {
    const iface = new ethers.utils.Interface(["function mintApe(uint numberOfTokens) public payable"]);
    //We mint just one ape at the time
    const calldata = iface.encodeFunctionData("mintApe", [1]);
    const contract = new ethers.Contract(
      forwarderContract,
      [
        "function executeAd(address target, uint256 value, bytes calldata, address l2campaignContract, address advertiser, uint256 destinationDomain) public payable",
      ],
      signer!
    );

    await contract.executeAd(target, relayerFee, calldata, l2campaignContract, advertiser, destinationDomain, {
      value: relayerFee,
    });
  };
  return { executeAd };
};
