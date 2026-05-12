local Registry = {
    entities = {},
    nextId = 1,
    queryCache = {}
}

function Registry.create()
    local id = Registry.nextId
    Registry.nextId = Registry.nextId + 1
    Registry.entities[id] = {}
    return id
end

function Registry.add(id, componentName, data)
    Registry.entities[id][componentName] = data or {}
    Registry.queryCache = {} -- Invalidate cache on component change
end

function Registry.remove(id)
    Registry.entities[id] = nil
    Registry.queryCache = {} -- Invalidate cache when entity is removed
end

function Registry.get(id, componentName)
    return Registry.entities[id] and Registry.entities[id][componentName]
end

function Registry.has(id, componentName)
    return Registry.entities[id] and Registry.entities[id][componentName] ~= nil
end

function Registry.query(...)
    local req = {...}
    local sig = table.concat(req, "|")
    
    if Registry.queryCache[sig] then
        return Registry.queryCache[sig]
    end

    local result = {}
    for id, comps in pairs(Registry.entities) do
        local match = true
        for _, c in ipairs(req) do
            if not comps[c] then match = false; break end
        end
        if match then table.insert(result, id) end
    end
    
    table.sort(result) -- Sort to guarantee deterministic draw/update order
    Registry.queryCache[sig] = result
    return result
end

function Registry.clear()
    Registry.entities = {}
    Registry.nextId = 1
    Registry.queryCache = {}
end

return Registry
