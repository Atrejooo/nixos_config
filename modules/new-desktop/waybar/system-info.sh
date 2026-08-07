#!/usr/bin/env bash

# CPU usage
cpu=$(top -bn1 | awk -F, '/^%Cpu/{split($4,a," "); printf "%.0f", 100 - a[1]; exit}')
[[ -z "$cpu" ]] && cpu="N/A"

# Memory usage
mem=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2}')
[[ -z "$mem" ]] && mem="N/A"

# Watt usage - detects any battery that provides power readings
watt="N/A"
batt_dir=""
for d in /sys/class/power_supply/*; do
    if [[ "$(cat "$d/type" 2>/dev/null)" == "Battery" ]]; then
        batt_dir="$d"
        break
    fi
done
if [[ -n "$batt_dir" ]]; then
    if [[ -r "$batt_dir/power_now" ]]; then
        watt=$(awk '{printf "%.1f", $1/1000000}' "$batt_dir/power_now")
    elif [[ -r "$batt_dir/current_now" && -r "$batt_dir/voltage_now" ]]; then
        watt=$(awk -v c="$(cat "$batt_dir/current_now")" \
                   -v v="$(cat "$batt_dir/voltage_now")" \
            'BEGIN{printf "%.1f", c*v/1e12}')
    fi
fi

# CPU temperature - prefer dedicated CPU hwmon drivers
temp="N/A"
for h in /sys/class/hwmon/hwmon*; do
    hname="$(cat "$h/name" 2>/dev/null)"
    case "$hname" in
        coretemp|k8temp|k9temp|k10temp|zenpower|zenpower2)
            if [[ -r "$h/temp1_input" ]]; then
                temp=$(awk '{printf "%.0f", $1/1000}' "$h/temp1_input" 2>/dev/null)
                break
            fi
            ;;
    esac
done

# Fallback: hottest available thermal zone
if [[ "$temp" == "N/A" ]]; then
    best=0
    for z in /sys/class/thermal/thermal_zone*/temp; do
        if [[ -r "$z" ]]; then
            val=$(awk '{print int($1/1000)}' "$z" 2>/dev/null)
            if (( 10#$val > 10#$best )); then
                best="$val"
            fi
        fi
    done
    [[ -n "$best" ]] && temp="$best"
fi
[[ -z "$temp" ]] && temp="N/A"

echo "{\"text\":\" ${cpu}%\n ${mem}%\n󱐋 ${watt}W\n ${temp}C\"}"