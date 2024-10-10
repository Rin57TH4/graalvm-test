set -e

function print() {
    printf "\033[1;35m$1\033[0m\n"
}

print "Starting the native app 🚀"

./target/demo-graalvm21 -Xmx512m &
export PID=$!
psrecord $PID --plot "graalvm-native.png" --include-children &

sleep 4
print "Done waiting for startup..."

print "Executing warmup load"
hey -n=500 -c=8 http://localhost:8181/api?sleep=0

print "Executing benchmark load"
hey -n=50000 -c=100 http://localhost:8181/api?sleep=0

print "Native run done!🎉"
kill $PID
sleep 1