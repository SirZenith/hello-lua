Queue = {
    st = 1,
    ed = 1,
    size = 0,
    capability = 10,
}

local queue_mt = {
    __index = Queue,
    __tostring = function (q)
        local buffer = {}
        local curr = q.st
        for _ = 1, q.size do
            buffer[#buffer+1] = q[curr]
            curr = curr + 1
            if curr > q.capability then
                curr = 1
            end
        end
        return table.concat(buffer, ", ")
    end,
}

function Queue.new()
    local q = {}
    setmetatable(q, queue_mt)
    return q
end

function Queue:is_empty()
    return self.size == 0
end

function Queue:is_full()
    return self.size == self.capability
end

function Queue:append(value)
    if self:is_full() then
        return false
    end

    self[self.ed] = value
    self.ed = self.ed + 1
    if self.ed > self.capability then
        self.ed = 1
    end
    self.size = self.size + 1

    return true
end

function Queue:pop()
    if self:is_empty() then
        return nil
    end

    local result = self[self.st]
    self.st = self.st + 1
    if self.st > self.capability then
        self.st = 1
    end
    self.size = self.size - 1

    return result
end

local q = Queue.new()
print(q:is_empty())
for i = 1, q.capability + 1 do
    print(q:append(i))
end
print(q:is_full())
print(q)

for _ = 1, q.capability + 1 do
    print(q:pop())
end
