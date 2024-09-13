//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventNFT is ERC721, Ownable {
      uint256 private _nextTokenId;
    mapping(uint256 => uint256) public tokenToEventId;

    constructor(string memory name, string memory symbol) ERC721("Micjohn", "MJC") {}

    function mintNFT(address to, uint256 eventId) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        tokenToEventId[tokenId] = eventId;
    }

    function getEventIdForToken(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return tokenToEventId[tokenId];
    }

    function ownsNFTForEvent(address owner, uint256 eventId) public view returns (bool) {
        uint256 balance = balanceOf(owner);
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            if (tokenToEventId[tokenId] == eventId) {
                return true;
            }
        }
        return false;
    }
}
