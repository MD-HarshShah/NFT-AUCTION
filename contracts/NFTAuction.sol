// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract NFTAuction{
    address public Auctioneer;
    address public highestbidder;
    uint public highestbid;
    mapping(address => uint) public bids;
    mapping(address=> bool) public isbidder;
    mapping(uint=>bidders) public bidderInfo;
    bool isAuctionCompleted;

    
    // address[] public bidders;
    constructor(){
        Auctioneer=msg.sender;
    }
    struct NFTs{
        ERC721 nft;
        uint tokenid;
        address seller;
        uint startTime;
        uint endTime;
        uint basePrice;   
    }
    struct bidders{
        address bidderaddress;
        uint bidamount;
    } 
    uint public  counter;
    uint public totalbidders;
    mapping (uint => NFTs) public  NFTnum;
    // function CreatNFT(){

    // }

    function CreateAuction(
        address tokenaddress,
        uint _tokenid,
        // uint _startTime,
        uint _endTime,
        uint _basePrice) public {
            counter++;

            NFTnum[counter]=NFTs(ERC721(tokenaddress),_tokenid,msg.sender,block.timestamp,_endTime,_basePrice);
            ERC721(tokenaddress).transferFrom(msg.sender,address(this),_tokenid);

    }
    
    function Bid(uint nftAuctionNum) public payable returns(uint)  {
        NFTs storage currentNFT = NFTnum[nftAuctionNum];
        require(block.timestamp>currentNFT.startTime,"auction not started");
        // require(block.timestamp<currentNFT.endTime,"auction ended");
        require(msg.value>currentNFT.basePrice,"Your bid is not more than current bid");
        totalbidders++;
        bidderInfo[totalbidders]=bidders(msg.sender,msg.value);
        currentNFT.basePrice = msg.value;
        // NFTnum[nftAuctionNum].basePrice =  msg.value;
        bids[msg.sender]+=msg.value;
        highestbidder= msg.sender; 
        highestbid=msg.value; 
        isbidder[msg.sender]=true;
        return currentNFT.basePrice;
    }
    function WithdrawBid(uint nftAuctionNum)public {
         NFTs storage currentNFT = NFTnum[nftAuctionNum];
         require(msg.sender==highestbidder);
         require(block.timestamp>currentNFT.startTime,"auction not started");
         require(block.timestamp<currentNFT.endTime,"auction ended");
         require(isbidder[msg.sender],"not a bidder");
         payable(msg.sender).transfer(99*bids[msg.sender]/100
         );
         bids[msg.sender]=0;
         isbidder[msg.sender]=false;



    }
    // function AuctionCompleted(uint nftAuctionNum) public{
    //     NFTs storage currentNFT = NFTnum[nftAuctionNum];
    //     require(msg.sender==Auctioneer);
    //     require(block.timestamp>=currentNFT.endTime);
    //     if(totalbidders==0)
    //     {
    //       ERC721(currentNFT.nft).transferFrom(address(this),currentNFT.seller,currentNFT.tokenid);  
    //     }
    //     else
    //     {
    //         ERC721(currentNFT.nft).transferFrom(address(this),highestbidder,currentNFT.tokenid);
    //         payable(currentNFT.seller).transfer(highestbid);
    //         delete bidderInfo[totalbidders];
    //         for(uint i=1;i<=totalbidders-1;i++)
    //         {
    //             payable(bidderInfo[i].bidderaddress).transfer(99*bidderInfo[i].bidamount/100);
    //             delete bidderInfo[i];
    //         }
    //     }
       

    // }
    function AuctionCompleted(uint nftAuctionNum) public {
        NFTs storage currentNFT = NFTnum[nftAuctionNum];
        require(msg.sender==Auctioneer);
        // require(block.timestamp>=currentNFT.endTime);
        isAuctionCompleted=true;
        if(totalbidders==0)
        {
          ERC721(currentNFT.nft).transferFrom(address(this),currentNFT.seller,currentNFT.tokenid);  
        }
        else
        {
            ERC721(currentNFT.nft).transferFrom(address(this),highestbidder,currentNFT.tokenid);
            payable(currentNFT.seller).transfer(highestbid);  
            bids[highestbidder]-= highestbid;
        }

    }
    function TakeRefund(uint nftAuctionNum) public{
        NFTs storage currentNFT = NFTnum[nftAuctionNum];
        require(isAuctionCompleted,"Auction not completed by auctioneer");
        require(isbidder[msg.sender],"not a bidder");
        require(block.timestamp>=currentNFT.endTime);
        payable(msg.sender).transfer(99*bids[msg.sender]/100);
        bids[msg.sender]=0;
        isbidder[msg.sender]=false;
    }
}