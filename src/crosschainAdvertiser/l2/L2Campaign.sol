pragma solidity ^0.8.15;

contract L2Campaign {
    uint256 public immutable commision;
    mapping(bytes32 => address) claims;

    constructor(uint256 _commision) {
        commision = _commision;
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external returns (bytes memory) {
        //TODO add proper conversition from bytes to bytes32
        bytes32 adHash = bytes32(_callData);
        claims[adHash] = _originSender;
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
        bytes32 calldataHash = keccak256(_calldata);
        //If all params are correcct the hash will equal the one written be xReceive to the claim function. -> claim is authorized
        bytes32 expectedAddHash = keccak256(
            abi.encode(address(this), calldataHash, msg.sender)
        );

        require(claims[expectedAddHash] == msg.sender, "unauthorized");

        //A claim can only claime once
        claims[expectedAddHash] = address(0);
        //Send the reward to the sender
        payable(address(msg.sender)).transfer(commision);
    }
}
