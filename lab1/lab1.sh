#!/bin/bash

CATALOG="${1:-plecak}"

if [[ -d "${CATALOG}" ]]; then
	echo "Catalog exists"
else
	echo "Catalog: ${CATALOG} created"
	mkdir -p "${HOME}/bash/${CATALOG}"
fi

if [[ ! -f items ]]; then
	echo "File: 'items' not found!"
	exit 1
fi

THINGS=$(cat items)

COUNTER=0

for THING in ${THINGS}; do
	echo "Current item: ${THING}"
	if [[ $((COUNTER % 2)) -eq 0 ]]; then

		touch "${CATALOG}/${THING}"
		echo "Tworze plik regularny: ${THING}"
	else

		mkdir -p "${CATALOG}/${THING}"
		echo "Tworze katalog: ${THING}"
	fi
	COUNTER=$((COUNTER + 1))
done

echo "$(date +"%Y") utworzylem ${COUNTER} plikow/katalogow."
