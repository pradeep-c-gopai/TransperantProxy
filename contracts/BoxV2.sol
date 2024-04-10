// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Box.sol';

contract BoxV2 is Box{
    function increement() public {
        store(retrieve()+1);
    }
}