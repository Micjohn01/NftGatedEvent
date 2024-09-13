//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EventNFT.sol";

interface IEventNFT {
    function ownsNFTForEvent(address owner, uint256 eventId) external view returns (bool);
}

contract EventManager is Ownable {
    IEventNFT public eventNFT;

    uint256 public nextEventId;

    struct Event {
        string name;
        uint256 date;
        uint256 capacity;
        uint256 registeredCount;
        mapping(address => bool) registeredAttendees;
        bool isActive;
    }

    mapping(uint256 => Event) public events;
    

    constructor(address _eventNFTAddress) {
        eventNFT = IEventNFT(_eventNFTAddress);
    }

    function createEvent(string memory _name, uint256 _date, uint256 _capacity) public onlyOwner {
        uint256 eventId = nextEventId++;
        Event storage newEvent = events[eventId];
        newEvent.name = _name;
        newEvent.date = _date;
        newEvent.capacity = _capacity;
        newEvent.isActive = true;
    }

    function registerForEvent(uint256 _eventId) public {
        Event storage _event = events[_eventId];
        require(_event.isActive, "Event is not active");
        require(eventNFT.ownsNFTForEvent(msg.sender, _eventId), "Must own event NFT");
        require(!_event.registeredAttendees[msg.sender], "Already registered for event");
        require(_event.registeredCount < _event.capacity, "Event capacity reached");
        require(block.timestamp < _event.date, "Event registration closed");

        _event.registeredAttendees[msg.sender] = true;
        _event.registeredCount++;
    }

    function isRegisteredForEvent(uint256 _eventId, address attendee) public view returns (bool) {
        return events[_eventId].registeredAttendees[attendee];
    }

    function getEventDetails(uint256 _eventId) public view returns (string memory name, uint256 date, uint256 capacity, uint256 registeredCount, bool isActive) {
        Event storage _event = events[_eventId];
        return (_event.name, _event.date, _event.capacity, _event.registeredCount, _event.isActive);
    }

    function cancelEvent(uint256 _eventId) public onlyOwner {
        events[_eventId].isActive = false;}}