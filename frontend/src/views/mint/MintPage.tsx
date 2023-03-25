import { Box, Flex, Heading } from "@chakra-ui/react";
import { Header } from "../../components/Header/Header";
import { ClaimRewards } from "../claim/ClaimRewards";
import Apes from "./Apes.json";
import { ApeTile } from "./ApeTile";
import { LastMinterSection } from "./LastMinterSection";

const MintPage = () => {
  return (
    <Box minH="100vh">
      <Box borderRadius="20px" px="2rem" pt="1rem" background="radial-gradient(104.26% 162.52% at 1.71% 2.96%, #F7F5F6 64.06%, #F7E3D2 100%)">
        <Header />
        <Flex alignItems="center" flexDirection="column">
          <Box pt="16" w="100%" maxW="1200px">
            <ApeTile ape={Apes.collection[0]} />
          </Box>
        </Flex>
      </Box>
      <Box h="1rem" />
      <ClaimRewards />
      <Box h="1rem" />
      <LastMinterSection />
    </Box>
  );
};

export default MintPage;
