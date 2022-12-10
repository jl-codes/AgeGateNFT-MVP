pragma solidity ^0.5.0;

// Import the ERC721 contract for non-fungible tokens
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

// Import the Persona contract for age verification
import "https://github.com/PersonaIdenity/Persona.sol";

// Create a contract for our NFT
contract MyNFT is ERC721 {
    // Keep track of the age verification contract
    Persona public persona;

    // Define an event that is triggered when an NFT is minted
    event NFTMinted(address owner, uint256 tokenId);

    // Define a constructor that accepts the address of the Persona contract
    constructor(Persona _persona) public {
        // Set the Persona contract address
        persona = _persona;
    }

    // Define a function that mints an NFT for a given user
    function mintNFT(address user) public {
        // Verify that the user has passed the age verification in Persona
        require(persona.isVerified(user), "User has not passed age verification");

        // Mint a new NFT for the user
        uint256 tokenId = _mint(user);

        // Trigger the NFTMinted event
        emit NFTMinted(user, tokenId);
    }

    // Override the ERC721 transfer function to prevent transferring burned NFTs
    function transfer(address to, uint256 tokenId) public {
        // Check if the NFT has been burned
        bool burned = isBurned(tokenId);
        require(!burned, "NFT has been burned and cannot be transferred");

        // Transfer the NFT as usual
        _transfer(to, tokenId);
    }

    // Define a function that burns an NFT
    function burnNFT(uint256 tokenId) public {
        // Only the owner of the NFT can burn it
        require(ownerOf(tokenId) == msg.sender, "Only the NFT owner can burn it");

        // Burn the NFT by setting its owner to the zero address
        _transfer(address(0), tokenId);
    }

    // Define a function that checks if an NFT has been burned
    function isBurned(uint256 tokenId) public view returns (bool) {
        // An NFT is burned if its owner is the zero address
        return ownerOf(tokenId) == address(0);
    }
}
