#!/bin/bash
while true
do
    # Define temperature and speeds in arrays
    TEMP_POINTS=(40 60 75 85)       # Temperature points
    FAN_SPEEDS=(30 45 65 100)       # Speed in %

    # Read GPU temperature
    TEMPERATURE=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

    # Set start fan speed
    FAN_SPEED=${FAN_SPEEDS[0]} # Default first value in array

    # Calcula la velocidad del ventilador según las temperaturas de control
    for i in "${!TEMP_POINTS[@]}"; do
        if [ "$TEMPERATURE" -lt "${TEMP_POINTS[i]}" ]; then
            FAN_SPEED=${FAN_SPEEDS[i]}
            break
        fi
    done

    # Set values to nvidia-settings
    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" \
                    -a "[fan:0]/GPUTargetFanSpeed=$FAN_SPEED" \
                    -a "[fan:1]/GPUTargetFanSpeed=$FAN_SPEED" 1>/dev/null 2>/dev/null
                    #-a "[fan:1]/GPUTargetFanSpeed=$FAN_SPEED" >> /var/log/gpu_fan_control.log 2>/dev/null
                    # Add more lines if you have more than two fans

    # Log opcional
    #echo "$(date): Temp=$TEMPERATURE, FanSpeed=$FAN_SPEED" >> /var/log/gpu_fan_control.log
    #echo $TEMPERATURE
    sleep 15
done
