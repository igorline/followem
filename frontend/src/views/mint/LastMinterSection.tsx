import { Box, Divider, Flex, Text } from "@chakra-ui/react";
import { useLatestsMints } from "../../hooks/useLatestsMints";
import Blockies from "react-blockies";
import { ExternalLinkIcon } from "@chakra-ui/icons";

export const LastMinterSection = () => {
  const mints = useLatestsMints();

  return (
    <Box px="2rem" py="1rem" borderRadius="20px" background="#F7F5F6">
      <Text fontWeight="bold" textAlign="center" fontSize="xl">
        Latest mints:
      </Text>
      <Box>
        {mints.map((mint) => (
          <LatestMinterRow to={mint.to} txHash={mint.txHash} blockNr={mint.blockNr} />
        ))}
      </Box>
    </Box>
  );
};

const LatestMinterRow = ({ to, txHash, blockNr }: { to: any; txHash: any; blockNr: any }) => {
  const goToEtherscan = () => {
    window.open(`https://goerli.etherscan.io/tx/${txHash}`, "_blank");
  };

  return (
    <Box w="100%">
      <Flex justifyContent="space-between" p="2">
        <Flex>
          <Blockies className="identicon-circle" seed={to} />
          <Box w="2" />
          {to}
        </Flex>

        <Flex alignItems="center">
          {blockNr}
          <Box w="2" />

          <ExternalLinkIcon cursor="pointer" color="black" onClick={goToEtherscan} />
        </Flex>
      </Flex>
      <Divider orientation="horizontal" color="grey" />
    </Box>
  );
};
