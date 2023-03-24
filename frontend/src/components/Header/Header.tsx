import { Box, Flex, Text } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export const Header = () => {
  return (
    <Flex justifyContent="space-between">
      <Text>Follow me</Text>
      <Flex justifyContent="end" pt="2" px="4">
        <ConnectButton />
      </Flex>
    </Flex>
  );
};
