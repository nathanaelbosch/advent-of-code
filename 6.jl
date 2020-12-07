filestr = read("6.txt", String)
getgroups(filestr) = split.(split(filestr, "\n\n"))
makesets(group) = Set.(collect.(group))

countunion(set) = length(union(set...))
part1(filestr) = sum(countunion.(makesets.(getgroups(filestr))))
part1(filestr)

countintersect(set) = length(intersect(set...))
part2(filestr) = sum(countintersect.(makesets.(getgroups(filestr))))
part2(filestr)


# Unlesbarer Einzeiler:
part1(filename) = sum(map(sets -> length(union(sets...)), Set.(collect.(split.(split(read(filename, String), "\n\n"))))))
