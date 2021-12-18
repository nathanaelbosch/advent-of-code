# Trick shot
test_target_area = (x=(20, 30), y=(-10, -5))
target_area = (x=(287, 309), y=(-76, -48))

step((p_x, p_y), (v_x, v_y)) = (p_x + v_x, p_y + v_y), (max(0, v_x - 1), v_y - 1)
step((1,1), (10, 10))


vx_min, vx_max = 20, 30

is_over(p, v, target_area) = p[1] > target_area.x[2] || (v[2] <= 0 && p[2] < target_area.y[1])
hit_target(p, target_area) = ((target_area.x[1] <= p[1] <= target_area.x[2])
                              && (target_area.y[1] <= p[2] <= target_area.y[2]))
function check_trajectory(v_start, target_area=target_area; verbose=false)
    p, v = (0,0), v_start
    verbose && display(p)
    while !is_over(p, v, target_area)
        if hit_target(p, target_area)
            return true
        end
        p, v = step(p, v)
        verbose && display(p)
    end
    return false
end
@assert check_trajectory((7,2), test_target_area; verbose=true)
@assert check_trajectory((6,3), test_target_area; verbose=true)
@assert !check_trajectory((17,-4), test_target_area; verbose=true)

f(i, j; target_area=target_area) = begin
    # display((i, j))
    # check_trajectory((i, j), test_target_area)
    check_trajectory((i, j), target_area)
end
xrange = 1:309
yrange = -76:1000
out = f.(xrange, yrange'; target_area=test_target_area);
working = findall(out);
max_y_velocity = yrange[maximum([i.I[2] for i in working])]


out = f.(xrange, yrange'; target_area=target_area);
working = findall(out);
max_y_velocity = yrange[maximum([i.I[2] for i in working])]
get_max_height(vy) = vy == 0 ? 0 : vy + get_max_height(vy-1)

ex1() = get_max_height(max_y_velocity)
ex1()

ex2() = length(working)
ex2()
