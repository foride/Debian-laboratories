#!/bin/bash

CATALOG="${1:-plecak}"

if [[ -d "${CATALOG}" ]]; then
	echo "Katalog istnieje"
else
	echo "Katalog: ${CATALOG} utworzony"
	mkdir -p "${CATALOG}"
fi

if [[ ! -f items ]]; then
	echo "Plik: 'items' nie zostal znaleziony!"
	exit 1
fi

THINGS=$(cat items)

COUNTER=0
FILE_COUNTER=0

for THING in ${THINGS}; do

	if [[ $((COUNTER % 2)) -eq 0 ]]; then

		touch "${CATALOG}/${THING}"
		echo "Plik regularny: ${THING}"
		FILE_COUNTER=$((FILE_COUNTER + 1))
	else

		mkdir -p "${CATALOG}/${THING}"
		echo "Katalog: ${THING}"
	fi
	COUNTER=$((COUNTER + 1))
done

echo "$(date +"%Y") utworzylem ${FILE_COUNTER} plikow."
