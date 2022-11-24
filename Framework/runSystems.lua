return function (services, name, ...)
    for _, service in pairs(services) do
        if not (type(service) == 'function') and service[name] and type(service[name]) == 'function' then
            task.defer(service[name], service[name], ...)
        end
    end
end