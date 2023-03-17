// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

///This Campaign can be created by party that want's to advertise something on chain
///It has to be funded with some Eth so the rewards can be claimed. We can also built an implementation using ERC20 tokens as well

contract Campaign {
    //The address of the NFT contract
    address public immutable collection;
    //Every id that should be advertised
    mapping(uint256 => bool) public tokensToSell;
    //The commision the advertiser will get
    uint256 public immutable commision;

    //Whenever the advertiser sucessfully brokered a mint he'll get elibile to claim his rewards
    mapping(uint256 => address) public rewards;

    constructor(address _collection, uint256[] _whitlist, uint256 _commision) {
        collection = collection;
        commision = _commision;
        for (uint256 i = 0; i < tokensToSell.length; i++) {
            tokensToSell[_whitlist[i]] = true;
        }
    }

    //This has not necessarily to be transferFrom we could also support mint. Though mint is not part of the ERC721 standard
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        address promoter
    ) public {
        require(tokensToSell[_tokenId], "Item is not whitlisted");
        ///The owner of the token Id has to grant allowance to the Campaign contract
        bool success = ERC721(collection).transferFrom(_from, _to, _value);
        require(success, "Transfer failed");

        //Item has been sold
        //ITs no longer part of the campaign
        tokensToSell[_tokenId] = false;
        //promoter gets the reward
        rewards[_tokenId] = promoter;
        //Emit Events about the transfer
    }

    //The promotern can claim a reward
    function claimreward(uint256 _tokenId) {
        require(claim[tokenId] == msg.sender, "unauthorized");
        //Reset the claim
        claim[tokenId] = address(0);
        //Send the reward to the sender
        address(msg.sender).transfer(commision);
    }
}
