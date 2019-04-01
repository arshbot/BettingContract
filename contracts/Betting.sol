pragma solidity ^0.5.0;
contract Betting {
    
    struct Bets {
        string colorSelected; //TODO: Change to enum
        uint256 amountBet;
        address gambler;
    }
    
    mapping(bytes32 => Bets) public bets;
    
    function makebet(string memory _stringSelected ) public payable {
        // require(msg.value >= minimumBet);
        bytes32 betId = bytes32(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        bets[betId].colorSelected = _stringSelected;
        bets[betId].amountBet = msg.value;
        bets[betId].gambler = msg.sender;
    }
}
