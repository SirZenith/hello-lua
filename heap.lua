Heap = {}
local heap_mt = {
    __index = Heap,
    __tostring = function (h)
        local buffer = {}
        for _, value in ipairs(h) do
            buffer[#buffer+1] = value
        end
        return table.concat(buffer, ", ")
    end
}

function Heap.new(capability, ordering_ok)
    capability = capability or 5
    ordering_ok = ordering_ok or function (a, b)
        return a < b
    end
    local h = {capability = capability, ordering_ok = ordering_ok}
    setmetatable(h, heap_mt)
    return h
end

function Heap:sink_(curr)
    -- 从索引位置 curr 起，向下递归检查元素与其子元素之间的序关系，必要时交换
    if not self[curr] then
        return
    end

    local this_ele = self[curr]
    local l, r = 2 * curr, 2 * curr + 1
    local l_child, r_child = self[l], self[r]
    local target
    -- choose the one child that can preserve ordering if elevating is needed.
    if l_child and r_child then
        target = self.ordering_ok(l_child, r_child) and l or r
    else
        -- if everything is good, then l_child will never be `nil`
        target = l
    end
    local target_ele = self[target]

    if target_ele and not self.ordering_ok(this_ele, target_ele) then
        self[curr], self[target] = target_ele, this_ele
        self:sink_(target)
    end
end

function Heap:pop()
    -- 从堆顶取出一个元素，并将末尾元素移至堆顶重新进行保序下沉。
    local size = #self
    if size == 0 then
        return nil
    end

    local result = self[1]
    self[1] = self[size]
    self[size] = nil
    self:sink_(1)
    return result
end

function Heap:elevate_(curr)
    -- 从索引位置 curr 起，向上递归检查元素与其父元素之间的序关系，必要时交换
    if curr == 1 then
        return
    end

    local this_ele = self[curr]
    local parent = curr // 2
    local par_ele = self[parent]
    -- elevating data
    if par_ele and not self.ordering_ok(par_ele, this_ele) then
        self[parent], self[curr] = this_ele, par_ele
    end
    self:elevate_(parent)
end

function Heap:add(value)
    -- 向堆底添加一个元素，并从堆底重新进行保序上浮。
    local target = #self + 1
    self[target] = value
    self:elevate_(target)
end

local data = {3, 2, 8, 8, 6, 10, 8, 5, 5, 1}
local h = Heap.new()
for _, d in ipairs(data) do
    h:add(d)
end

print(h)

for _ = 1, #data do
    print(h:pop())
end
