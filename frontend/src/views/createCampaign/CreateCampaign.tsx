import { Box, Button, Heading, Input, Select, Text } from "@chakra-ui/react";
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
    <Box>
      <Header />
      <Box px="8rem">
        <Heading>Create new Campaign</Heading>
        <Box p="4" pt="16">
          <Box>
            <Text>Specifiy advertised Contract</Text>
            <Input value={target} onChange={(e) => setTarget(e.target.value)} type="text" placeholder="" />
          </Box>
          <Box h="4" />
          <Box>
            <Text>Contract preset</Text>
            <Select>
              <option>NFT</option>
            </Select>
          </Box>
          <Box h="4" />
          <Box>
            <Text>User aquision Reward in ETH</Text>
            <Input value={commision} onChange={(e) => setCommision(e.target.value)} type="number" placeholder="0x..." />
          </Box>
          <Box h="4" />
          <Box>
            <Text>Total reward in ETH</Text>
            <Input value={totalReward} onChange={(e) => setTotalReward(e.target.value)} type="number" placeholder="0x..." />
          </Box>
          <Box>
            <Text>Deadline</Text>
            <SingleDatepicker name="date-input" date={date} onDateChange={setDate} />
          </Box>
        </Box>
        <Button onClick={onCreateCampaign}>Create Campaign</Button>
      </Box>
    </Box>
  );
};
