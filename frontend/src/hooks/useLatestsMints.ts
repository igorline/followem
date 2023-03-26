import { ethers } from "ethers";
import { Result } from "ethers/lib/utils.js";
import { useEffect, useState } from "react";
import { useProvider } from "wagmi";
import { BAYC, L1Forwarder } from "../contracts";

export const useLatestsMints = () => {
  const provider = useProvider();
  const [mints, setMints] = useState<Result>([]);

  useEffect(() => {
    const fetchLatestsMints = async () => {
      const contract = new ethers.Contract(BAYC, ["event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)"], provider!);

      console.log("startevents");
      //We're going to query the last 100000 blocks
      const blocks = 100000;
      const blockNr = await provider.getBlockNumber();
      const events = await contract.queryFilter("Transfer", blockNr - blocks, blockNr);

      console.log(events);

      setMints(
        events
          //Filter mints from forwarder
          .filter((e) => e.args!.from !== ethers.constants.AddressZero)
          .slice(-5)
          .reverse()
          .map((e) => ({ ...e.args, txHash: e.transactionHash, blockNr: e.blockNumber }))
      );
    };
    fetchLatestsMints();
  }, [provider]);

  return mints;
};
