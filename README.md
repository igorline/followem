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