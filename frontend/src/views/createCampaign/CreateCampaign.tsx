import { Box, Button, Flex, Heading, Input, Select, Text } from "@chakra-ui/react";
import { SingleDatepicker } from "chakra-dayzed-datepicker";
import { BigNumber, ethers } from "ethers";
import { useState } from "react";
import { Header } from "../../components/Header/Header";
import { BAYC } from "../../contracts";
import { useCreateCampaign } from "../../hooks/useCreateCampaign";

export const CreateCampaign = () => {
  const { deployCampaign } = useCreateCampaign();

  const onCreateCampaign = async () => {
    await deployCampaign(ethers.utils.parseEther(commision), target, BigNumber.from(date.getTime() * 2), ethers.utils.parseEther(totalReward));
  };

  const [target, setTarget] = useState<string>(BAYC);
  const [commision, setCommision] = useState<string>("0.00001");
  const [totalReward, setTotalReward] = useState<string>("0.001");

  const [date, setDate] = useState(new Date());
  return (
    <Box background="#F7F5F6" minH="100vh" px="2rem" pt="1rem">
      <Header />
      <Flex alignItems="center" direction="column">
        <Box  pt="16" w="100%" maxW="1200px">
          <Heading textAlign="center">Create  Campaign</Heading>
          <Box pt="8" />
          <Box>
            <Text>Specifiy advertised Contract</Text>
            <Input backgroundColor="white" value={target} onChange={(e) => setTarget(e.target.value)} type="text" placeholder="" />
          </Box>
          <Box h="4" />
          <Box>
            <Text>Contract preset</Text>
            <Select backgroundColor="white">
              <option>NFT</option>
            </Select>
          </Box>
          <Box h="4" />
          <Box>
            <Text>User aquision Reward</Text>
            <Flex>
              <Input backgroundColor="white" value={commision} onChange={(e) => setCommision(e.target.value)} type="number" placeholder="0x..." />
              <Box w="4" />
              <Text alignSelf="center">ETH</Text>
            </Flex>
          </Box>
          <Box h="4" />
          <Box>
            <Text>Total reward amount</Text>
            <Flex>
              <Input backgroundColor="white" value={totalReward} onChange={(e) => setTotalReward(e.target.value)} type="number" placeholder="0x..." />
              <Box w="4" />
              <Text alignSelf="center">ETH</Text>
            </Flex>
          </Box>
          <Box>
            <Box h="4" />
            <Text>Deadline</Text>
            <Box w="50%">
              <SingleDatepicker name="date-input" date={date} onDateChange={setDate} />
            </Box>
          </Box>
          <Box h="8" />
          <Button w="100%" textColor="white" background="black" onClick={onCreateCampaign}>
            Deploy
          </Button>
        </Box>
      </Flex>
    </Box>
  );
};
