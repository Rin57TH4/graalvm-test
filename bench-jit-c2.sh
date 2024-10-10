set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

print "Starting the app 🏎️"

/home/ducnv13/Downloads/graalvm-jdk-21.0.4+8.1/bin/java -Xmx1024m -Xms1024m -jar ./target/demo-graalvm21-0.0.1-SNAPSHOT.jar &
export PID=$!
psrecord $PID --plot "jit.png" --include-children &

sleep 10
print "Done waiting for startup..."

print "Executing warmup load"
hey -n=50000 -c=8 http://localhost:8181/api?sleep=10

print "Executing benchmark load"
hey -n=50000 -c=200 http://localhost:8181/api?sleep=0

print "JVM run done!🎉"
kill $PID
sleep 1