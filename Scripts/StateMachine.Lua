local StateMachine =
{
    machines = {}
}

function StateMachine:CreateStateMachine(states)
    local stateMachine = {}
    stateMachine.states = states

    table.insert(self.machines, stateMachine)
end

local function UpdateMachine(StateMachine)

end

function StateMachine:Update()
    for _, machine in ipairs(self.machines) do
        UpdateMachine(machine)
    end
end

return StateMachine