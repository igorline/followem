import { Button, Flex, Text } from "@chakra-ui/react";
import { ethers } from "ethers";
import { useClaimRewards } from "../../hooks/useClaimRewards";

export const ClaimRewards = () => {
  const { claimable, claimRewards } = useClaimRewards();
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
        <Button onClick={() => claimRewards()}>Claim </Button>
      </Flex>
    </Flex>
  );
};
