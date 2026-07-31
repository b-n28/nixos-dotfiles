btrfs filesystem usage -b / 2>/dev/null | awk '
	/Device size:/            { size = $3 }
	/Free \(estimated\)/      { free = $3 }
	END { printf "%d%%\n", 100 * (size - free) / size }'
