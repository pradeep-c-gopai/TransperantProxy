// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public organizer; // Address of the organizer
    uint256 public registrationFee; // Fee required for registration
    uint256 public maxPlayers; // Maximum number of players allowed
    uint256 public registrationDeadline; // Deadline for registration
    uint256 public totalPlayers; // Total number of players registered
    uint256 public totalPool; // Total amount of funds collected as registration fees
    bool public gameStarted; // Flag indicating if the game has started
    uint256 winnerIndex = 0; // Initialize winner index

    struct Player {
        uint256 lotteryId; // Unique ID for each player
        address playerAddress; // Address of the player
    }

    Player[] public players; // Array to store player information
    uint256[] public ranks;
    mapping(uint256 => address) public lotteryIdToWinner; // Mapping of lottery IDs to winner addresses
    mapping(address => uint) public prizeToWinners;

    address[] winnerAddresses = new address[](50); // Initialize array to store 50 winners' addresses
    mapping(address => uint256) winnerToRank; // Mapping to store rank to winner's address
    mapping(address => bool) selectedPlayers; // Mapping to track selected players

    event PlayerRegistered(address indexed player, uint256 indexed lotteryId); // Event emitted when a player registers
    event GameStarted(); // Event emitted when the game starts
    event WinnersAnnounced(address[] winners); // Event emitted when winners are announced
    event PrizeDistributed(address indexed winner, uint256 amount); // Event emitted when a prize is distributed

    modifier onlyOrganizer() {
        require(
            msg.sender == organizer,
            "Only organizer can call this function"
        ); // Modifier to allow only the organizer to call certain functions
        _;
    }

    constructor(
        uint256 _registrationFee,
        uint256 _maxPlayers,
        uint256 _registrationDeadline
    ) {
        organizer = msg.sender; // Set the organizer as the contract deployer
        registrationFee = _registrationFee; // Set the registration fee
        maxPlayers = _maxPlayers; // Set the maximum number of players
        registrationDeadline = block.timestamp + _registrationDeadline; // Set the registration deadline
    }

    function register() external payable {
        require(!gameStarted, "Game already started"); // Ensure game has not started yet
        require(totalPlayers < maxPlayers, "Max players reached"); // Ensure maximum players not reached
        require(msg.value == registrationFee, "Incorrect registration fee"); // Ensure correct registration fee paid
        require(
            block.timestamp < registrationDeadline,
            "Registration period over"
        ); // Ensure registration period not over

        uint256 lotteryId = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp))
        ); // Generate unique lottery ID for the player
        players.push(Player(lotteryId, msg.sender)); // Add player to players array
        totalPlayers++; // Increment total players count

        emit PlayerRegistered(msg.sender, lotteryId); // Emit PlayerRegistered event

        if (totalPlayers == maxPlayers) {
            gameStarted = true; // If maximum players reached, start the game
            emit GameStarted(); // Emit GameStarted event
        }
    }

    function startGame() external onlyOrganizer {
        require(!gameStarted, "Game already started"); // Ensure game has not started yet
        require(totalPlayers == maxPlayers, "Not enough players registered"); // Ensure enough players registered

        gameStarted = true; // Start the game
        emit GameStarted(); // Emit GameStarted event
    }

    function calculateWinners() external onlyOrganizer {
        require(gameStarted, "Game not started yet"); // Ensure game has started
        require(
            block.timestamp >= registrationDeadline,
            "Registration period not over yet"
        ); // Ensure registration period over
        require(totalPlayers >= 50, "Not enough players to select 50 winners"); // Ensure there are enough players to select 50 winners

        while (winnerIndex < 50) {
            uint256 randomIndex = uint256(
                keccak256(abi.encodePacked(block.timestamp, winnerIndex))
            ) % totalPlayers;
            address winnerAddress = players[randomIndex].playerAddress;

            if (!selectedPlayers[winnerAddress]) {
                selectedPlayers[winnerAddress] = true;

                uint256 rank;
                do {
                    rank =
                        ((
                            uint256(
                                keccak256(
                                    abi.encodePacked(
                                        block.timestamp,
                                        winnerIndex
                                    )
                                )
                            )
                        ) % 50) +
                        1; // Generate a random rank between 1 to 50
                } while (isRankAlreadyAssigned(rank, ranks)); // Ensure the rank is unique
                ranks[winnerIndex] = rank;
                winnerToRank[winnerAddress] = rank; // Assign the winner's address to the rank
                winnerAddresses[winnerIndex] = winnerAddress; // Store player's address
                winnerIndex++; // Increment winner index
            }
        }

        emit WinnersAnnounced(winnerAddresses); // Emit WinnersAnnounced event
    }

    function isRankAlreadyAssigned(
        uint256 _rank,
        uint256[] memory _ranks
    ) internal pure returns (bool) {
        for (uint256 i = 0; i < _ranks.length; i++) {
            if (_ranks[i] == _rank) {
                return true;
            }
        }
        return false;
    }

    function distributePrizes(uint256[] memory winners) internal {
        uint256 organizerCut = (totalPool * 5) / 100; // Calculate organizer's cut (5% of total pool)
        uint256 poolRemaining = totalPool; // Initialize remaining pool

        for (uint256 i = 0; i < winners.length; i++) {
            // Iterate over winners to distribute prizes
            uint256 prize = (poolRemaining * (winners.length - i)) / 100; // Calculate prize for the winner (decremental distribution)
            // payable(lotteryIdToWinner[winners[i]]).transfer(prize); // Transfer prize to winner
            prizeToWinners[lotteryIdToWinner[winners[i]]] = prize; // Allot prize for each winner
            emit PrizeDistributed(lotteryIdToWinner[winners[i]], prize); // Emit PrizeDistributed event
            poolRemaining -= prize; // Update remaining pool
        }

        payable(organizer).transfer(organizerCut); // Transfer organizer's cut
    }

    function withdraw() external {
        bool isWinner = false;

        if (prizeToWinners[msg.sender] >= 0) {
            isWinner = true;
        } else {
            revert();
        }

        require(isWinner, "You are not a winner");

        payable(msg.sender).transfer(prizeToWinners[msg.sender]);
    }
}
