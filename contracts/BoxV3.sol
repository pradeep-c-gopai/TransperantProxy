// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './BoxV2.sol';

contract BoxV3 is BoxV2{

    event incr(string statement);

    function _increement() public {
        increement();
        emit incr("increemented value");
    }
}