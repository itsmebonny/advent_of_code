mutable struct Robot
    position::Tuple{Int,Int}
    velocity::Tuple{Int,Int}
end

struct BathroomMap
    x_min::Int
    x_max::Int
    y_min::Int
    y_max::Int
    robots::Vector{Robot}
    piantina::Dict{Tuple{Int,Int},Int}  # Changed from map
end

function parse_input(filename::String)::Vector{Robot}
    robots = Vector{Robot}()
    
    # Read and split input
    input_string = split(read(filename, String), "\n", keepempty=false)

    # Update pattern to match actual input format
    pattern = r"p=(\-?\d+),(\-?\d+) v=(\-?\d+),(\-?\d+)"

    for line in input_string
        m = match(pattern, line)
        if m !== nothing
            position = (parse(Int, m.captures[1]), parse(Int, m.captures[2]))
            velocity = (parse(Int, m.captures[3]), parse(Int, m.captures[4]))
            push!(robots, Robot(position, velocity))
        end
    end

    return robots
end

robots = parse_input("day_14/input.txt")

# for r in robots
#     println("Position: ", r.position, " Velocity: ", r.velocity)
#     if r.position == (2,4) && r.velocity == (2,-3)
#         println("Found robot")
#     end
# end

function create_map(robots::Vector{Robot})::BathroomMap
    x_min = 0
    x_max = 101
    y_min = 0
    y_max = 103

    piantina = Dict{Tuple{Int,Int},Int}()  # Changed variable name
    for x in x_min:x_max-1
        for y in y_min:y_max-1
            piantina[(x,y)] = 0
        end
    end
    for r in robots
        piantina[r.position] += 1
    end
    return BathroomMap(x_min, x_max-1, y_min, y_max-1, robots, piantina)
end

function print_map(m::BathroomMap)
    for y in m.y_min:m.y_max
        for x in m.x_min:m.x_max
            if m.piantina[(x,y)] > 0  # Changed from m.map to m.piantina
                print(m.piantina[(x,y)])  # Changed from map to m.piantina
            else
                print(".")
            end
        end
        println()
    end
end

m = create_map(robots)



function move_robots(m::BathroomMap)
    # Clear current positions
    for x in m.x_min:m.x_max
        for y in m.y_min:m.y_max
            m.piantina[(x,y)] = 0
        end
    end
    
    # Move robots
    for r in m.robots
        # Calculate new position with wrap-around
        new_x = mod(r.position[1] + r.velocity[1], m.x_max + 1)
        new_y = mod(r.position[2] + r.velocity[2], m.y_max + 1)
        
        r.position = (new_x, new_y)
        m.piantina[r.position] += 1
    end
end

function advance_time(m::BathroomMap, n::Int)
    for i in 1:n
        move_robots(m)
    end
end

function count_robots(m::BathroomMap)::Int
    #divide the map in 4 quadrants and check how many robots are in each quadrant
    x_mid = m.x_min + (m.x_max - m.x_min) ÷ 2
    y_mid = m.y_min + (m.y_max - m.y_min) ÷ 2
    total_count = 1
    count = [0,0,0,0]
    for r in m.robots
        if r.position[1] < x_mid && r.position[2] < y_mid
            count[1] += 1
        elseif r.position[1] > x_mid && r.position[2] < y_mid
            count[2] += 1
        elseif r.position[1] < x_mid && r.position[2] > y_mid
            count[3] += 1
        elseif r.position[1] > x_mid && r.position[2] > y_mid
            count[4] += 1
        end
    end
    println("In quadrant 1 there are ", count[1], " robots")
    println("In quadrant 2 there are ", count[2], " robots")
    println("In quadrant 3 there are ", count[3], " robots")
    println("In quadrant 4 there are ", count[4], " robots")
    for c in count
        total_count *= c
    end
    return total_count
end

function print_robot_movement(m::BathroomMap, r::Robot)
    for y in m.y_min:m.y_max
        for x in m.x_min:m.x_max
            if (x,y) == r.position
                print("#")
            else
                print(".")
            end
        end
        println()
    end
end

function advance_time_test(m::BathroomMap, n::Int)
    ### advance_time test needs to advance time, and print the movementof a specific robot
    track_robot = Robot((0,0), (0,0))
    for r in m.robots
        println("Position: ", r.position, " Velocity: ", r.velocity)
        if r.position == (2,4) && r.velocity == (2,-3)
            track_robot = r
        break    
        end
    end
    println("=====================================")
    print_robot_movement(m, track_robot)
    println("=====================================")
    for i in 1:n
        move_robots(m)
        print_robot_movement(m, track_robot)
        println("=====================================")
    end
end

