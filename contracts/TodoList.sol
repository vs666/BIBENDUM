pragma solidity ^0.5.0;

contract TodoList {
    uint public taskCount = 0;

    struct Task {
        uint id;
        string content;
        bool completed;
    }

    mapping(uint=> Task) public tasks;
    constructor() public {
        // function called when contract is run for the 1st time
        createTask("Ti-ding");
        createTask("Second task");
        createTask("Third task");
    }

    function createTask(string memory _content) public {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
    }

    function toggleTask(uint _id) public {
        tasks[_id].completed = !tasks[_id].completed;
    }
}