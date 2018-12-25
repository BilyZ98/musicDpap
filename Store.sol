pragma solidity ^0.4.18; //We have to specify what version of the compiler this code will use

contract Store{

  struct Music {
    address owner; // who create this song
    bytes32 title; // the name of this song
    uint price ;   // the price of this song
    address[] buyers; // who buy this song
  }

  struct Owner {
    string[] ownerMusicList; // 存的是url
  }

  struct Buyer {
    string[] buyerMusicList; //store url of the song
  }

  string[] allMusic; // store all music

  mapping (address => uint) public wallets;  //store money
  mapping (string => Music) musicStructs;  //
  mapping (address => Owner) ownerStructs;  //each address maps to a owner
  mapping (address => Buyer) buyerStructs;


  bytes32[] public ownersList;
  bytes32[] public buyersList;

  event Transfer(address from, address to, uint256 value);

  function Store (bytes32[] owners, bytes32[] buyers)  public {
    ownersList = owners;
    buyersList = buyers;
  }

  function buyMusic(string code) payable public returns(bool success){
    uint amount = musicStructs[code].price;
    address receiver = musicStructs[code].owner;
    if (wallets[msg.sender] < musicStructs[code].price) return false;
    wallets[msg.sender] -=amount;
    wallets[receiver] +=amount;
    Transfer(msg.sender, receiver, amount);
    buyerStructs[msg.sender].buyerMusicList.push(code);
    musicStructs[code].buyers.push(msg.sender);
    return true;
  }


  function uploadMusic(string code, bytes32 musicName, uint cost)  public returns(bytes32, uint) {
    require(validMusic(code));
    ownerStructs[msg.sender].ownerMusicList.push(code);
    allMusic.push(code);
    musicStructs[code].owner = msg.sender;
    musicStructs[code].title = musicName;
    musicStructs[code].price = cost;
    return (musicStructs[code].title,musicStructs[code].price);
  }

  function allOwners() view public returns (bytes32[]){
    return ownersList;
  }

  function allBuyers() view public returns (bytes32[]){
    return buyersList;
  }

  function getWallet(address pAddress) view public returns(uint){
    return wallets[pAddress];
  }

  function downloadMusic(address ownerAddress, uint index) view public returns (string, bytes32, uint) {
    string url = ownerStructs[ownerAddress].ownerMusicList[index];
    return (url, musicStructs[url].title, musicStructs[url].price);
  }

  function checkMusicForBuyer(string code, address buyerAddress) view public returns (bool){
    for(uint i=0; i< buyerStructs[buyerAddress].buyerMusicList.length;i++){
      if(keccak256(buyerStructs[buyerAddress].buyerMusicList[i]) == keccak256(code)) {
        return true;
      }
    }
    return false;
  }

  function getMusicCount(address ownerAddress) view public returns (uint){
    return ownerStructs[ownerAddress].ownerMusicList.length;
  }

  function addToWallet(uint amount ) payable public returns (bool success){
    wallets[msg.sender] +=amount;
    return true;
  }

  function validMusic(string code) view public returns (bool){
    for(uint i=0; i< allMusic.length;i++){
      if (keccak256(allMusic[i]) == keccak256(code)){{
        return false;
      }}
    }
    return true;
  }

}
