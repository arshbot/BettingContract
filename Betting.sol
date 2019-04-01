pragma solidity 0.4.25;

contract Betting {
    
    struct Bets {
        string colorSelected; //TODO: Change to enum
        uint256 amountBet;
        address gambler;
    }
    
    mapping(bytes32 => Bets) public bets;
    
    function makebet(string _stringSelected) public payable {
        // require(msg.value >= minimumBet);
        bytes32 betId = keccak256(now, msg.sender);
        
        bets[betId].colorSelected = _stringSelected;
        bets[betId].amountBet = msg.value;
        bets[betId].gambler = msg.sender;
        
    }
}
