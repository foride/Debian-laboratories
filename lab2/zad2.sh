#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR=${1}
LINK_DIR=${2}

if [[ ! -d ${SOURCE_DIR} ]]; then
	echo "Błąd: Katalog '${SOURCE_DIR}' nie istnieje."
	exit 1
fi

if [[ ! -d ${LINK_DIR} ]]; then
	echo "Błąd: Katalog '${LINK_DIR}' nie istnieje."
	exit 2
fi

SOURCE_DIRECTORIES=$(find "${SOURCE_DIR}" -mindepth 1 -type d)
SOURCE_FILES=$(find "${SOURCE_DIR}" -type f)
SOURCE_LINKS=$(find "${SOURCE_DIR}" -type l)

while IFS= read -r directory; do
    REL_PATH="${directory#${SOURCE_DIR}/}"
    DEST_PATH="${LINK_DIR}/${REL_PATH}"
    echo "Katalog: ${directory}"
    ln -sfn "${directory}" "${DEST_PATH}"
done <<< "${SOURCE_DIRECTORIES}"

while IFS= read -r file; do
    REL_PATH="${file#${SOURCE_DIR}/}"
    DEST_PATH="${LINK_DIR}/${REL_PATH}"
    echo "Plik: ${file}"
    ln -sfn "${file}" "${DEST_PATH}"
done <<< "${SOURCE_FILES}"

while IFS= read -r symlink; do
    echo "Dowiazanie symboliczne: ${symlink}"
done <<< "${SOURCE_LINKS}"
