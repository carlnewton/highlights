usage()
{
    echo "usage: highlights [-t]"
    echo "-t          time delay between screen captures in seconds (default is 30)"
}

ctrl_c()
{
    printf "\rScreen captures have been saved to $(tput setaf 2)${directory}$(tput sgr0)\n"
    exit
}

trap ctrl_c INT
timer=30

while [ "$1" != "" ]; do
    case $1 in
        -t | --timer )
            shift
            timer=$1
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
            ;;
    esac
    shift
done

echo "Press $(tput setaf 2)CTRL+C$(tput sgr0) to stop"

subtractTime=0
while true
do
    timeRemaining=$((timer-subtractTime))
    directory="highlights-$(date +%Y-%m-%d)"

    if [ ! -d "./${directory}" ]; then
      mkdir ./${directory}
    fi

    filename=$(date +%H-%M-%S)

    while [ $timeRemaining -gt 0 ]
    do
        printf "\r                                                        "
        printf "\rTaking screen capture in $(tput setaf 2)%d$(tput sgr0) seconds..." "$timeRemaining"
        ((timeRemaining=timeRemaining-1))
        sleep 1
    done
    start=`date +%s`
    printf "\rTaking screen capture $(tput setaf 2)${directory}/${filename}.jpg$(tput sgr0)"
    sleep 1
    screencapture -x ./${directory}/${filename}.jpg
    end=`date +%s`
    subtractTime=$((end-start))
done
