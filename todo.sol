// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Todo{

    enum priority{
        Low,
        Medium,
        High
    }

    struct Task{
        string content;
        priority taskPriority;
        string category;
        bool completed;
    }

    mapping(address => mapping(uint => Task)) private userTasks;
    mapping(address => uint) private taskCount;

    event TaskAdded(address indexed user, uint256 taskId, string content, string category, priority taskPriority);
    event TaskCompleted(address indexed user, uint256 taskId);
    event TaskDeleted(address indexed user, uint256 taskId);
    event ContentEdited(address indexed user, uint256 taskId, string newContent);
    event CategoryEdited(address indexed user, uint256 taskId, string newCategory);

    modifier correctTaskId(address _user, uint256 _taskId) {
        require(_taskId < taskCount[_user], "Invalid task ID");
        _;
    }

    function addTask(string memory _content, string memory _category, priority _taskPriority) public {
        uint id = ++taskCount[msg.sender];
        userTasks[msg.sender][id] = Task( _content, _taskPriority, _category,false);
        emit TaskAdded(msg.sender, id, _content, _category, _taskPriority);
    }

    function completeTask(uint _taskId) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].completed = true;
        emit TaskCompleted(msg.sender, _taskId);
    }

    function removeTask(uint _taskId) public correctTaskId(msg.sender, _taskId) {
        delete userTasks[msg.sender][_taskId];
        emit TaskDeleted(msg.sender, _taskId);
    }

    function editContent(uint _taskId, string memory _newContent) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].content = _newContent;
        emit ContentEdited(msg.sender, _taskId, _newContent);
    }

    function editCategory(uint _taskId, string memory _newCategory) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].category = _newCategory;
        emit CategoryEdited(msg.sender, _taskId, _newCategory);
    }

    function getTasks() public view returns (Task[] memory) {
        uint taskCountForUser = taskCount[msg.sender];
        Task[] memory tasks = new Task[](taskCountForUser);

        for (uint i = 0; i < taskCountForUser; i++) {
            tasks[i] = userTasks[msg.sender][i];
        }

        return tasks;
    }


}