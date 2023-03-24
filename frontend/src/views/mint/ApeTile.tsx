import { Box, Image, Flex, Text, Button } from "@chakra-ui/react";
import { useAd } from "../../hooks/useAd";

export interface Ape {
  tokenId: number;
  image: string;
  traits: object;
}

export const ApeTile = ({ ape }: { ape: Ape }) => {
  const { executeAd } = useAd();
  const onMint = () => executeAd();
  return (
    <Box borderRadius="20px" p="4rem" background="radial-gradient(104.26% 162.52% at 1.71% 2.96%, #F7F5F6 64.06%, #F7E3D2 100%)">
      <Text align="center" fontSize="4xl" fontWeight="900">
        Bored Ape Yacht Club
      </Text>
      <Text fontFamily="satoshi" align="center">
        Ref: {}
      </Text>
      <Box h="2rem" />

      <Flex>
        <Image src={ape.image} maxW="50%" />
        <Box w="4rem" />
        <Flex
          direction="column"
          justify="space-between"
          alignItems="center
      "
        >
          <Text>The Bored Ape Yacht Club is a collection of 10,000 unique Bored Ape NFTs— unique digital collectibles living on the Ethereum blockchain.</Text>
        </Flex>
      </Flex>
      <Box h="2rem" />
      <Flex w="100%" justifyContent="center">
        <Button backgroundColor="#DFCEBA" w="75%" onClick={onMint}>
          Mint 0.08 ETH
        </Button>
      </Flex>
    </Box>
  );
};
