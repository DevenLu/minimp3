set -e

if [ ! -d "fate-suite.ffmpeg.org" ]; then
  wget -np -r --level=1 http://fate-suite.ffmpeg.org/mp3-conformance/
  cp vectors/l3-he_mode16.pcm fate-suite.ffmpeg.org/mp3-conformance/he_mode.pcm
fi

gcc -Dminimp3_test -O2 -g -o minimp3 minimp3.c -lm

APP=./minimp3

set +e
for i in fate-suite.ffmpeg.org/mp3-conformance/*.bit; do
$APP $i ${i%.*}.pcm
retval=$?
echo $i exited with code=$retval
if [ ! $retval -eq 0 ]; then
  exit 1
fi
done
