# shellcheck shell=sh

# Stick to POSIX for fun.  Omit some input validation for clarity.

x=${1-0}
y=${2-0}
instructions=$4

# Convert the compass direction to a bearing for easier rotation.
case ${3-north} in
    north) bearing=0 ;;
    east) bearing=90 ;;
    south) bearing=180 ;;
    west) bearing=270 ;;
    *)
        printf 'robot_simulator: invalid direction: %s\n' "$3" >&2
        exit 1
        ;;
esac

while [ "$instructions" ]; do
    later=${instructions#?}
    now=${instructions%"$later"}

    case $now in
        A)
            case $bearing in
                0) : "$((y += 1))" ;;
                90) : "$((x += 1))" ;;
                180) : "$((y -= 1))" ;;
                270) : "$((x -= 1))" ;;
            esac
            ;;
        L)
            # Avoid ever having to deal with negative bearings by adding
            # 270 degrees instead of subtracting 90.
            : "$((bearing = (bearing + 270) % 360))"
            ;;
        R)
            : "$((bearing = (bearing + 90) % 360))"
            ;;
        *)
            printf 'robot_simulator.sh: invalid instruction: %s\n' "$now" >&2
            exit 1
            ;;
    esac

    instructions=$later
done

# Convert the bearing back to a compass direction for output.
case $bearing in
    0) direction=north ;;
    90) direction=east ;;
    180) direction=south ;;
    270) direction=west ;;
esac

printf '%d %d %s\n' "$x" "$y" "$direction"
