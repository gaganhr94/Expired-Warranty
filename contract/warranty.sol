// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTWarranty is ERC721URIStorage 
{
    constructor() ERC721("NFTWarranty", "NFTW") {}

    // This struct defines a data type for variables to store details of sellers/retailers
    struct seller              
    {
        uint256 id;             // Unique ID of the seller
        uint256 itemCounter;    // Variable to store number of items under a seller 
        address owner;          // Stores the address of the account that owns the retailer
        uint256 [] allNFTs;     //  
    }


    // This struct defines a data type for variables to store details of individual warranties
    struct warrantyDetails      
    {
        uint256 tokenId;        // Unique ID of each token  
        bytes32 verifyHash;     // Keccak256 hash for verification purposes
        uint256 creationTime;   // Time of creation of the warranty
        string productId;       // Product ID of the item represented by the token
        string imageURI;
        uint256 expiry;         // Date of expiry
        address[] buyers;       // A list of all the addresses of all the people who have bought the item before
        uint256[] buyersDate;   // A list of dates on which the item was bought
        NFTStatus status;       // Enum to store the current status of the NFT Warranty
    }


    // This enum is to mention the current status of the token. An instance of it is used within warrantyDetails
    enum NFTStatus
    {
        Pending,
        Verified,
        Active,
        Expired
    }
    

    uint256 [] public totalSellers;                                                             // Stores all the seller IDs of all use
    mapping (address => uint256) public addressToSellerId;                                      // Maps the addresses of sellers to their Seller IDs
    mapping (uint256 => seller) public allSellers;                                              // Maps seller ID to variable containing seller info 
    mapping (uint256 => mapping(uint256 => warrantyDetails)) public sellerWarrantyDetails;      // Maps seller ID to a (mapping of token ID and the token details/warranty details)
    mapping (uint256 => mapping(uint256 => string)) public tokenURIList;                        
    mapping (address => uint256[]) public buyersCollection;
    mapping (address => uint256) public buyersCount;                                            // Maps  



    function verifyOwnership(string memory productId, uint256 sellerId, uint256 tokenId) public returns(bool)
    {
        if(sellerWarrantyDetails[sellerId][tokenId].verifyHash == keccak256(abi.encode(msg.sender,productId)))       // We obtain a token from the mapping, and check if the hash in it is the same as that of sender
        {
            sellerWarrantyDetails[sellerId][tokenId].status = NFTStatus.Verified;                                           // After checking verifyHash, the token is set to "verified"                  
            return true;
        }

        else 
        {
            return false;
        }
    }



    function claimNMint(uint256 sellerId, uint256 tokenId) public 
    {
        require( sellerWarrantyDetails[sellerId][tokenId].status == NFTStatus.Verified );          // Throws an error if the given token hasn't been verified            
        _mint(msg.sender, tokenId);                                                                // 
        _setTokenURI(tokenId, tokenURIList[sellerId][tokenId]); 
        sellerWarrantyDetails[sellerId][tokenId].status =  NFTStatus.Active;
    }



    function createSeller(uint256 sellerId) public
    {
        require(allSellers[sellerId].owner == address(0x0), "This seller already exists");         // Checks if the given seller ID is equal to 0x0, i.e, it isn't associated with any address. 
        seller memory newSeller;                                                                   // This creates a variable of type seller to store the seller details.
        newSeller.id = sellerId;                                                                   // Sets the seller ID to whatever we give
        newSeller.owner = msg.sender;                                                              // Sets the owner of the seller ID to the account that is making the creation request
        newSeller.itemCounter = 0;                                                                 // Sets item counter to 0
        allSellers[sellerId] = newSeller;                                                          // Now that the new seller ID has been created, the variable with the new seller details is mapped to the seller ID
        totalSellers.push(sellerId);                                                               // Adds the new seller ID to the list of seller IDs
        addressToSellerId[msg.sender] = sellerId;                                                  // Maps the requesting account's address to the new seller ID.
    }



    function createNFT(string memory tokenURI, uint256 sellerId, string memory productId, address customer, uint256 expiry, string memory imageURI) public returns(uint256)
    {
        require(msg.sender == allSellers[sellerId].owner, "Must be the owner");              // Checks if the account trying to create the NFT is the sender metioned by the sender ID
        warrantyDetails memory newNFT;                                                       // Creates a new variable to store details of the warranty.

        newNFT.creationTime = block.timestamp;                                               // Time of creation of the warranty
        newNFT.verifyHash = keccak256( abi.encode(customer,productId) );                     // Creates a hash for later verification
        newNFT.expiry =  newNFT.creationTime + expiry;                                       // Time of expiry of the warranty
        
        uint256 Id = allSellers[sellerId].id * 1000000 + allSellers[sellerId].itemCounter;   // 
        sellerWarrantyDetails[sellerId][Id] = newNFT;
        sellerWarrantyDetails[sellerId][Id].productId = productId;
        allSellers[sellerId].allNFTs.push(Id);
        sellerWarrantyDetails[sellerId][Id].tokenId = Id;
        sellerWarrantyDetails[sellerId][Id].verifyHash = keccak256(abi.encode(customer,productId));
        sellerWarrantyDetails[sellerId][Id].imageURI = imageURI;
        sellerWarrantyDetails[sellerId][Id].buyers.push(customer);
        sellerWarrantyDetails[sellerId][Id].status = NFTStatus.Pending;
        sellerWarrantyDetails[sellerId][Id].buyersDate.push(newNFT.creationTime);
        allSellers[sellerId].itemCounter++;
        buyersCollection[customer].push(Id);
        buyersCount[customer]++;

        tokenURIList[sellerId][Id]=tokenURI;

        return sellerWarrantyDetails[sellerId][Id].tokenId;
    }



    function resell(address to, uint256 tokenId, uint256 sellerId) public
    {
        require(ownerOf(tokenId)==msg.sender,"Not Owner");
        sellerWarrantyDetails[sellerId][tokenId].verifyHash = keccak256(abi.encode(to, sellerWarrantyDetails[sellerId][tokenId].productId));
        sellerWarrantyDetails[sellerId][tokenId].buyers.push(to);
        sellerWarrantyDetails[sellerId][tokenId].buyersDate.push(block.timestamp);

        _transfer(msg.sender, to,tokenId);
    }


    function burn(uint256 tokenId) external
    {
        uint256 sellerId = tokenId/1000000;
        require(block.timestamp>=sellerWarrantyDetails[sellerId][tokenId].expiry);
        _burn(tokenId);
        sellerWarrantyDetails[sellerId][tokenId].status =  NFTStatus.Expired;

    }


    //READ Functions
    function getSellerNFTs(uint256 sellerId) external view returns(uint256[] memory)
    {
        return allSellers[sellerId].allNFTs;
    }



    function getSellers() external view returns(uint256[] memory)
    {
        return totalSellers;
    }


    function getExpiryTime(uint256 sellerId,uint256 tokenId) external view returns (uint256 expiry)
    {
        return sellerWarrantyDetails[sellerId][tokenId].expiry;
    }


    function getCreationTime(uint256 sellerId,uint256 tokenId)external view returns (uint256 creation)
    {
        return sellerWarrantyDetails[sellerId][tokenId].creationTime;
    }


    function getSellerWarrantyDetails(uint256 sellerId,uint256 tokenId)public view returns(warrantyDetails memory)
    {
        return sellerWarrantyDetails[sellerId][tokenId] ;
    }


    function getBuyersCollection(address add,uint256 index)public view returns(uint256)
    {
        return buyersCollection[add][index];
    }

    function getStatus (uint256 sellerId,uint256 tokenId)external view returns (uint256 stat)
    {
        if (sellerWarrantyDetails[sellerId][tokenId].status == NFTStatus.Pending)
        {
            return 0;
        }

        if (sellerWarrantyDetails[sellerId][tokenId].status == NFTStatus.Verified)
        {
            return 1;
        }

        if (sellerWarrantyDetails[sellerId][tokenId].status == NFTStatus.Active)
        {
            return 2;
        }

        if (sellerWarrantyDetails[sellerId][tokenId].status == NFTStatus.Expired)
        {
            return 3;
        }
    }


    function getSellerNFT(uint256 sellerId, uint256 Index)external view returns(uint256)
    {
        return allSellers[sellerId].allNFTs[Index];
    }


    function getSellerNFTSize(uint256 sellerId)external view returns(uint256)
    {
        return allSellers[sellerId].allNFTs.length;
    }
}