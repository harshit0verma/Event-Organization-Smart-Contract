//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract EventContract {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint => Event) public events; // mapping events by index
    mapping(address => mapping(uint => uint)) public tickets; // mapping address to hold tickets

    uint public nextId;

    function createEvent(
        string memory name,
        uint date,
        uint price,
        uint ticketCount
    ) external {
        require(date > block.timestamp, "Event not possible ! check date");
        require(ticketCount > 0, "print more tickets !");

        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        );
        nextId++;
    }

    function butTicket(uint id, uint quantity) external payable {
        require(events[id].date != 0, "this event does not exist !");
        require(block.timestamp < events[id].date, "Event had ended !");

        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), "Send more wei !");
        require(_event.ticketRemain > quantity, "Ticekts not available !");

        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(
        uint id,
        uint quantity,
        address to
    ) external {
        require(events[id].date != 0, "Event does not exist !");
        require(block.timestamp < events[id].date, "Event has ended !");
        require(
            tickets[msg.sender][id] > quantity,
            "Need to purchase more tcikets !"
        );

        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
