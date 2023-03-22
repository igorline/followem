import { Box, Heading, Input, Select, SelectField } from "@chakra-ui/react";
import { Header } from "../../components/Header/Header";
import { Text } from "@chakra-ui/react";
import { SingleDatepicker } from "chakra-dayzed-datepicker";
import { useState } from "react";
export const CreateCampaign = () => {
    const [date, setDate] = useState(new Date());
  return (
    <Box>
      <Header />
      <Box px="8rem">
        <Heading>Create new Campaign</Heading>
        <Box p="4" pt="16">
          <Box>
            <Text>Specifiy advertised Contract</Text>
            <Input type="text" placeholder="0x..." />
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
            <Input type="text" placeholder="" />
          </Box>
          <Box h="4" />
          <Box>
            <Text>Total reward in ETH</Text>
            <Input type="text" placeholder="" />
          </Box>
          <Box>
            <Text>Deadline</Text>
            <SingleDatepicker name="date-input" date={date} onDateChange={setDate} />
          </Box>
        </Box>
      </Box>
    </Box>
  );
};
