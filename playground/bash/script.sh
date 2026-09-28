#!/usr/bin/env bash
names=(Ada Linus Grace)
greet(){
echo "Hello, $1!"
}
for n in ${names[@]}
do
greet $n
done
if [ -z $UNSET ]; then echo "unset"; fi
