// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Todo {

    struct todo {
        string task;
        bool done;
        uint timeStamp;
        uint id;
    }

    mapping (address => todo[]) public todos;

    function addTodo(string memory _task) external {
        todo memory myTodo;

        todo[] storage myTodos = todos[msg.sender];

        myTodo.task = _task;
        myTodo.done = false;
        myTodo.timeStamp = block.timestamp;
        myTodo.id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _task)));

        myTodos.push(myTodo);

        todos[msg.sender] = myTodos;
    }

    function maskAsDone(uint _index, bool done) external {
        todo[] storage myTodos = todos[msg.sender];

        todo storage myTodo = myTodos[_index];

        myTodo.done = done;
    }

    function getTodo(uint _index) external view returns(todo memory) {
        todo[] memory myTodos = todos[msg.sender];

        todo memory myTodo = myTodos[_index];

        return myTodo;
    }

    function removeTodo(uint _index) external {
        todo[] storage myTodos = todos[msg.sender];

        for (uint256 i = _index; i < myTodos.length - 1; i++) {
            myTodos[i] = myTodos[i + 1];
        }

        myTodos.pop();
    }

}