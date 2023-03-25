import { Box, Flex, Text, Image } from "@chakra-ui/react";
import { ConnectButton } from "@rainbow-me/rainbowkit";

import followme from "./followme.svg";

export const Header = () => {
  return (
    <Flex  justifyContent="space-between">
      <Image src={followme}></Image>
      <Flex justifyContent="end" pt="2" px="4">
        <ConnectButton />
      </Flex>
    </Flex>
  );
};
