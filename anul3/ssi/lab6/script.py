import secrets
import string


########### Parola ###########

alphabet = string.ascii_lowercase + \
           string.ascii_uppercase + \
           string.digits + \
           ".!$@"

length = 12

print(''.join(secrets.choice(alphabet) for _ in range(length)))

# poate fi folosit in cardul unui manager de parole pentru a sugera
# parole aleatoare pe care un user le-ar putea utiliza pentru un nou
# cont pe o anumita platforma


########### URL-safe ###########

length = 32
print(secrets.token_urlsafe(length))

# poate fi folosit la generarea de token pentru resetarea de parola
# ideea e ca el este asociat unui anumit user id pentru o perioada 
# limitata de timp, dar nu trebuie sa divulge nicio astefel de informatie


########### Hex token ###########

length = 32
print(secrets.token_hex(length))

# poate fi folosit pentru autentificare pentru un API


########### Compare ###########

result = secrets.compare_digest(secrets.token_hex(), secrets.token_hex())
print(result)


########### Binary KeyStream ###########

key = secrets.token_bytes(100)
print(key)


########### Password storing ###########

from passlib.hash import sha256_crypt

print(sha256_crypt.hash('password'))

# passlib e destul de popular
# cu ajutorul librariei pot utiliza foarte usor algoritmi
# care corespund cu normele actuale de securitate. spre exemplu
# mai sus am folosit functia de hash sha_256 + salt care intoarce
# un format specific
