return function (content)
    local task = coroutine.create(require)
    local _, result = coroutine.resume(task, content)
    
    if coroutine.status(task) ~= "dead" then
        return warn('Error while initializing '..content:GetFullName()..'. Coroutine got suspended.')
    end

    return result
end