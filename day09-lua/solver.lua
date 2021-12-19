inputs = {}
heightmap = {}

for line in io.lines("input.txt") do
    heightmap[#heightmap + 1] = {}
    for c in line:gmatch"." do         
        heightmap[#heightmap][#heightmap[#heightmap] + 1] = tonumber(c)
    end
end

function copy(arr)
    local c = {}
    for i = 1,#arr do
        local val = arr[i]
        if type(val) == type({}) then
            c[i] = copy(val)
        else
            c[i] = val
        end
    end
    return c
end

function get_value(map, y, x) 
    if y <= 0 or y > #map then
        return 10
    end
    if x <= 0 or x > #map[y] then
        return 10
    end
    return map[y][x]
end

function is_low_point(map, y, x)
    local val = get_value(map, y, x)
    diffs = {{0,-1},{0,1},{1,0},{-1,0}}

    for i = 1,#diffs do
        dVal = get_value(map, y + diffs[i][2], x + diffs[i][1])

        if dVal <= val then
            return false
        end
    end
    return true
end

function get_bassin_size(map, y, x)
    local diffs = {{0,-1},{0,1},{1,0},{-1,0}}
    local val = get_value(map, y, x)
    if val >= 9 then
        return 0
    end

    map[y][x] = 100

    local size = 1
    for i = 1, #diffs do
        size = size + get_bassin_size(map, y + diffs[i][2], x + diffs[i][1])
    end

    return size
end

s = 0
sizes = {}

for y = 1, #heightmap do
    for x = 1, #heightmap[y] do
        if is_low_point(heightmap, y, x) then
            s = s + get_value(heightmap, y, x) + 1
            sizes[#sizes + 1] = get_bassin_size(copy(heightmap), y, x)
        end
    end
end

table.sort(sizes, function (a, b) return a > b end)

print("part 1:", s)
print("part 2:", sizes[1] * sizes[2] * sizes[3])