function print_end_state(m::BathroomMap)
    x_mid = m.x_min + (m.x_max - m.x_min) ÷ 2
    println("x_mid: ", x_mid)
    y_mid = m.y_min + (m.y_max - m.y_min) ÷ 2
    println("y_mid: ", y_mid)
    for y in m.y_min:m.y_max
        for x in m.x_min:m.x_max
            if m.piantina[(x,y)] > 0 && x != x_mid && y != y_mid
                print(m.piantina[(x,y)])
            elseif x == x_mid || y == y_mid
                print(" ")
            else
                print(".")
            end
        end
        println()
    end
end

function advance_test(m::BathroomMap, n::Int)
    println("============THIS IS THE TEST============")
    for i in 1:n
        println("Time: ", i)
        move_robots(m)
        print_map(m)
        println("=====================================")
    end
end

#advance_test(m, 10)

# advance_time_test(m, 5)


advance_time(m, 100)
# println("=====================================")
# print_map(m)
println("=====================================")
print_end_state(m)
println("=====================================")

println("Part 1: ", count_robots(m))

### Part 2

#m = create_map(robots)

### render an image of the map and save it to a file named input_{timestep}.png
using Images  # For RGB type and image handling
using FileIO  # For save function

function render_image(m::BathroomMap, timestep::Int)
    # Create image array with correct dimensions
    img = fill(RGB{Float64}(0,0,0), m.x_max - m.x_min + 1, m.y_max - m.y_min + 1)
    
    # Fill image based on robot positions
    for y in m.y_min:m.y_max
        for x in m.x_min:m.x_max
            if m.piantina[(x,y)] > 0
                img[x - m.x_min + 1, y - m.y_min + 1] = RGB{Float64}(1,1,1)
            end
        end
    end
    
    # Ensure directory exists
    mkpath("day_14")
    # Save image
    save("day_14/input_$(lpad(timestep,3,'0')).png", img)
end

function compute_metrics(m::BathroomMap)Tuple{Tuple{Float64,Float64},Tuple{Float64,Float64}}
    x_mean = 0.0
    y_mean = 0.0
    x_var = 0.0
    y_var = 0.0
    for r in m.robots
        x_mean += r.position[1]
        y_mean += r.position[2]
    end
    x_mean /= length(m.robots)
    y_mean /= length(m.robots)
    for r in m.robots
        x_var += (r.position[1] - x_mean)^2
        y_var += (r.position[2] - y_mean)^2
    end
    x_var /= length(m.robots)
    y_var /= length(m.robots)
    return ((x_mean, y_mean), (x_var, y_var))
end

function check_randomness(m::BathroomMap, metrics::Tuple{Tuple{Float64,Float64},Tuple{Float64,Float64}}, tolerance::Float64)::Bool
    (x_mean, y_mean), (x_var, y_var) = metrics
    for r in m.robots
        if abs(r.position[1] - x_mean) > tolerance * x_var || abs(r.position[2] - y_mean) > tolerance * y_var
            return false
        end
    end
    return true
end

function is_not_noise(m::BathroomMap)::Bool
    # Calculate nearest neighbor statistics
    total_points = 0
    total_neighbors = 0
    
    for y in m.y_min:m.y_max
        for x in m.x_min:m.x_max
            if m.piantina[(x,y)] > 0
                total_points += 1
                # Check 8 neighboring cells
                for dx in -1:1
                    for dy in -1:1
                        if dx == 0 && dy == 0 
                            continue
                        end
                        # Handle wrap-around
                        nx = mod(x + dx - m.x_min, m.x_max - m.x_min + 1) + m.x_min
                        ny = mod(y + dy - m.y_min, m.y_max - m.y_min + 1) + m.y_min
                        if m.piantina[(nx,ny)] > 0
                            total_neighbors += 1
                        end
                    end
                end
            end
        end
    end
    
    # Calculate average neighbors per point
    avg_neighbors = total_points > 0 ? total_neighbors / total_points : 0
    
    # Calculate expected neighbors for random distribution
    area = (m.x_max - m.x_min + 1) * (m.y_max - m.y_min + 1)
    density = total_points / area
    expected_neighbors = 8 * density  # 8 neighboring cells
    
    # If actual neighbors significantly higher than expected, pattern exists
    return avg_neighbors > 1.5 * expected_neighbors
end

function find_christmas_tree(m::BathroomMap)::Bool
    #check if there are at least 10 robots contiguous on a row
    for y in m.y_min:m.y_max
        count = 0
        for x in m.x_min:m.x_max
            if m.piantina[(x,y)] > 0
                count += 1
            else
                count = 0
            end
            if count >= 10
                return true
            end
        end
    end
    return false
end

function find_christmas_tree(m::BathroomMap, n::Int)
    x_mean = Vector{Float64}()
    y_mean = Vector{Float64}()
    x_var = Vector{Float64}()
    y_var = Vector{Float64}()
    for i in 1:n
        move_robots(m)
        check = find_christmas_tree(m)
        if check
            println("Christmas tree found at time $i")
            render_image(m, i)
        end
    end
end

        

find_christmas_tree(m, 30000)

        
