import { Box, Heading, Text } from "@chakra-ui/react";
import { Header } from "../../components/Header/Header";
import Apes from "./Apes.json";
import { ApeTile } from "./ApeTile";
import { LastMinterSection } from "./LastMinterSection";

const MintPage = () => {
  return (
    <Box>
      <Header />
      <Box px="8rem">
        <Heading>Mint Page</Heading>
        <Box p="4" pt="16">
          <ApeTile ape={Apes.collection[0]} />
        </Box>
        <Box p="4" pt="4">
          <LastMinterSection />
        </Box>
      </Box>
    </Box>
  );
};

export default MintPage;
