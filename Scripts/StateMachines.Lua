StateMachines =
{
    machines = {}
}

function StateMachines:CreateStateMachine(initialState)
    local stateMachine = {}
    stateMachine.currentState = initialState
    table.insert(self.machines, stateMachine)

    stateMachine.currentState:Enter()

    return stateMachine
end

local function UpdateMachine(stateMachine)
    stateMachine.currentState:Update()
end

function StateMachines:Update()
    for _, machine in ipairs(self.machines) do
        UpdateMachine(machine)
    end
end