input = readlines("18.txt")


⨦(a,b) = a * b  # define "multiplication" with same precedence as "+"
sum(map(l -> eval(Meta.parse(replace(l, "*" => "⨦"))), input))

⨱(a,b) = a + b  # define "addition" with precedence of "*"
sum(map(l -> eval(Meta.parse(replace(replace(l, "*" => "⨦"), "+" => "⨱"))), input))
