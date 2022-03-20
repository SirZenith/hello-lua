BinNode = {}
local bin_node_mt = {
    __index = BinNode,
}

function BinNode.new(data)
    local n = {data = data, l_child = nil, r_child = nil}
    setmetatable(n, bin_node_mt)
    return n
end

BinSearchTree = {}
local bin_search_tree_mt = {
    __index = BinSearchTree,
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
        self:add(self.root)
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

function BinSearchTree:right_most(root)
    if not root then
        return nil
    end
end

function BinSearchTree:delete(data)
    -- 删除包含指定 data 的最浅结点，并返回该结点，没有搜索结果返回 nil
    local function take_deepest_child(root, target)
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
        local target_node = nil
        if root == parent.r_child then
            if root.r_child then
                target = take_deepest_child(root.r_child, "l_child")
            elseif root.r_child then
                target = take_deepest_child(root.l_child, "r_child")
            end
            parent["r_child"] = target
        end
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
            
        end
    end
    end
end
