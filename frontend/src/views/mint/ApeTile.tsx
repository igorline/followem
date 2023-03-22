import { Box, Image, Flex, Text, Button } from "@chakra-ui/react";

export interface Ape {
  tokenId: number;
  image: string;
  traits: object;
}

export const ApeTile = ({ ape }: { ape: Ape }) => {
  return (
    <Box>
      <Text fontSize="2xl" fontWeight="bold">
        Bored Ape Yacht Club
      </Text>
      <Box h="4" />

      <Flex>
        <Image src={ape.image} maxW="50%" />
        <Box w="8" />
        <Flex
          direction="column"
          justify="space-between"
          alignItems="center
      "
        >
          <Text>{JSON.stringify(ape.traits)}</Text>
          <Text>Ref: Igor.eth</Text>
          <Button>Mint 0.08 ETH</Button>
        </Flex>
      </Flex>
    </Box>
  );
};
