#!/bin/bash

main() {
    echo -e "\n#################################################"
    echo -e "#####  YOUTUBE VIDEO AND AUDIO DOWNLOADER  ######"
    echo -e "#################################################"
    link=$(get_url)

    case $(download_format) in
        "1")
            download_mp3 "$link" "$(download_directory)"
            ;;
        "2")
            download_mp4 "$link" "$(download_quality)" "$(download_directory)"
            ;;
    esac
}

get_url() {
    read -p "Enter YouTube video/playlist URL: " link
    link=$(echo "$link" | awk '{$1=$1};1')
    if [[ $link == "https://"* ]]; then
        echo "$link"
    else
        echo "Invalid URL!"
        sleep 1
        get_url
    fi
}

download_format() {
    echo -e "\nChoose download format"
    echo "(1) Download YouTube video in .mp3 format"
    echo "(2) Download YouTube video in .webm format"
    read -p "Enter the number corresponding to your choice: " choice
    if [[ $choice == "1" || $choice == "2" ]]; then
        echo "$choice"
    else
        echo "Invalid input!"
        sleep 1
        download_format
    fi
}

download_quality() {
    echo -e "\nChoose download quality"
    echo "(1) 480p"
    echo "(2) 720p"
    echo "(3) 1080p"
    echo "(4) 1440p"
    echo "(5) 2160p"
    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        '1') echo '480' ;;
        '2') echo '720' ;;
        '3') echo '1080' ;;
        '4') echo '1440' ;;
        '5') echo '2160' ;;
        *)
            echo "Invalid input!"
            sleep 1
            download_quality
            ;;
    esac
}

download_directory() {
    default_path="$HOME/Videos/downloads"
    echo -e "\nDefault download directory: $default_path"

    echo "Enter new download directory to override the default directory, otherwise skip"
    home="$HOME/"
    read -p "New directory: $home" new_path
    if [[ -z $new_path ]]; then
        echo "$default_path"
    else
        echo "${home}${new_path}"
    fi
}

download_mp3() {
    local url="$1"
    local output_directory="$2"
    command="yt-dlp -x --audio-format mp3 --embed-thumbnail --embed-metadata -o '${output_directory}/%(title)s.%(ext)s' -f 'bestaudio/best' '$url'"
    execute_ytdlp_command "$command"
}

download_mp4() {
    local url="$1"
    local quality="$2"
    local output_directory="$3"
    command="yt-dlp -o '${output_directory}/%(title)s.%(ext)s' -f 'bestvideo[height<=$quality]+bestaudio/best[height<=$quality]' '$url'"
    execute_ytdlp_command "$command"
}

execute_ytdlp_command() {
    local command="$1"
    eval "$command"
}

main
