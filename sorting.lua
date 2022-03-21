local function default_ordering(a, b)
    return a <= b
end

local function bubble(list, ordering)
    ordering = ordering or default_ordering
    for i = 1, #list do
        for j = 1, #list - i do
            if not ordering(list[j], list[j + 1]) then
                list[j], list[j + 1] = list[j + 1], list[j]
            end
        end
    end
    return list
end

local function shell(list, ordering)
    ordering = ordering or default_ordering
    local step = #list // 2
    while step > 0 do
        for st = 1, step do
            for walking = st + step, #list, step do
                for i = walking, step + 1, -step do
                    if not ordering(list[i - step], list[i]) then
                        list[i - step], list[i] = list[i], list[i - step]
                    end
                end
            end
        end
        step = step // 2
    end

    return list
end

local function quick(list, ordering)
    ordering = ordering or default_ordering
    local function quick_inner(st, ed)
        if ed - st <= 0 then
            return list
        elseif ed == st + 1 then
            if not ordering(list[st], list[ed]) then
                list[st], list[ed] = list[ed], list[st]
            end
            return list
        end

        local base = list[st]
        local lower, upper = st + 1, ed
        while lower < upper do
            while lower <= #list and ordering(list[lower], base) do
                lower = lower + 1
            end
            while upper > st and ordering(base, list[upper]) do
                upper = upper - 1
            end
            if upper <= lower then
                break
            end
            list[upper], list[lower] = list[lower], list[upper]
        end
        list[st], list[upper] = list[upper], list[st]
        quick_inner(st, upper - 1)
        quick_inner(lower, ed)

        return list
    end

    return quick_inner(1, #list)
end

local sortings = {bubble, shell, quick}
for _, sorting in ipairs(sortings) do
    local tables = {
        {1},
        {3, 2},
        {0, 1, 0, 2},
        {8, 7, 1, 8, 3, 4, 9, 6, 0, 9, 4, 2, 2, 0},
        {9, 7, 1, 8, 3, 4, 9, 6, 0, 8, 4, 2, 2, 0},
    }
    print()
    for _, t in ipairs(tables) do
        print("result: ", table.concat(sorting(t), " "))
    end
end
