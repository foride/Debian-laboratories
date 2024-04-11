#!/bin/bash

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-2remove}
TARGET_DIR=${3:-bakap}

if [[ ! -d "${TARGET_DIR}" ]]; then
	mkdir "${TARGET_DIR}"
fi

for THING in ${RM_LIST}; do
	FILEPATH="${SOURCE_DIR}/${THING}"
	if [[ -e "${THING}" ]]; then

		rm  -rf "${FILEPATH}"
	fi
done

# Sprawdź każdą linię w pliku RM_LIST
while IFS= read -r FILE_NAME; do
  # Pełna ścieżka do potencjalnego pliku do usunięcia
  FULL_PATH="${SOURCE_DIR}/${FILE_NAME}"
  
  # Sprawdź, czy plik istnieje w katalogu SOURCE_DIR
  if [ -f "$FULL_PATH" ]; then
    # Jeśli plik istnieje, usuń go
    rm "$FULL_PATH"
  else
    # Jeśli plik nie istnieje, wypisz informację
    if [[ -f "${FILE_NAME}" ]]; then
                mv "${FILE_NAME}" "${TARGET_DIR}"
        elif [[ -d "${FILE_NAME}" ]]; then
                cp -r "${FILE_NAME}" "${TARGET_DIR}"
    fi

  fi
done < "$RM_LIST"



for FILE in  "${SOURCE_DIR}"/*; do
	if [[ ! -e "${RM_LIST}" ]] && [[ -f "${FILE}" ]]; then
		mv "${FILE}" "${TARGET_DIR}"
	elif [[ -d "${FILE}" ]]; then
		cp -r "${FILE}" "${TARGET_DIR}"
	fi
done

REMAINING_FILES=$(find "${SOURCE_DIR}" -type f | wc -l)

if [[ "${REMAINING_FILES}" -ge 1 ]]; then
	echo "Jeszcze cos zostalo"
fi

if [[ "${REMAINING_FILES}" -gt 4 ]]; then
	echo "Zostalo wiecej niz 4 pliki"
elif [[ "${REMAINING_FILES}" -ge 2 ]]; then
	echo "Zostaly 2 lub 3 pliki"
else
	echo "Tu byl kononowicz"
fi 

CURRENT_DATE=$(date +%Y-%m-%d)

# Nazwa pliku backupu z aktualną datą
BACKUP_FILE_NAME="bakap_${CURRENT_DATE}.zip"

# Spakuj zawartość katalogu TARGET_DIR do pliku zip
zip -r "$BACKUP_FILE_NAME" "$TARGET_DIR"
