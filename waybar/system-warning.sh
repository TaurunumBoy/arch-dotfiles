#!/bin/bash


STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/waybar-system-warning"
CPU_START_FILE="$STATE_DIR/cpu_high_since"
CPU_THRESHOLD=95
MEM_THRESHOLD=90
CPU_SUSTAIN_SECONDS=5

mkdir -p "$STATE_DIR"

# Calculate CPU usage from two /proc/stat samples
read -r _ U1 N1 S1 I1 W1 IRQ1 SIRQ1 ST1 _ < /proc/stat
TOTAL1=$((U1 + N1 + S1 + I1 + W1 + IRQ1 + SIRQ1 + ST1))
IDLE1=$((I1 + W1))

sleep 0.2

read -r _ U2 N2 S2 I2 W2 IRQ2 SIRQ2 ST2 _ < /proc/stat
TOTAL2=$((U2 + N2 + S2 + I2 + W2 + IRQ2 + SIRQ2 + ST2))
IDLE2=$((I2 + W2))

TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IDLE_DIFF=$((IDLE2 - IDLE1))

if (( TOTAL_DIFF > 0 )); then
    CPU=$(( (TOTAL_DIFF - IDLE_DIFF) * 100 / TOTAL_DIFF ))
else
    CPU=0
fi

# Calculate RAM usage based on available memory
MEM=$(awk '
    /^MemTotal:/     { total = $2 }
    /^MemAvailable:/ { available = $2 }
    END {
        if (total > 0)
            printf "%d", (total - available) * 100 / total
        else
            print 0
    }
' /proc/meminfo)

# Track sustained CPU load
NOW=$(date +%s)

if (( CPU >= CPU_THRESHOLD )); then
    if [[ ! -f "$CPU_START_FILE" ]]; then
        printf '%s\n' "$NOW" > "$CPU_START_FILE"
    fi
    CPU_START=$(cat "$CPU_START_FILE")
    CPU_DURATION=$((NOW - CPU_START))
else
    rm -f "$CPU_START_FILE"
    CPU_DURATION=0
fi

CPU_CRITICAL=false
if (( CPU >= CPU_THRESHOLD && CPU_DURATION >= CPU_SUSTAIN_SECONDS )); then
    CPU_CRITICAL=true
fi

# Generate warning
if [[ "$CPU_CRITICAL" == true ]] && (( MEM >= MEM_THRESHOLD )); then
    echo '{"text":"CRITICAL FAILURE // SYSTEM SHUTDOWN IMMINENT","class":"critical"}'
elif [[ "$CPU_CRITICAL" == true ]]; then
   echo '{"text":"SYSTEM WARNING // MAGI CORE SHUTDOWN","class":"critical"}'
elif (( MEM >= MEM_THRESHOLD )); then
    echo '{"text":"SYSTEM WARNING // MEMORY BUFFER EXCEEDED","class":"critical"}'
else
    echo '{"text":"","class":"hidden"}'
fi
