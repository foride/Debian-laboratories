#!/bin/bash

# Set default values for SOURCE_DIR, RM_LIST, and TARGET_DIR
SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-2remove}
TARGET_DIR=${3:-bakap}

# Create TARGET_DIR if it doesn't exist
if [[ ! -d "${TARGET_DIR}" ]]; then
	mkdir "${TARGET_DIR}"
fi

# Remove files listed in RM_LIST from SOURCE_DIR
for THING in ${RM_LIST}; do
	FILEPATH="${SOURCE_DIR}/${THING}"
	if [[ -e "${THING}" ]]; then
		rm -rf "${FILEPATH}"
	fi
done

# Iterate over each line in RM_LIST file
while IFS= read -r FILE_NAME; do
	# Full path to the potential file to remove
	FULL_PATH="${SOURCE_DIR}/${FILE_NAME}"
	
	# Check if the file exists in SOURCE_DIR
	if [ -f "$FULL_PATH" ]; then
		# If the file exists, remove it
		rm "$FULL_PATH"
	else
		# If the file doesn't exist, move or copy it to TARGET_DIR
		if [[ -f "${FILE_NAME}" ]]; then
			mv "${FILE_NAME}" "${TARGET_DIR}"
		elif [[ -d "${FILE_NAME}" ]]; then
			cp -r "${FILE_NAME}" "${TARGET_DIR}"
		fi
	fi
done < "$RM_LIST"

# Move or copy remaining files from SOURCE_DIR to TARGET_DIR
for FILE in "${SOURCE_DIR}"/*; do
	if [[ ! -e "${RM_LIST}" ]] && [[ -f "${FILE}" ]]; then
		mv "${FILE}" "${TARGET_DIR}"
	elif [[ -d "${FILE}" ]]; then
		cp -r "${FILE}" "${TARGET_DIR}"
	fi
done

# Count the remaining files in SOURCE_DIR
REMAINING_FILES=$(find "${SOURCE_DIR}" -type f | wc -l)

# Display appropriate message based on the number of remaining files
if [[ "${REMAINING_FILES}" -ge 1 ]]; then
	echo "There are still some files remaining."
fi

if [[ "${REMAINING_FILES}" -gt 4 ]]; then
	echo "There are more than 4 files remaining."
elif [[ "${REMAINING_FILES}" -ge 2 ]]; then
	echo "There are 2 or 3 files remaining."
else
	echo "No files remaining."
fi

# Get the current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Define the backup file name with the current date
BACKUP_FILE_NAME="backup_${CURRENT_DATE}.zip"

# Compress the contents of TARGET_DIR into a zip file
zip -r "$BACKUP_FILE_NAME" "$TARGET_DIR"
