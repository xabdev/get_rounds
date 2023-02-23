#!/bin/bash

clear

echo "welcome to get_rounds.sh"

echo ""

read -p "Do you want to rip a new training video? (y/n): " rip_video

if [ $rip_video == "y" ]
then

    read -p "Enter the URL of the new training video: " video_url
    yt-dlp -f b -S "height:720" -o 720.mp4 ${video_url}

fi


read -p "Enter the map name: " map_name
map_name=${map_name^^}
clip_size=180

echo ""

read -p "Enter the number of clips you want to take: " num_clips

if [ $num_clips == "1" ]
then

    read -p "Custom length? (y/n): " c_length

    if [ $c_length == "y" ]
    then

        read -p "Enter new clip length in seconds: " clip_size
    fi
fi

# Declare arrays to store start time and output file name
start_hour_arr=()
start_minute_arr=()
start_second_arr=()
output_file_arr=()

# Loop through to get all the user inputs
for (( i=1; i<=$num_clips; i++ ))
do
    read -p "Enter the start hour for clip $i (00-23): " start_hour
    read -p "Enter the start minute for clip $i (00-59): " start_minute
    read -p "Enter the start second for clip $i (00-59): " start_second
    
    start_hour_arr+=("$start_hour")
    start_minute_arr+=("$start_minute")
    start_second_arr+=("$start_second")

    output_file="${map_name}${start_hour}H${start_minute}M${start_second}S.mp4"
    output_file_arr+=("$output_file")
done

# Loop through arrays to process FFmpeg requests
for (( i=0; i<$num_clips; i++ ))
do
    start_time="${start_hour_arr[$i]}:${start_minute_arr[$i]}:${start_second_arr[$i]}"
    ffmpeg -loglevel error -i 720.mp4 -ss $start_time -t $clip_size -c copy ${output_file_arr[$i]}
    echo "New clip: ${output_file_arr[$i]}!"
done


#yt-dlp -f 'bv*[height=1080]+ba'  https://www.youtube.com/watch?v=vwaZwd7L_00
