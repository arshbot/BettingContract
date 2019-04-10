# BettingContract
## Environment
1. Truffle v5.0.7
1. Solidity 0.5.0
* may have bugs, but is otherwise fully functional
## Tests So Far
1. `truffle compile`
1. `truffle develop`
1. `migrate --reset`
1. `Betting.deployed(100).then((b) => {bet = b;})`
1. `bet.makeBet("purple", {value: '1000'}) // fails`
1. `bet.startBet(100)`
1. `bet.makeBet("purple", {value: '1000'}) // passes`
1. `bet.endBet("blue")`
1. `bet.makeBet("purple", {value: '1000'}) // fails`
1. `bet.startBet(1)`
1. `bet.makeBet("purple", {value: '1000'}) // fails probably`
1. `bet.endBet("blue") // need to end the bet, as it doesn't end itself. will update later`
1. `bet.startBet(100)`
1. `bet.makeBet("purple", {value: '1'}) // fails`
<br /> 
Works/Compiles. Updated for Solidity 5.0.
