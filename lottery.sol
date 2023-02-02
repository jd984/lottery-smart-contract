// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract lottery {
    address public manager;
    address payable[] public participantes;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value >= 0.1 ether);
        participantes.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participantes.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participantes.length >=3);
        uint r = random();
        address payable winner;
        uint index = r % participantes.length;
        winner = participantes[index];
        winner.transfer(getBalance());
        participantes = new address payable[](0);
    }
}