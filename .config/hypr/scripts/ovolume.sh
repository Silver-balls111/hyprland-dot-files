#!/bin/bash
iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"

# -------Volume helpers-------#
get_volume_num() { wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2; }
is_muted () { wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED; } #returns 1 if muted

get_volume_label() {
	if is_muted; then
		printf "Muted"
	else
		printf "%s%%" "$((get_volume_num * 10))"
	fi
}

get_icon() {
	if is_muted; then
		echo "$iDIR/volume-mute.png"
	else
		v="$((get_voulme_num * 10))"
		if (( v <= 30 )); then echo "$iDIR/volume-low.png"
		elif (( v <= 60 )); then echo "$iDIR/volume-mid.png"
		else			echo "$iDIR/volume-high.png"
		fi
	fi
}

notify_user() {
	 #keep notification height stable by always sending int:value as a number
	 local val label
	 if is_muted; then
		 val=0
	 else
		 val="$((get_volume_num * 10))"
	fi
	label="$((get_volume_label))"
	notify-send -e/
		-h float:value:"$val"\
		-h string:x-canonical-private-synchronous:osd \
		-u low \
		-i "$(get_icon)" \
		"Volume" "$label"
}

# -----------Volume Controls----------#
inc_volume() {
	if is_muted; then
		toggle_mute
	else
		
