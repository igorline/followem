import { Box, Flex } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export const Header = () => {
  return (
    <Flex justifyContent="end" pt="2" px="4">
      <ConnectButton />
    </Flex>
  );
};
