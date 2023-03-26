import { BigNumber, ethers } from "ethers";
import { useNetwork, useSigner, useSwitchNetwork } from "wagmi";
import { Advertiser, BAYC, CampaignContract, L1Forwarder } from "../contracts";

//THE BAYC CONTRACT deployed on goerli

//optimism goerli
const destinationChainId = 420;

const originDomain = "1735353714";

export const useAd = () => {
  const { data: signer } = useSigner();
  const { chain } = useNetwork();
  const { switchNetwork } = useSwitchNetwork();

  const consumeAd = async (value: BigNumber) => {
    //For the sake of simplicity we only support goerli in this demo frontend. Of course all chains are supported. But implementing every single chain would increase the complexity of this demo application
    if (chain!.id !== 5) {
      return await switchNetwork!(5);
    }
    const iface = new ethers.utils.Interface(["function mintApe(uint numberOfTokens) public payable"]);
    //We mint just one ape at the time
    const calldata = iface.encodeFunctionData("mintApe", [1]);
    const contract = new ethers.Contract(
      L1Forwarder,
      [
        " function consumeAd(address target,bytes calldata _calldata,address l2CampaignContract,address advertiser,uint32 chainId,uint256 relayerFee) external payable",
      ],
      signer!
    );

    const relayerFee = ethers.utils.parseEther("0.1");

    console.log("go relayer fee", relayerFee);

    const tx = await contract.consumeAd(BAYC, calldata, CampaignContract, Advertiser, destinationChainId, relayerFee, {
      value: value.add(relayerFee),
      gasLimit: 1000000,
    });

    await tx.wait();

    return tx.hash;
  };
  return { consumeAd };
};
