local StateMachines =
{
    machines = {}
}

function StateMachines:CreateStateMachine(states)
    local stateMachine = {}
    stateMachine.states = states

    table.insert(self.machines, stateMachine)
end

local function UpdateMachine(StateMachine)

end

function StateMachines:Update()
    for _, machine in ipairs(self.machines) do
        UpdateMachine(machine)
    end
end

return StateMachines