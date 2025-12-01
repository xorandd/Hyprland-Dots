#!/usr/bin/env bash
# original script: https://github.com/alvaniss/privacy-dots
set -euo pipefail

JQ_BIN="${JQ:-jq}"
PW_DUMP_CMD="${PW_DUMP:-pw-dump}"

mic=0
cam=0
loc=0
scr=0

mic_app=""
cam_app=""
loc_app=""
scr_app=""

# mic & camera
if command -v "$PW_DUMP_CMD" >/dev/null 2>&1 && command -v "$JQ_BIN" >/dev/null 2>&1; then
  dump="$($PW_DUMP_CMD 2>/dev/null || true)"

  mic="$(
    printf '%s' "$dump" \
    | $JQ_BIN -r '
      [ .[]
        | select(.type=="PipeWire:Interface:Node")
        | select((.info.props."media.class"=="Audio/Source" or .info.props."media.class"=="Audio/Source/Virtual"))
        | select((.info.state=="running") or (.state=="running"))
      ] | (if length>0 then 1 else 0 end)
    ' 2>/dev/null || echo 0
  )"

  if [[ "$mic" -eq 1 ]]; then
    mic_app="$(
      printf '%s' "$dump" \
      | $JQ_BIN -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Audio"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["node.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
  fi

  if command -v fuser >/dev/null 2>&1; then
      cam=0
      for dev in /dev/video*; do
          if [ -e "$dev" ] && fuser "$dev" >/dev/null 2>&1; then
              cam=1
              break
          fi
      done
  else
      cam=0
  fi

  if command -v fuser >/dev/null 2>&1; then
      for dev in /dev/video*; do
          if [ -e "$dev" ] && fuser "$dev" >/dev/null 2>&1; then
              pids=$(fuser "$dev" 2>/dev/null)
              for pid in $pids; do
                  pname=$(ps -p "$pid" -o comm=)
                  if [[ -n "$pname" ]]; then
                      cam_app+="$pname, "
                  fi
              done
          fi
      done
      cam_app="${cam_app%, }"
  fi

fi

# location
if command -v gdbus >/dev/null 2>&1; then
  loc="$(
    if ps aux | grep [g]eoclue >/dev/null 2>&1; then
      echo 1
    else
      echo 0
    fi
  )"
fi

if command -v gdbus >/dev/null 2>&1; then
    if pids=$(pgrep -x geoclue); then
        loc=1
        for pid in $pids; do
            pname=$(ps -p "$pid" -o comm=)
            [[ -n "$pname" ]] && loc_app+="$pname, "
        done
        loc_app="${loc_app%, }"
    else
        loc=0
    fi
fi

# screen sharing
if command -v "$PW_DUMP_CMD" >/dev/null 2>&1 && command -v "$JQ_BIN" >/dev/null 2>&1; then
  if [[ -z "${dump:-}" ]]; then
    dump="$($PW_DUMP_CMD 2>/dev/null || true)"
  fi

  scr="$(
      printf '%s' "$dump" \
      | $JQ_BIN -e '
          [ .[]
            | select(.info?.props?)
            | select(
                (.info.props["media.name"]? // "")
                | test("^(xdph-streaming|gsr-default)")
            )
          ]
          | (if length > 0 then true else false end)
        ' >/dev/null && echo 1 || echo 0
    )"
fi

if [[ "$scr" -eq 1 ]]; then
    scr_app="$(
    printf '%s' "$dump" \
    |   $JQ_BIN -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Video") or (.info.props."media.name"=="gsr-default_output"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["media.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
fi

# output
green="#30D158"
orange="#FF9F0A"
blue="#0A84FF"
purple="#9B32FA"
gray="#808080"

emoji() {
  local on="$1" type="$2"
  if [[ "$on" -eq 1 ]]; then
    case "$type" in
      mic)
        echo " 🎙" 
        ;;
      cam)
        echo " " 
        ;;
      loc)
        echo " 📍"  # location
        ;;
      scr)
        echo " ●"  # screen sharing
        ;;
    esac
  else
    echo ''
  fi
}

emojis=()
mic_emoji="$(emoji "$mic" "mic")"; [[ -n "$mic_emoji" ]] && emojis+=("$mic_emoji")
cam_emoji="$(emoji "$cam" "cam")"; [[ -n "$cam_emoji" ]] && emojis+=("$cam_emoji")
loc_emoji="$(emoji "$loc" "loc")"; [[ -n "$loc_emoji" ]] && emojis+=("$loc_emoji")
scr_emoji="$(emoji "$scr" "scr")"; [[ -n "$scr_emoji" ]] && emojis+=("$scr_emoji")

text="${emojis[*]}"

if [[ "$cam" -eq 1 ]]; then
  mic_status="Mic: $mic_app"
  cam_status="Cam: <span foreground=\"$gray\">$cam_app</span>"
  loc_status="Location: $loc_app"
  scr_status="Screen sharing: $scr_app"
else
  mic_status="Mic: $mic_app"
  cam_status="Cam: $cam_app"
  loc_status="Location: $loc_app"
  scr_status="Screen sharing: $scr_app"
fi

tooltip="$mic_status  |  $cam_status  |  $loc_status  |  $scr_status"

classes="privacydot"
[[ $mic -eq 1 ]] && classes="$classes mic-on" || classes="$classes mic-off"
[[ $cam -eq 1 ]] && classes="$classes cam-on" || classes="$classes cam-off"
[[ $loc -eq 1 ]] && classes="$classes loc-on" || classes="$classes loc-off"
[[ $scr -eq 1 ]] && classes="$classes scr-on" || classes="$classes scr-off"

jq -c -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$classes" \
  '{text:$text, tooltip:$tooltip, class:$class}'

