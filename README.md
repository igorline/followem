![Followem](https://github.com/igorline/followem/blob/main/cover.png?raw=true)

# Project Description

Our goal is to help projects increase their revenue by providing a permissionless way to run advertising campaigns on the blockchain.

Imagine a project owner or contributor wants to help mint NFTs in a specific contract. They can create a campaign using our factory contract on an arbitrary L2, specifying the user acquisition reward and the total amount they are willing to pay. Then, anyone can use the generated link or widget to bring in a new audience.

When someone mints an NFT through our forwarder contract, it sends a message using Connext to the L2 campaign contract, which increases the commission to be received by the referral.

As soon as someone has minted the NFTs, relevant promoters can claim the available commission.

This principle can be applied to other value-transferring activities on the blockchain.

Using such a system improves transparency and trust between project owners and promoters. Its permissionless nature also allows anyone to participate and generate value for the project and themselves.

Another interesting property of such a tool would be a standard event that is emitted when someone interacts through the forwarder contract. This would allow for tracking paid promotional activities.

For example, if someone is offered a reward to mint an NFT, people who follow their account for insights, or "alpha," may not know whether the influencer minted the NFT on their own or is being rewarded for it. With such a standard interface, wallet tracking applications would be able to display such paid activities happening on the blockchain.

# Materials

[EthGlobal Submission](https://ethglobal.com/showcase/followem-vbxuz)  
[Presentation](https://www.dropbox.com/s/naz63xu6odbxnor/Followem_presentation.pdf?dl=0)  
[Figma UI](https://www.figma.com/file/HdIwJffDrqs9LojblColb8/followme-screens?node-id=0-1)  

# Technical details

By using L2 networks (Optimism, Polygon and Gnosis) as well as Connext we are able to offload gas costs for the referral system built.

When the campaign is deployed the creator is specifying function signature that would count towards receiving commission.

Our forwarder smart contract on L1 is receiving calldata that is used to call promoted target contract. Tokens received within the interaction are forwarded to the account that originally called the contract and the signature of the method executed on the target contract are posted via connext to L2 where the campaign is deployed. As soon as the message arrives and validates in the campaign contract we unlock commission for the promotion to specified advertiser.

For handling the results of interaction for promoted contracts we implement a router logic which maps function signatures + generic or specific target addresses to deployed contract implementations. Our forwarder contract is using delegatecall to call those implementation staying with the context of its storage.

# Deployments

## L1 GOERLI
AdForwarder : 0x3075fd855E0aB31D02cCed321F883B119cc24271  
TEST BAYC : 0xb1e5c3f7898e46277eefafa0e8732760e07ffe21  

## L2
Optimism CampaignFactory: 0x3B41A4A44a9080937400cd40f3D33A78A99EEB25  
Polygon Mumbai CampaignFactory: 0xB1e5C3f7898E46277EefAFa0E8732760E07ffe21  
Gnosis Chirado CampaignFactory: 0xB1e5C3f7898E46277EefAFa0E8732760E07ffe21  
****
Example BAYC Campaign -> Optimism : 0xc48ff12ED5275dbe8064eA39712118F59BF4b0ED

# Frontend

To play around with the follow me frontend on your local machine

1. Go to the frontend dir ```cd ./frontend```
2. Install npm dependencies ```npm i```
3. Create a .env file based on example.env. Add your own Alchemy ID
4. The file src/contracts.ts links all deployed contracts. Feel free to play around and use your contracts.
5. Run ```npm run start ``` 
   
To use a campaign you've deployed past the campaign url contracts.ts/CampaignContract
To specify the advertisers address change contracts.ts/Advertiser

# Screenshots
![01.jpeg](https://github.com/igorline/Followem/blob/main/01.jpeg?raw=true)
![02.png](https://github.com/igorline/Followem/blob/main/02.png?raw=true)
![03.jpeg](https://github.com/igorline/Followem/blob/main/03.jpeg?raw=true)
![04.jpeg](https://github.com/igorline/Followem/blob/main/04.jpeg?raw=true)
![05.jpeg](https://github.com/igorline/Followem/blob/main/05.jpeg?raw=true)
