
"""
The input is like
Button A: X + 3, Y + 1
Button B: X + 1, Y + 2
Prize: X=7, Y=4
and should create a ClawMachine struct such that
A = (3, 1)
B = (1, 2)
Prize = (7, 4)
"""
struct ClawMachine
    button_a::Tuple{Int, Int}
    button_b::Tuple{Int, Int}
    prize::Tuple{Int, Int}
end

const TOLERANCE = 0.0001  # Standardize tolerance


function parse_input(filename::String)::Vector{ClawMachine}
machines = Vector{ClawMachine}()

input_string = read(filename, String)

# Updated pattern to match actual input format
pattern = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"

matches = collect(eachmatch(pattern, input_string))

if isempty(matches)
    println("No matches found! Check if input format matches pattern:")
    println("Expected format:")
    println("Button A: X+<num>, Y+<num>")
    println("Button B: X+<num>, Y+<num>")
    println("Prize: X=<num>, Y=<num>")
end

for m in matches
    button_a = (parse(Int, m.captures[1]), parse(Int, m.captures[2]))
    button_b = (parse(Int, m.captures[3]), parse(Int, m.captures[4]))
    prize = (parse(Int, m.captures[5]), parse(Int, m.captures[6]))
    
    push!(machines, ClawMachine(button_a, button_b, prize))
end

return machines
end

machines = parse_input("day_13/input.txt")

### Part 1

using LinearSolve

function find_cost_matrix(machine::ClawMachine)::Int
    ax, ay = machine.button_a
    bx, by = machine.button_b
    x, y = machine.prize
    
    # Set up system of equations:
    # |ax bx| |A| = |x|
    # |ay by| |B|   |y|
    
    detA = -bx*ay + by*ax  # Match direct method determinant
    if abs(detA) < TOLERANCE
        return 0
    end
    
    # Matrix A = |ax bx|
    #            |ay by|
    # inv(A) = 1/det * |by  -bx|
    #                   |-ay  ax|
    invA = [by -bx; -ay ax] / detA  # Fixed inverse matrix order
    A, B = invA * [x; y]
    
    if abs(A - round(A)) < TOLERANCE && abs(B - round(B)) < TOLERANCE
        return Int(round(3*A + B))
    end
    return 0
end


function find_total_cost_matrix(machines::Vector{ClawMachine})::Int
    sum(find_cost_matrix(machine) for machine in machines)
end

println("=====================================")

cost_matrix = find_total_cost_matrix(machines)

println("The total cost to reach the prize using matrix inversion is $cost_matrix")


### Part 2

function correct_claw_machine(machine::ClawMachine)::ClawMachine
    correct_prize = (machine.prize[1] + 10000000000000, machine.prize[2] + 10000000000000)
    return ClawMachine(machine.button_a, machine.button_b, correct_prize)
end

corrected_machines = correct_claw_machine.(machines)

corrected_cost = find_total_cost_matrix(corrected_machines)

println("The total cost to reach the prize with the corrected prize is $corrected_cost")