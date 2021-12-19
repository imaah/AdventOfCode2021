function expend(map, width, height)
    for _ = 1:(height-length(map))
        append!(map, [[0 for _=1:width]])        
    end
            
    for line in map
        if length(line) < width
            append!(line, [0 for _=1:(width-length(line))])
        end
    end
end

function printmap(map) 
    for line in map
        println(join(replace(line, 1 => "#", 0 => "."), ""))
    end
end

function load_inputs(filename, map, actions)
    let a = 0
        for line in readlines(filename)
            if isempty(strip(line))
                a = 1     
            else
                if a == 0
                    x, y = [parse(Int, b) for b in split(line, ',')]
                    expend(map, x+1, y+1)
                    map[y+1][x+1] = 1
                else
                    append!(actions, [split(replace(line, "fold along " => ""), "=")])
                end
            end
        end
    end        
end

function fold_verticaly(map, n)
    n = n + 1
    for i = 0:n+1
        if n - i < 1 || n + i > length(map)
            break
        end
        for x in 1:length(map[n+i])
            map[n - i][x] = map[n - i][x] | map[n + i][x]
            map[n + i][x] = 0
        end
    end
    return map[1:n - 1]
end

function fold_horizontaly(map, n)
    n = n + 1
    for i = 0:n+1
        if n - i < 1 || n + i > length(map[1])
            break
        end
        for y in 1:length(map)
            map[y][n - i] = map[y][n - i] | map[y][n + i]
            map[y][n + i] = 0
        end
    end
    for i = 1:length(map)
        map[i] = map[i][1:n - 1]
    end
    return map
end

function fold(map, axis, n)
    if axis == "y"
        fold_verticaly(map, n)
    else
        fold_horizontaly(map, n)
    end
end

function count_ones(map)
    c = 0
    for line in map
        for elm in line
            if elm == 1
                c += 1
            end
        end
    end
    return c
end

m = []
actions = []

load_inputs("input.txt", m, actions)

let m2 = copy(m)
fold(m, actions[1][1], parse(Int, actions[1][2]))

println("Part 1 : ", count_ones(m))

for action in actions
    m2 = fold(m2, action[1], parse(Int, action[2]))
end

println("Part 2 : ")
printmap(m2)
end