contract L2Campaign {
    uint256 public immutable commision;
    mapping(bytes32 => address) claims;

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

    function claim(address minter, uint256 tokenId) public {
        //This campaign only supports hardcoded mint but of course campaign can add more selectors on their behalf
        bytes memory _calldata = abi.encodeWithSignature(
            "mint(address,uint256)",
            minter,
            tokenId
        );

        bytes32 calldataHash = keccak256(_calldata);

        bytes32 expectedAddHash = keccak256(
            abi.encode(address(this), calldataHash, msg.sender)
        );

        require(claims[expectedAddHash] == msg.sender, "unauthorized");

        //Reset claim
        claims[expectedAddHash] = address(0);

        address(msg.sender).transfer(commision);
    }
}
