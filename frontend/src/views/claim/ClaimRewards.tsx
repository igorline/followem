import { ExternalLinkIcon } from "@chakra-ui/icons";
import { Box, Button, Flex, Text } from "@chakra-ui/react";
import { ethers } from "ethers";
import { useState } from "react";
import { useClaimRewards } from "../../hooks/useClaimRewards";

export const ClaimRewards = () => {
  const { claimable, claimRewards } = useClaimRewards();

  const [txHash, setTxHash] = useState<string | null>(null);

  const onClaim = async () => {
    setTxHash(null);
    const txHash = await claimRewards();
    setTxHash(txHash);
  };

  const goToEtherscan = () => {
    window.open(`https://optimistic.etherscan.io/tx/${txHash}`, "_blank");
  };
  return (
    <Flex
      borderRadius="20px"
      direction="column"
      alignItems="center"
      py="1rem"
      background="radial-gradient(104.26% 162.52% at 1.71% 2.96%, #F7E3D2 0%, #F7F5F6 27.34%, #F7F5F6 65.14%, #F7E3D2 100%) "
    >
      <Text fontWeight="bold">MyRewards ⭐️</Text>
      <Flex alignItems="center">
        <Text fontSize="4xl">{claimable} ETH</Text>
        <Box w="4" />
        <Button backgroundColor="#DFCEBA" onClick={onClaim}>{txHash?"Claimed 🎉":"Claim" } </Button>
      </Flex>
      {txHash && (
        <Flex>
          <Text>View Transaction</Text>
          <Box w="4" />
          <ExternalLinkIcon cursor="pointer" color="black" onClick={goToEtherscan} />
        </Flex>
      )}
    </Flex>
  );
};
