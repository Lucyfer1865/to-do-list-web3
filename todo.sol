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
        priority taskPriority;
        string category;
        bool completed;
        uint dueDate;
        bool deleted;
    }

    // Mappings
    mapping(address => mapping(uint => Task)) private userTasks;
    mapping(address => uint) private taskCount;

    // Events
    event TaskAdded(address indexed user, uint256 taskId, string content, string category, priority taskPriority, uint dueDate);
    event EditTaskComplete(address indexed user, uint256 taskId, bool isCompleted);
    event TaskDeleteStatus(address indexed user, uint256 taskId, bool isDeleted);
    event ContentEdited(address indexed user, uint256 taskId, string newContent);
    event CategoryEdited(address indexed user, uint256 taskId, string newCategory);
    event PriorityEdited(address indexed user, uint256 taskId, priority newPriority);
    event DueDateEdited(address indexed user, uint256 taskId, uint newDueDate);

    modifier correctTaskId(address _user, uint256 _taskId) {
        require(_taskId < taskCount[_user], "Invalid task ID");
        _;
    }

    // Create Task
    function addTask(string memory _content, string memory _category, priority _taskPriority, uint _dueDate) public {
        uint id = ++taskCount[msg.sender];
        userTasks[msg.sender][id] = Task( _content, _taskPriority, _category,false, _dueDate, false);
        emit TaskAdded(msg.sender, id, _content, _category, _taskPriority, _dueDate);
    }

    // Edit Task Completion Status 
    function editCompleteTask(uint _taskId) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].completed = !userTasks[msg.sender][_taskId].completed;
        emit EditTaskComplete(msg.sender, _taskId, userTasks[msg.sender][_taskId].completed);
    }

    // Delete Task
    function removeTask(uint _taskId) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].deleted = true;
        emit TaskDeleteStatus(msg.sender, _taskId, true);
    }

    // Recover Deleted Task
    function recoverTask(uint _taskId) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].deleted = false;
        emit TaskDeleteStatus(msg.sender, _taskId, false);
    }

    // Change Content
    function editContent(uint _taskId, string memory _newContent) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].content = _newContent;
        emit ContentEdited(msg.sender, _taskId, _newContent);
    }

    //Change Category
    function editCategory(uint _taskId, string memory _newCategory) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].category = _newCategory;
        emit CategoryEdited(msg.sender, _taskId, _newCategory);
    }

    // Change Priority
    function editPriority(uint _taskId, priority _newPriority) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].taskPriority = _newPriority;
        emit PriorityEdited(msg.sender, _taskId, _newPriority);
    }

    // Change Date
    function editDueDate(uint _taskId, uint _newDueDate) public correctTaskId(msg.sender, _taskId) {
        userTasks[msg.sender][_taskId].dueDate = _newDueDate;
        emit DueDateEdited(msg.sender, _taskId, _newDueDate);
    }

    // Sorting and Filtering tasks can be implemented using Javascript instead of Solidity
    function getTasks() public view returns (Task[] memory) {
        uint taskCountForUser = taskCount[msg.sender];
        uint nonDeletedTaskCount = 0;

        // Count non-deleted tasks
        for (uint i = 0; i < taskCountForUser; i++) {
            if (!userTasks[msg.sender][i].deleted) {
                nonDeletedTaskCount++;
            }
        }

        Task[] memory tasks = new Task[](nonDeletedTaskCount);
        uint index = 0;

        // Add and return tasks to the array
        for (uint i = 0; i < taskCountForUser; i++) {
            if (!userTasks[msg.sender][i].deleted) {
                tasks[index] = userTasks[msg.sender][i];
                index++;
            }
        }

        return tasks;
    }

    function getDeletedTasks() public view returns (Task[] memory) {
        uint taskCountForUser = taskCount[msg.sender];
        uint deletedTaskCount = 0;

        // Count deleted tasks
        for (uint i = 0; i < taskCountForUser; i++) {
            if (userTasks[msg.sender][i].deleted) {
                deletedTaskCount++;
            }
        }

        Task[] memory tasks = new Task[](deletedTaskCount);
        uint index = 0;

        // Add and return deleted tasks to the array
        for (uint i = 0; i < taskCountForUser; i++) {
            if (userTasks[msg.sender][i].deleted) {
                tasks[index] = userTasks[msg.sender][i];
                index++;
            }
        }
        return tasks;
    }


}