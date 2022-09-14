diff -q $1 $2 > /dev/null

if [[ $? -eq 0 ]]; then
  echo "ok"
elif [[ $? -eq 1 ]]; then
  echo "not ok"
fi
