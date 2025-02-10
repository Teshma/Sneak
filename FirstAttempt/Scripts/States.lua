States = {}

function States.Create(Enter, Update, Exit)

    local s = {}
    s.Enter = Enter
    s.Update = Update
    s.Exit = Exit

    return s
end