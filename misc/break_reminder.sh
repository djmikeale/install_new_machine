#!/bin/bash
set -euo pipefail

# Initialize counter
counter=0

# Configs
WORK_INTERVAL_MIN=15              # 15 minutes work
SHORT_BREAK_SEC=10                # 10 seconds break
LONG_BREAK_INTERVAL=2             # Every 4th break
LONG_BREAK_MIN=10                 # 10 minutes break (every xth break, do longer break, as per LONG_BREAK_INTERVAL
REMIND_DELAY_MIN=5                # Delay when user clicks "Remind in 5 min"

# Signal trap for graceful exit
trap "echo 'Break reminder stopped'; exit 0" SIGINT SIGTERM

while true; do
    # worrr wor worrr woor work
    sleep 5
    #sleep $(($WORK_INTERVAL_MIN * 60))
    ((counter++))

    # break
    if (( counter % $LONG_BREAK_INTERVAL == 0 )); then
            while true; do
                NOW_PLUS_TEN_MINUTES=$(date -v +${LONG_BREAK_MIN}M +"%H:%M")
                MESSAGE="Time for your $LONG_BREAK_MIN minute break! \nCome back at $NOW_PLUS_TEN_MINUTES"
                response=$(osascript -e \
                    "tell application \"System Events\" to display dialog \
                    \"$MESSAGE\" \
                    buttons {\"Remind in 5 min\", \"Done!\"} \
                    default button \"Done!\""\
                    )

                case $(echo "$response") in
                    "button returned:Remind in 5 min")
                        #sleep $(($REMIND_DELAY_MIN * 60))
                        sleep 1
                        ;;
                    "button returned:Done!")
                        break
                        ;;
                esac
            done
    else
        # 10 seconds break
        MESSAGE="$SHORT_BREAK_SEC seconds break - stand up, look away, and get back to work, slave!"
        osascript -e \
            "tell application \"System Events\" to display dialog \
            \"$MESSAGE\" \
            buttons {\"Done\"} \
            default button \"Done\""
    fi
done
