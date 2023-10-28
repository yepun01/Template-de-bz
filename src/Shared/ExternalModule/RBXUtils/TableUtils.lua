type List = {any}
type Array<T> = {T}
type Dictionary<A, B> = {[A]: B}

local TableUtils = {}

function TableUtils.shallowCopy(tab: Dictionary<any, any>): Dictionary<any, any>
    local copy = {}
    for i, v in pairs(tab) do
        copy[i] = v
    end
    return copy
end

function TableUtils:RecursiveSearchByIndex(tables : table, targetIndex : any) : any
    for index, value in pairs(tables) do
        if index == targetIndex then
            return value
        elseif type(value) == "table" then
            local result = TableUtils:RecursiveSearchByIndex(value, targetIndex)
            if result ~= nil then
                return result
            end
        end
    end
    return nil
end

function TableUtils:deepCompare(t1 : table, t2 : table) : boolean
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then -- different types
        return false
    end

    if ty1 ~= 'table' then -- non-tables are compared directly
        return t1 == t2
    end

    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not TableUtils:deepCompare(v1, v2) then
            return false
        end
    end

    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not TableUtils:deepCompare(v1, v2) then
            return false
        end
    end
    return true
end

function TableUtils:getNestedValuePath(data, pathTable)
    local path = table.concat(pathTable, '.')
    local keys = {}
    for key in string.gmatch(path, '([^.]+)') do
        table.insert(keys, key)
    end

    local tableRef = data
    for i = 1, #keys - 1 do
        tableRef = tableRef[keys[i]]
        if tableRef == nil then
            return nil
        end
    end

    return {ref = tableRef, key = keys[#keys]}
end

function TableUtils:FindNestedValue(data : table, path : string)
    local keys = {}
    local tableRef = data
    for key in string.gmatch(path, '([^.]+)') do
        table.insert(keys, key)
    end
    for i = 1, #keys - 1 do
        tableRef = tableRef[keys[i]]
        if tableRef == nil then
            return nil
        end
    end
    return {ref = tableRef, key = keys[#keys]}
end

function TableUtils:indexfromvalue(tab, value)
    for i,v in pairs(tab) do
        if v == value then
            return i
        end
    end
end

function TableUtils:valueatpos(tab, value)
    local len = 1

    for i,v in pairs(tab) do
        if len == value then
            return i,v
        end
        len += 1
    end
end

function TableUtils:len(tab)
    local len = 0

    for _,_ in pairs(tab) do
        len += 1
    end
    return len
end

function TableUtils:FindIndex(t : table , index : number)
    for Title, Value in pairs(t) do
        if Value["Index"] == index then
            return Title,Value
        end
    end
    return nil
end

function TableUtils:Concat(tab1, tab2)
    if tab1 == {} or tab1 == nil then return tab2 end
    if tab2 == {} or tab2 == nil then return tab1 end
    local OriginalSize = #tab1

    for i,v in pairs(tab2) do
        tab1[OriginalSize + i] = v
    end
    return tab1
end

function TableUtils:Same(tab1, tab2)
    if tab1 == nil or tab2 == nil then return false end
    if tab1 == {} and tab2 == {} then return true end

    for i,v in pairs(tab1) do
        if tab2[i] ~= v then
            return false
        end
    end
    return true
end

function TableUtils:isinlist(tab, target)
    for i,v in pairs(tab) do
        if (i == target) then
            return i,v
        end
    end
    return false
end
function TableUtils:isinlistvalue(tab, target)
    for _,v in pairs(tab) do
        if (v == target) then
            return true
        end
    end
    return false
end

function TableUtils.deepCopy(tab: Dictionary<any, any>): Dictionary<any, any>
    local copy = {}
    for i, v in pairs(tab) do
        if type(v) == "table" then
            v = TableUtils.deepCopy(v)
        end
        copy[i] = v
    end
    return copy
end

function TableUtils.keys(tab: Dictionary<any, any>): Array<string>
    local keys = {}
    for i in pairs(tab) do
        table.insert(keys, i)
    end
    return keys
end

function TableUtils.values(tab: Dictionary<any, any>): List
    local values = {}
    for _,v in pairs(tab) do
        table.insert(values, v)
    end
    return values
end

function TableUtils.isEmpty(tab: Dictionary<any, any>): boolean
    for _ in pairs(tab) do
        return false
    end
    return true
end

-- Behaves differently from table.create(), if the value is a empty table then the tables will not share the same memory address
function TableUtils.create(count: number, value: any): Dictionary<any, any>
    if type(value) == "table" and TableUtils.isEmpty(value) then
        local tab = {}
        for _ = 1, count do
            table.insert(tab, {})
        end
        return tab
    else
        return table.create(count, value)
    end
end

-- Merges dictionaries together, for merging arrays use {TableUtils.unpack(...)}
function TableUtils.merge(...): Dictionary<any, any>
    local mergedTab = {}
    for _,tab in pairs({...}) do
        for i,v in pairs(tab) do
            mergedTab[i] = v
        end
    end
    return mergedTab
end

-- Allows unpacking of multiple tables
function TableUtils.unpack(...)
    local packedTab = {}
    for _,tab in pairs({...}) do
        for _,v in pairs(tab) do
            table.insert(packedTab, v)
        end
    end
    return unpack(packedTab)
end

function TableUtils.remove(tab: List, index: number): nil
    if type(index) == "number" then
        tab[index] = nil
    else
        local i = table.find(tab, index)
        if i then
            table.remove(tab, i)
        end
    end
end

function TableUtils.select(tab: List, indexStart: number, indexEnd: number): List
    indexEnd = indexEnd or #tab
    local output = {}

    for i = indexStart, indexEnd do
        table.insert(output, tab[i])
    end

    return output
end

-- Returns the sum of a array of numbers
function TableUtils.sum(tab: List): number
    local sum = tab[1]
    for i = 2, #tab do
        sum += tab[i]
    end
    return sum
end

-- Returns the average of a array of numbers
function TableUtils.avg(tab: List): number
    return TableUtils.sum(tab) / #tab
end

return TableUtils