#!/bin/bash

export contract="0xA65D59708838581520511d98fB8b5d1F76A96cad"
export rpc="http://skill-based-game.challenges.paradigm.xyz:8545/f1025ffc-f592-4837-86ef-ff49f5bedfc0/main"
export pk="0xd72bca104847e8e307f23338c95a8b567d43b1e21ca2c659779aeb472bda184b"
export value="5ether"

timestamps=(1698543520)
command_to_run='cast send 0xA65D59708838581520511d98fB8b5d1F76A96cad "deal()" --value 5ether --rpc-url http://skill-based-game.challenges.paradigm.xyz:8545/f1025ffc-f592-4837-86ef-ff49f5bedfc0/main --private-key 0xd72bca104847e8e307f23338c95a8b567d43b1e21ca2c659779aeb472bda184b'

command_to_run_hit='cast send 0xA65D59708838581520511d98fB8b5d1F76A96cad "hit()" --rpc-url http://skill-based-game.challenges.paradigm.xyz:8545/f1025ffc-f592-4837-86ef-ff49f5bedfc0/main --private-key 0xd72bca104847e8e307f23338c95a8b567d43b1e21ca2c659779aeb472bda184b'


for target_timestamp in "${timestamps[@]}"; do
  current_timestamp=$(date +%s)
  echo "Current timestamp: $current_timestamp"
  sleep_seconds=$((target_timestamp - current_timestamp))

  if [ $sleep_seconds -gt 0 ]; then
    echo "Waiting for $sleep_seconds seconds to run the command."
    sleep $sleep_seconds
    $command_to_run
  else
    echo "The specified time $target_timestamp has already passed. Command will not be executed."
  fi
done
