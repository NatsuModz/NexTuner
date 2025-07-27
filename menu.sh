#!/system/bin/sh
# menu-9-columns.sh – Toggle 9 named features in two-column menu

if ! [[ "$SHELL" == "/bin/sh" || "$USER" == "shell" || "$(whoami)" == "shell" ]]; then
    echo ""
    echo -e "\e[1;91mShizuku not running on Terminal\e[0m"
    echo ""
fi

CFG="/data/local/tmp/cfg"

# Custom feature names
features=("Battery Restrictions" "Memory Tweaks" "Responsive Touch" "GPU Optimizer" "FPS Tweaks" "Performance Mode" "Boost Game" "ADD Boost Game" "Optimize Game")

# Initialize config if missing (all disabled = 1)
[[ -f $CFG ]] || printf "state=(0 1 1 1 1 1 1 1 1)\n" > "$CFG"

while true; do
  source "$CFG"  # load state array

  echo
  echo "Menu"

  # Print items in two columns: first column is i=0..4, second column is i=5..9
  for i in 0 1 2 3 4; do
    # left column
    left_num=$((i+1))
    left_name="${features[i]}"
    left_status=$([[ ${state[i]} -eq 0 ]] && echo -e "\e[1;92mE\e[0m" || echo -e "\e[1;91mD\e[0m")
    
    # right column (i+5)
    right_idx=$((i+5))
    if [[ $right_idx -lt 9 ]]; then
      right_num=$((right_idx+1))
      right_name="${features[right_idx]}"
      right_status=$([[ ${state[right_idx]} -eq 0 ]] && echo -e "\e[1;92mE\e[0m" || echo -e "\e[1;91mD\e[0m")
      printf "%d] %s [%s]\t\t%d] %s [%s]\n" \
        "$left_num" "$left_name" "$left_status" \
        "$right_num" "$right_name" "$right_status"
    else
      # last line: only left + Exit
      printf "%d] %s [%s]\t\tE] Exit\n" "$left_num" "$left_name" "$left_status"
    fi
  done

  # Prompt user
  echo ""
  echo -n "Select option (1-9, E): "; read choice
  echo ""
  
  case $choice in
    1 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        settings put global automatic_power_save_mode 0
        settings put global adaptive_battery_management_enabled 0
        settings put global sem_enhanced_cpu_responsiveness 0
        settings put global restricted_device_performance 0
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Auto Power Save Mode"
        sleep 1; echo -e "\e[1;92mAdaptive\e[0m Battery Management"
        sleep 1; echo -e "\e[1;92mEnhance\e[0m CPU Responsiveness"
        sleep 1; echo -e "\e[1;92mRestricted\e[0m Device Performance"
        sleep 1
      else
        {
        settings put global automatic_power_save_mode 1
        settings put global adaptive_battery_management_enabled 1
        settings put global sem_enhanced_cpu_responsiveness 1
        settings put global restricted_device_performance 1
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Auto Power Save Mode"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Adaptive Battery Management"
        sleep 1; echo -e "\e[1;91mRemoved\e[0m CPU Responsiveness"
        sleep 1; echo -e "\e[1;91mUn-restricted\e[0m Device Performance"
        sleep 1
      fi
      ;;
    2 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        settings put global cached_apps_freezer 1 default
        settings put global zram 0 default
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mFreeze\e[0m Apps Cache"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m ZRAM"
        sleep 1
      else
        {
        settings put global cached_apps_freezer 0 default
        settings put global zram 1 default
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mUn-Freezed\e[0m Apps Cache"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m ZRAM"
        sleep 1
      fi
      ;;
    3 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        settings put secure adaptive_sleep 0
        settings put secure long_press_timeout 250
        settings put secure multi_press_timeout 250
        settings put secure tap_duration_threshold 0.0
        settings put secure touch_blocking_period 0.0
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Adaptive Sleep"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Responsive Touch"
        sleep 1
      else
        {
        settings put secure adaptive_sleep 1
        settings put secure long_press_timeout 500
        settings put secure multi_press_timeout 500
        settings put secure tap_duration_threshold 0.1
        settings put secure touch_blocking_period 0.1
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Adaptive Sleep"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Responsive Touch"
        sleep 1
      fi
      ;;
    4 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        setprop debug.force-opengl 1
        setprop debug.hwc.force_gpu_vsync 1
        setprop debug.enable-vr-mode 1
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mForced\e[0m OpenGL"
        sleep 1; echo -e "\e[1;92mForced\e[0m GPU Vsync"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m VR Mode"
        sleep 1
      else
        {
        setprop debug.force-opengl 0
        setprop debug.hwc.force_gpu_vsync 0
        setprop debug.enable-vr-mode 0
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mUn-forced\e[0m OpenGL"
        sleep 1; echo -e "\e[1;91mUn-forced\e[0m GPU Vsync"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m VR Mode"
        sleep 1
      fi
      ;;
    5 )
      echo -n "Device Supported FPS (60, 90, 120): "; read ffps
      echo ""
      
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        settings put system peak_refresh_rate $ffps.0
        settings put system min_refresh_rate $ffps.0
        settings put system intelligent_sleep_mode 0
        settings put system multicore_packet_scheduler 1
        } >/dev/null 2>&1
        sleep 1; echo -e "Set Peak Refresh Rate: \e[1;92m$ffps.0\e[0m"
        sleep 1; echo -e "Set Min Refresh Rate: \e[1;92m$ffps.0\e[0m"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Intelligent Sleep Mode"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Multicore Packet Scheduler"
        sleep 1
      else
        {
        settings put system peak_refresh_rate $ffps.0
        settings put system min_refresh_rate $ffps.0
        settings put system intelligent_sleep_mode 1
        settings put system multicore_packet_scheduler 0
        } >/dev/null 2>&1
        sleep 1; echo -e "Set Peak Refresh Rate: \e[1;92m$ffps.0\e[0m"
        sleep 1; echo -e "Set Min Refresh Rate: \e[1;92m$ffps.0\e[0m"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Intelligent Sleep Mode"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Multicore Packet Scheduler"
        sleep 1
      fi
      ;;
    6 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        cmd power set-fixed-performance-mode-enabled true
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Fixed Performance Mode"
        sleep 1
      else
        {
        cmd power set-fixed-performance-mode-enabled false
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Fixed Performance Mode"
        sleep 1
      fi
      ;;
    7 )
      echo -n "Game Package (ex: com.mobile.legends): "; read sgame
      echo -n "Device Supported FPS (60, 90, 120): "; read sfps
      echo -n "Downscale (0.1 - 1.0): "; read sds
      echo ""
      
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        cmd game mode performance $sgame
       cmd device_config put game_overlay $sgame \
         mode=1,downscaleFactor=$sds:mode=2,downscaleFactor=$sds:mode=3,downscaleFactor=$sds
       
       cmd device_config put game_overlay $sgame \
         mode=1,fps=$sfps:mode=2,fps=$sfps:mode=3,fps=$sfps
       
       cmd game set \
         --mode 2 \
         --downscale $sds \
         --fps $sfps \
         $sgame
         } >/dev/null 2>&1
         sleep 1; echo -e "Set Game Mode Performance in \e[1;92m$sgame\e[0m"
         sleep 1; echo -e "Set Downscaling Ratio: \e[1;92m$sds\e[0m"
         sleep 1; echo -e "Set Game Refresh Rate: \e[1;92m$sfps\e[0m"
         sleep 1
      else
      {
        cmd game mode standard $sgame
       cmd device_config put game_overlay $sgame \
         mode=1,downscaleFactor=$sds:mode=2,downscaleFactor=$sds:mode=3,downscaleFactor=$sds
       
       cmd device_config put game_overlay $sgame \
         mode=1,fps=$sfps:mode=2,fps=$sfps:mode=3,fps=$sfps
       
       cmd game set \
         --mode 2 \
         --downscale $sds \
         --fps $sfps \
         $sgame
         } >/dev/null 2>&1
         sleep 1; echo -e "Set Game Mode Performance in \e[1;92m$sgame\e[0m"
         sleep 1; echo -e "Set Downscaling Ratio: \e[1;92m$sds\e[0m"
         sleep 1; echo -e "Set Game Refresh Rate: \e[1;92m$sfps\e[0m"
         sleep 1
      fi
      ;;
    8 )
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        cmd perfhint boost \
          --tid 12345 \
          --duration 2000
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Performance Boost"
        sleep 1
      else
        {
        cmd perfhint boost \
          --tid 12345 \
          --duration 2000
        } >/dev/null 2>&1
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Performance Boost"
        sleep 1
      fi
      ;;
    9 )
      echo -n "Game Package (ex: com.mobile.legends): "; read ngame
      echo ""
      
      idx=$((choice-1))
      state[idx]=$((1 - state[idx]))

      if [[ ${state[idx]} -eq 0 ]]; then
        {
        pm trim-caches 0k
        am set-standby-bucket $ngame active
        cmd thermalservice override-status 0
        } >/dev/null 2>&1
        sleep 1; echo -e "Trimes Caches to \e[1;92m0k\e[0m"
        sleep 1; echo -e "Set Game $ngame: \e[1;92mActive\e[0m"
        sleep 1; echo -e "\e[1;92mEnabled\e[0m Override-Status"
        sleep 1
      else
        {
        pm trim-caches 1024k
        am set-standby-bucket $ngame working_set
        cmd thermalservice override-status 1
        } >/dev/null 2>&1
        sleep 1; echo -e "Trimes Caches to \e[1;92m1024k\e[0m"
        sleep 1; echo -e "Set Game $ngame: \e[1;92mWorking Set\e[0m"
        sleep 1; echo -e "\e[1;91mDisabled\e[0m Override-Status"
        sleep 1
      fi
      ;;
    E|e )
      echo "Exited."; echo ""; exit 0
      ;;
    *)
      echo "Invalid option."
      ;;
  esac

  # Save updated state
  printf 'state=(%s)\n' "${state[*]}" > "$CFG"
  echo
  echo -ne "Press Enter to \e[1;92mcontinue\e[0m or 0 to \e[1;91mExit\e[0m: "; read lastchoice
  if [ "$lastchoice" == "0" ]; then
  echo
  exit 0
  fi
clear
done