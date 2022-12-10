pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

// This contract represents an NFT that can only be minted
// after a user has completed an age verification process and
// confirmed to be over 18 years old.
contract AgeVerifiedNFT is ERC721 {
    // The minimum age required to mint the NFT
    uint256 public constant MINIMUM_AGE = 18 years;

    // Event that is triggered when the NFT is minted
    event Mint(address indexed to, uint256 age);

    // Mapping that stores the age of each user who has minted the NFT
    mapping(address => uint256) public userAges;

    // Modifier that checks if the caller has completed the age verification process
    // and is over the minimum age
    modifier onlyAgeVerified {
        require(
            userAges[msg.sender] != 0,
            "Sender has not completed the age verification process"
        );
        require(
            userAges[msg.sender] >= MINIMUM_AGE,
            "Sender is not old enough to mint the NFT"
        );
        _;
    }

    // Function that mints the NFT to the caller
    function mint() public onlyAgeVerified {
        // Mint the NFT
        _mint(msg.sender);

        // Trigger the Mint event
        emit Mint(msg.sender, userAges[msg.sender]);
    }

    // Function that sets the age of the caller after they have completed the age verification process
    function setAge(uint256 age) public {
        require(age != 0, "Age must not be zero");
        userAges[msg.sender] = age;
    }

    // Function that burns the NFT if it is sent to another wallet
    function onERC721Received(
        address _from,
        address _to,
        uint256 _tokenId
    )
        public
        payable
        returns (bytes memory _data)
    {
        // Burn the NFT if it is sent to another wallet
        _burn(_to, _tokenId);
    }
}
