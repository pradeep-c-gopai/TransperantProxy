// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BoxV3.sol";

contract MsgSenderContract is BoxV3{

    // Reads the last stored value
    function retrieveMsgSender() public view returns (address, address) {
        return (msg.sender, tx.origin);
    }
}
