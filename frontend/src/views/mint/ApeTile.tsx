import { Box, Image, Flex, Text, Button, Circle } from "@chakra-ui/react";
import { ethers } from "ethers";
import { useAd } from "../../hooks/useAd";
import Blockies from "react-blockies";
import { Advertiser } from "../../contracts";
export interface Ape {
  tokenId: number;
  image: string;
  traits: object;
}

export const ApeTile = ({ ape }: { ape: Ape }) => {
  const { consumeAd } = useAd();
  const onMint = () => consumeAd(ethers.utils.parseEther("0.08"));
  return (
    <Box>
      <Text align="center" fontSize="4xl" fontWeight="900">
        Bored Ape Yacht Club
      </Text>
      <Flex justifyContent="space-around">
        <Flex alignItems="center">
          <Text>Ref: </Text>
          <Box w="2" />
          <Blockies className="identicon-circle" seed={Advertiser} />
          <Box w="2" />
          <Text fontFamily="satoshi" align="center">
            {Advertiser.slice(0, 6)}...{Advertiser.slice(-4)}
          </Text>
        </Flex>
      </Flex>
      <Box h="2rem" />

      <Flex>
        <Image src={ape.image} maxW="50%" />
        <Box w="4rem" />
        <Flex direction="column" justify="space-between">
          <Text>
            The Bored Ape Yacht Club is a collection of 10,000 unique Bored Ape
            NFTs— unique digital collectibles living on the Ethereum blockchain.
          </Text>
          <Flex>
            <Text fontWeight="bold" alignItems="start." textAlign="start">
              32 Minted |
            </Text>

            <Text fontWeight="cold" alignItems="start." textAlign="start">
              6d 23h 59min
            </Text>
          </Flex>
        </Flex>
      </Flex>
      <Box h="2rem" />
      <Flex w="100%" justifyContent="center">
        <Button backgroundColor="#DFCEBA" w="75%" onClick={onMint}>
          Mint 0.08 ETH
        </Button>
      </Flex>
      <Box h="4rem" />
    </Box>
  );
};
