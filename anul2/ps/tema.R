# Stefan-Octavian Radu - grupa 234
# Tema Probabilitati si statistica

# functia gamma
fgama <- function(x, a) {
  x ^ (a - 1) * exp(-x)
}

gama <- function(n) {
  if (n == floor(n)) return(factorial(n - 1))
  if (n == .5) return(sqrt(pi))
  if (n > 1) return ((n - 1) * gama(n - 1))
  return(integrate(fgama, 0, Inf, a = n)$value)
}

# functia beta
beta <- function(a, b) {
  if (a + b == 1) {
    return(pi / sin(a * pi))
  }
  return (gama(a) * gama(b) / gama(a + b));
}

beta(0.2, 0.8)
beta(0.2, 4)


# 1
(X <- RV(c(2, 3), c(1/5, 4/5)))
(Y <- RV(c(-3, -2), c(4/5, 1/5)))

3 * X
X ** -1
cos(pi * X / 2) # aici e diferit ca nu da 0, ci ceva foarte
# apropiat de 0 din cauza erorii in virgula mobila
Y ** 2
Y + 3

(X <- RV(c(0, 9), c(1/2, 1/2)))
(Y <- RV(c(-3, 1), c(1/7, 6/7)))

X - 1
1 / (X ** 2)
sin(pi*X/4)
5*Y
exp(Y)

# 2
(X <- RV(c(2, 3), c(1/5, 4/5)))
(Y <- RV(c(-3, -2), c(4/5, 1/5)))

2 * X + 3 * Y
3 * X - Y

ret <- (X ^ 2 * Y ^ 3)
for (i in ret[1:4]) {
  li <- unlist(strsplit(i, ","))
  print(as.numeric(li[1]) * as.numeric(li[2]))
}

(X <- RV(c(0, 9), c(1/2, 1/2)))
(Y <- RV(c(-3, 1), c(1/7, 6/7)))

X - Y
X ** 2 + 3 * Y


# plot a
(X <- RV(c(2, 3), c(1/5, 4/5)))
(Y <- RV(c(-3, -2), c(4/5, 1/5)))
plot(X)
plot(3 * X)
plot(X ^ -1)
plot(cos(pi / 2 * X))
plot(Y)
plot(Y ^ 2)
plot(Y + 3)

# plot b
(X <- RV(c(0, 9), c(1/2, 1/2)))
(Y <- RV(c(-3, 1), c(1/7, 6/7)))
plot(X)
plot(X - 1)
plot(1 / X ^ 2)
plot(sin(pi / 4 * X))
plot(Y)
plot(5 * Y)
plot(exp(Y))