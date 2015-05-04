#!/bin/bash
# Name: Jarrod Rotolo (Rotolo,Jarrod)
# Project: 4 (Shell Programming)
# File: batch_resize.sh
# Instructor: Feng Chen
# Class: cs4103-sp15
# LogonID: cs410331
# Description: A script to copy jpeg files and resize them based on user inputed ratios.

# Parses and checks command line args
# Side Effects: Creates variables input_dir, output_dir, ratio_array, num_of_ratios
function process_args {
  if [ "$1" = "help" ]; then
    echo "----------------------------------- Help Page -----------------------------------"
    echo "USAGE: batch_resize <input Directory> <Output Directory> <Ratio(s)>"
    echo "DESCRIPTION: This program will copy all jpegs from the specified input directory and will resize each jpeg before the copy"
    exit 0
  elif [ "$#" -lt 3 ]; then
    echo "Not enough arguments"
    echo "USAGE: batch_resize <input Directory> <Output Directory> <Ratio(s)>"
    exit 0
  else
    input_dir=$1
    output_dir=$2
    shift
    shift
    ratio=$@
    ratio_array=($ratio)
    num_of_ratios=$#
    totals_array="0"
    i="0"

    # Dynamically create array to hold totals respective to their ratios
    while [ $i -lt $num_of_ratios ]; do
      totals_array[${ratio_array[$i]}]="0"
      ((i++))
    done

  fi
}

# Creates output directory for processed images
function create_output_dir {
  if [ ! -d "$output_dir" ]; then
    mkdir temp
    cp -r $input_dir temp
    cd temp
    mv $input_dir $output_dir
    cp -r $output_dir ../
    cd ..
    rm -rf temp
  else
    echo "Output directory already exists!"
    exit 0
  fi
}

# Function resizes a single image and records relevant info
# args: image_name
function resize_image {
  current_dir=$(echo "$1" | cut -d '/' -f 1)
  input_image=$(echo "$1" | cut -d '/' -f 2)
  image_name=$(echo "$input_image" | cut -d '.' -f 1)
  original_image_size=$(wc -c "$current_dir/$input_image" | awk '{print $1;}')
  original_total_size=$((original_total_size+original_image_size))

  for factor in ${ratio_array[@]}
  do

    output_image="$image_name-r$factor.jpg"

    echo "Resizing $input_image by $factor%..."
    convert -resize "$factor%" "$current_dir/$input_image" "$current_dir/$output_image"
    echo "Image saved as $output_image"
    echo ""

    new_image_size=$(wc -c "$current_dir/$output_image" | awk '{print $1;}')
    new_total_size=$((new_total_size+new_image_size))
    totals_array[$factor]=$((totals_array[$factor]+new_image_size))
    print_image_info $input_image $output_image $original_image_size $new_image_size
  done
}

# Prints the before/after info for an image
# args: input_image, output_image, original_image_size, new_image_size
function print_image_info {
  echo "--------------------"
  echo "Original Image Info:"
  echo "Name: $1"
  echo "Size: $3 bytes"
  echo "--------------------"
  echo "Resized Image Info:"
  echo "Name: $2"
  echo "Size: $4 bytes"
  echo "--------------------"
  echo ""
}

# Prints the final results of the script
function print_conclusion_info {
  echo "All done! Conclusion info below:"
  echo "Total number of files processed: $num_processed_files"
  echo "Total size of original files: $original_total_size bytes"
  for factor in ${ratio_array[@]}; do
    echo "Total size of $factor% scaled files: ${totals_array[$factor]} bytes"
  done
}

# Main driver function to run program
# args: $@
function main {
	num_processed_files=0
	process_args $@
	create_output_dir
	cd $output_dir
	for dir in * ; do
		for i in $(find $dir -name "*.jpg"); do
			resize_image $i
			num_processed_files=$((num_processed_files+num_of_ratios))
		done
	done
  print_conclusion_info
}

main $@
