# Arunc de 10 ori, vreau nr de cap sa fie intre 4 si 7:
omega <- tosscoin(10)
favorabile <- sum((4 <= rowSums(omega == 'H')) & (rowSums(omega == 'H') <= 7))
totale <- nrow(omega)
probabilitate <- favorabile / totale
probabilitate


omega_zar7 <- rolldie(7)
favorabile <- sum(rowSums(omega_zar7 %% 2 == 0) >= 3)
totale <- nrow(omega_zar7)
probabilitate <- favorabile / totale
probabilitate

# Jocuri de carti

o <- cards()

a <- 1:3
b <- 4:6
cbind(a, b)
rbind(a, b)

# OMEGA multimea tuturor evenimentelor posiblile ?
# un eveniment = submultime a lui OMEGA -> o multime de rezultate / stari finale


o1 <- cbind(o[1:13,],o[14:26,],o[27:39,],o[40:52,])

#Events in R (doar in pachetul prob)
# union(A, B) reuniunea
# intersect(A, B)
# setdiff(A, B)

# Calculati ca extragand probabilitatea dintr-un pachet de 52 de carti de joc
# sa obtinem o valoare mai mare decat 7 si culoare "Spade"
# Reprezentati intai cu evenimente
# Calculati probabilitatea

o[o['rank'] == 7,]

list_data <- list('7', '8', '9', '10', 'J', 'Q', 'K', 'A')
card <- cards()
A <- card[exists(card['rank'], where=list_data)]
