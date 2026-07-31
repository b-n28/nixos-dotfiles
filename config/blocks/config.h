#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 1

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X)             \
    X("", "/home/borna/.local/src/dwm/bin/song-block.sh", 5, 5) \
    X("DISK:", "/home/borna/.local/src/blocks/bin/storage.sh", 5, 12) \
    X("CPU:", "vmstat 1 2 | tail -n 1 | awk '{printf \"%d%%\\n\", 100-$15}'", 5, 12) \
    X("MEM:", "free -h | awk '/^Mem/ { sub(/i/,\"\",$2); sub(/i/,\"\",$3); print $3\"/\"$2 }'", 5, 11) \
    X("", "date '+%b %d (%a) %I:%M%p'", 60, 10)

#endif  // CONFIG_H
