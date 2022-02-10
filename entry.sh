#!/PBshare/zuohan/bash/bin/bash
IMG_DIR=/PBshare/zll/crop_image
MARKER_DIR=/PBshare/YiweiLi/marker_first_place
V3D=/PBshare/SEU-ALLEN/vaa3d/vaa3d

WK_DIR=$HOME/tracing
OUT_DIR=$WK_DIR/out
LOG_DIR=$WK_DIR/log
JOB_DIR=$WK_DIR/job

ALL_MARKERS_FILE=$WK_DIR/all_markers.csv

# parse args
if [ $# -ge 1 ]; then
    nJob=$1
else
    nJob=20
fi
if [ $# -ge 2 ]; then
    nNode=$2
else
    nNode=10
fi

# read all markers and save as a dir list
# also make dirs
:> $ALL_MARKERS_FILE
for marker_file in `ls $MARKER_DIR/*.marker`
do
    name=`basename $marker_file`
    id=${name%%_*}

    if [ ! -d $OUT_DIR/$id ]; then
        mkdir -p $OUT_DIR/$id
    fi
    if [ ! -d $LOG_DIR/$id ]; then
        mkdir -p $LOG_DIR/$id
    fi

    # make all markers' list, format: id,x,y,z\n
    awk -F, '$1!="##x" {printf id",%.0f,%.0f,%.0f\n",$1,$2,$3}' id=$id $marker_file | sed '1d' >> $ALL_MARKERS_FILE
done

# divide jobs
nMarker=`wc -l $WK_DIR/all_markers.tsv | cut -d' ' -f1`
if [ $[$nMarker%$nJob] -eq 0 ]; then
    ((mps=$nMarker/$nJob))
else
    ((mps=$nMarker/$nJob+1))
fi

# marker decoy file
MARKER_DECOY=$WK_DIR/tmp.marker
echo -e "##x,y,z,radius,shape,name,comment,color_r,color_g,color_b\n512,512,128,1,1,0,0,255,0,0" > $MARKER_DECOY

# run qsub
for job in `seq 1 $nJob`
do
    job_marker_file=$JOB_DIR/job_${job}.marker
    ((a=($job-1)*$mps+1))
    ((b=$job*$mps))
    sed -n "${a},${b}p" $ALL_MARKERS_FILE > $job_marker_file
    qsub -F "$job_marker_file $nNode $V3D $IMG_DIR $OUT_DIR $LOG_DIR $MARKER_DECOY" $WK_DIR/job.sh \
        -l nodes=$nNode:ppn=1 -N zzh_all_${job} -o /dev/null -e /dev/null
done
