#!/PBshare/zuohan/bash/bin/bash
export DISPLAY=:30;Xvfb :30 -auth /dev/null &
marker_list=$1
nProc=$2
vaa3d=$3
IMG_DIR=$4
OUT_DIR=$5
LOG_DIR=$6
MARKER_DECOY=$7
j="\j"
for line in `cat $marker_list`
do
    while (( ${j@P} > $nProc )); do
        wait -n
    done
    arr=(${line//,/ })
    pref=${arr[0]}/${arr[1]}_${arr[2]}_${arr[3]}
    img=$IMG_DIR/${pref}.v3draw
    swc=$OUT_DIR/${pref}.swc
    log=$LOG_DIR/${pref}.txt
    (timeout 30m $vaa3d -x libvn2 -f app2 -i $img -o $swc -p $MARKER_DECOY 1> $log) &
done