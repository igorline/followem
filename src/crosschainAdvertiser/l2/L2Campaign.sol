pragma solidity ^0.8.15;

contract L2Campaign {
    uint256 public immutable commision;
    address public immutable collection;
    mapping(bytes32 => address) claims;

    constructor(uint256 _commision, address _collection) {
        commision = _commision;
        collection = _collection;
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external returns (bytes memory) {
        (bytes32 adHash, address advertiser) = abi.decode(
            _callData,
            (bytes32, address)
        );
        claims[adHash] = advertiser;
    }

    function claim(address minter, uint256 tokenId) public payable {
        //This campaign only supports hardcoded mint but of course campaign can add more selectors on their behalf
        //In order to claim his reward the advertiser needs to specify which tokenId he wan'ts to claim a reward for.
        //If this is true the calldata will be exactly the same as the one called be the user
        bytes memory _calldata = abi.encodeWithSignature(
            "mint(address,uint256)",
            minter,
            tokenId
        );
        //
        //If all params are correcct the hash will equal the one written be xReceive to the claim function. -> claim is authorized
        bytes32 expectedAddHash = getAddHash(
            collection,
            _calldata,
            address(this),
            msg.sender,
            100
        );
        require(claims[expectedAddHash] == msg.sender, "unauthorized");

        //A claim can only claime once
        claims[expectedAddHash] = address(0);
        //Send the reward to the sender
        payable(address(msg.sender)).transfer(commision);
    }

    function getAddHash(
        address target,
        bytes memory _calldata,
        address l2CampaignContract,
        address adverstiser,
        uint32 destinationDomain
    ) private returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    target,
                    keccak256(_calldata),
                    l2CampaignContract,
                    adverstiser,
                    destinationDomain
                )
            );
    }
}
