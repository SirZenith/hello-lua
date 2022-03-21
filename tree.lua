BinNode = {}
local bin_node_mt = {
    __index = BinNode,
    __tostring = function (n)
        return "node: "..n.data
    end
}

function BinNode.new(data)
    local n = {data = data, l_child = nil, r_child = nil}
    setmetatable(n, bin_node_mt)
    return n
end

BinSearchTree = {}
local bin_search_tree_mt = {
    __index = BinSearchTree,
    __tostring = function (t)
        local function format(root, buffer, indent)
            buffer = buffer or {}
            if root == nil then
                return
            end
            buffer[#buffer+1] = root.data .. "\n"
            if root.l_child then
                buffer[#buffer+1] = indent..(root.r_child and "├── " or "└── ")
                format(
                    root.l_child, buffer,
                    root.r_child and indent.."│   " or indent.."    "
                )
            end
            if root.r_child then
                buffer[#buffer+1] = indent.."└── "
                format(root.r_child, buffer, indent .. "    ")
            end
            return buffer
        end
        local buffer = format(t.root, nil, "")
        return table.concat(buffer)
    end,
}

function BinSearchTree.new()
    local t = {root = nil}
    setmetatable(t, bin_search_tree_mt)
    return t
end

function BinSearchTree:add(data)
    -- 添加新的结点
    local function add(root)
        -- root 为递归搜索插入点的起始结点，必须非 nil
        if data > root.data then
            if not root.r_child then
                root.r_child = BinNode.new(data)
            else
                add(root.r_child)
            end
        else
            if not root.l_child then
                root.l_child = BinNode.new(data)
            else
                add(root.l_child)
            end
        end
    end

    if not self.root then
        self.root = BinNode.new(data)
    else
        add(self.root)
    end
end

function BinSearchTree:get(data)
    -- 搜索包含指定 data 的最浅结点，并返回该结点，没有搜索结果返回 nil
    local function get(root)
        -- root 为搜索起始结点
        if not root then
            return nil
        end
        if data > root.data then
            return get(root.r_child)
        elseif data < root.data then
            return get(root.l_child)
        else
            return root
        end
    end

    return get(self.root)
end

function BinSearchTree:pop(data)
    -- 删除包含指定 data 的最浅结点，并返回该结点，没有搜索结果返回 nil

    local function take_deepest_child(root, target)
        -- target 为 "l_child" 或 "r_child" 中的一个，函数按照 target 给定方向寻
        -- 找 root 的最深子结点。
        if root == nil then
            return nil
        end

        local parent = nil
        local curr = root
        while curr[target] do
            parent = curr
            curr = curr[target]
        end

        if parent then
            parent[target] = nil
        end
        return curr
    end

    local function order_preserve_move(root, parent)
        -- root 为将被移除的结点，非 nil。从 root 的子结点中导找合适的结点移动到
        -- root 所在的位置，保持二叉树的序结构。
        if not root then
            return
        end
        local target= nil
        if root.r_child then
            target= take_deepest_child(root.r_child, "l_child")
        elseif root.l_child then
            target= take_deepest_child(root.l_child, "r_child")
        end
        if target then
            target.r_child = root.r_child
            target.l_child = root.l_child
        end
        if root == (parent or {}).r_child then
            parent.r_child = target
        elseif root == (parent or {}).l_child then
            parent.l_child = target
        end
        return target
    end

    local parent = nil
    local curr = self.root
    while curr do
        if data > curr.data then
            parent = curr
            curr = curr.r_child
        elseif data < curr.data then
            parent = curr
            curr = curr.l_child
        else
            -- target found
            local target = order_preserve_move(curr, parent)
            if not parent then
                -- this means we are deleting root node
                self.root = target
            end
            break
        end
    end

    curr.l_child, curr.r_child = nil, nil
    return curr
end

local t = BinSearchTree.new()
local data = {8, 7, 1, 8, 3, 4, 9, 6, 0, 9, 4, 2, 2, 0}
for _, d in ipairs(data) do
    t:add(d)
end

print(t)

print(t:pop(8))
print(t)
