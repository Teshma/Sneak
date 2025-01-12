IdleState = {}

function IdleState:Create(params)
    local state = States.Create(IdleState.Enter, IdleState.Update, IdleState.Exit)

    state.owner = params.owner

    return state
end

function IdleState:Enter(state)
end

function IdleState:Update(state)
end

function IdleState:Exit(state)
end