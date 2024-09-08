// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Todo{

    enum priority{
        Low,
        Medium,
        High
    }

    // Task Struct
    struct Task{
        string content;
        string category;
        priority taskPriority;
        uint dueDate;
        bool completed;
        bool deleted;
    }

    // Mappings
    mapping(address => Task[]) private _userTasks;

    // Events
    event TaskAdded(address indexed user, uint256 taskId, string content, string category, priority taskPriority, uint dueDate);
    event EditTaskComplete(address indexed user, uint256 taskId, bool isCompleted);
    event TaskDeleteStatus(address indexed user, uint256 taskId, bool isDeleted);
    event ContentEdited(address indexed user, uint256 taskId, string newContent);
    event CategoryEdited(address indexed user, uint256 taskId, string newCategory);
    event PriorityEdited(address indexed user, uint256 taskId, priority newPriority);
    event DueDateEdited(address indexed user, uint256 taskId, uint newDueDate);

    modifier validTaskId( uint256 _taskId) {
        require(_taskId < _userTasks[msg.sender].length, "Invalid task ID");
        _;
    }

    // Create Task
    function addTask(string memory _content, string memory _category, priority _taskPriority, uint _dueDate) public {
        Task memory newTask;
        newTask.content = _content;
        newTask.category = _category;
        newTask.taskPriority = _taskPriority;
        newTask.dueDate = _dueDate;
        newTask.completed = false;
        newTask.deleted = false;

        _userTasks[msg.sender].push(newTask);
        emit TaskAdded(msg.sender, _userTasks[msg.sender].length - 1, _content, _category, _taskPriority, _dueDate);
    }

    // Edit Task Completion Status
    function toggleCompleteTask(uint _taskId) public validTaskId(_taskId) {
        _userTasks[msg.sender][_taskId].completed = !_userTasks[msg.sender][_taskId].completed;
        emit EditTaskComplete(msg.sender, _taskId, _userTasks[msg.sender][_taskId].completed);
    } 

    // Delete Task
    function removeTask(uint _taskId) public validTaskId(_taskId) {
        _userTasks[msg.sender][_taskId].deleted = true;
        emit TaskDeleteStatus(msg.sender, _taskId, true);
    }

    // Recover Deleted Task
    function recoverTask(uint _taskId) public validTaskId( _taskId) {
        _userTasks[msg.sender][_taskId].deleted = false;
        emit TaskDeleteStatus(msg.sender, _taskId, false);
    }

    // Change Content
    function editContent(uint _taskId, string memory _newContent) public validTaskId(_taskId) {
        _userTasks[msg.sender][_taskId].content = _newContent;
        emit ContentEdited(msg.sender, _taskId, _newContent);
    }

    //Change Category
    function editCategory(uint _taskId, string memory _newCategory) public validTaskId(_taskId) {
        _userTasks[msg.sender][_taskId].category = _newCategory;
        emit CategoryEdited(msg.sender, _taskId, _newCategory);
    }

    // Change Priority
    function editPriority(uint _taskId, priority _newPriority) public validTaskId(_taskId) {
        _userTasks[msg.sender][_taskId].taskPriority = _newPriority;
        emit PriorityEdited(msg.sender, _taskId, _newPriority);
    }

    // Change Date
    function editDueDate(uint _taskId, uint _newDueDate) public validTaskId( _taskId) {
        _userTasks[msg.sender][_taskId].dueDate = _newDueDate;
        emit DueDateEdited(msg.sender, _taskId, _newDueDate);
    }

    // Sorting and Filtering tasks can be implemented using Javascript instead of Solidity
    function getTasks() public view returns (Task[] memory) {
        uint taskCountForUser = _userTasks[msg.sender].length;
        uint nonDeletedTaskCount = 0;

        // Count non-deleted tasks
        for (uint i = 0; i < taskCountForUser; i++) {
            if (!_userTasks[msg.sender][i].deleted) {
                nonDeletedTaskCount++;
            }
        }

        Task[] memory tasks = new Task[](nonDeletedTaskCount);
        uint index = 0;

        // Add and return tasks to the array
        for (uint i = 0; i < taskCountForUser; i++) {
            if (!_userTasks[msg.sender][i].deleted) {
                tasks[index] = _userTasks[msg.sender][i];
                index++;
            }
        }

        return tasks;
    }

    function getDeletedTasks() public view returns (Task[] memory) {
        uint taskCountForUser = _userTasks[msg.sender].length;
        uint deletedTaskCount = 0;

        // Count deleted tasks
        for (uint i = 0; i < taskCountForUser; i++) {
            if (_userTasks[msg.sender][i].deleted) {
                deletedTaskCount++;
            }
        }

        Task[] memory tasks = new Task[](deletedTaskCount);
        uint index = 0;

        // Add and return deleted tasks to the array
        for (uint i = 0; i < taskCountForUser; i++) {
            if (_userTasks[msg.sender][i].deleted) {
                tasks[index] = _userTasks[msg.sender][i];
                index++;
            }
        }
        return tasks;
    }

}