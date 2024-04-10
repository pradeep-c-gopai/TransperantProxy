// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomNumberGenerator {
    uint256 public constant MAX_NUMBER = 50;
    uint256[] public randomNumbers;
    bool[MAX_NUMBER] public numbersGenerated;

    // Generates a random number between 1 and 50 that is not already in the array and pushes it
    function generateRandomNumber() external {
        require(randomNumbers.length < MAX_NUMBER, "All numbers generated");

        uint256 randomNumber = _generateUniqueRandomNumber();
        randomNumbers.push(randomNumber);
        numbersGenerated[randomNumber] = true;
    }

    // Returns the array of random numbers
    function getRandomNumbers() external view returns (uint256[] memory) {
        return randomNumbers;
    }

    // Internal function to generate a unique random number
    function _generateUniqueRandomNumber() internal view returns (uint256) {
        uint256 remainingNumbers = MAX_NUMBER - randomNumbers.length;
        uint256 randomIndex = _random(remainingNumbers);

        uint256 count = 0;
        for (uint256 i = 1; i <= MAX_NUMBER; i++) {
            if (!numbersGenerated[i]) {
                count++;
                if (count == randomIndex) {
                    return i;
                }
            }
        }

        revert("Failed to generate unique random number");
    }

    // Internal function to generate a random number
    function _random(uint256 _max) internal view returns (uint256) {
        return uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, _max)
            )
        ) % _max + 1;
    }
}
