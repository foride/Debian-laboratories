#!/bin/bash -eu

if [ $# -eq 0 ]; then
    echo "Błąd: Proszę podać ścieżkę do katalogu jako parametr."
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Błąd: Katalog '$1' nie istnieje."
    exit 2
fi

bak_files=$(find "$1" -type f -name "*.bak")
if [ -z "$bak_files" ]; then
    echo "Błąd: Nie znaleziono plików .bak w katalogu '$1'."
    exit 3
fi
chmod g-w $bak_files

bak_dirs=$(find "$1" -type d -name "*.bak")
if [ -z "$bak_dirs" ]; then
    echo "Błąd: Nie znaleziono katalogów .bak w katalogu '$1'."
    exit 4
fi
chmod 415 $bak_dirs

tmp_dirs=$(find "$1" -type d -name "*.tmp")
if [ -z "$tmp_dirs" ]; then
    echo "Błąd: Nie znaleziono katalogów .tmp w katalogu '$1'."
    exit 5
fi
chmod 755 $tmp_dirs

txt_files=$(find "$1" -type f -name "*.txt")
if [ -z "$txt_files" ]; then
    echo "Błąd: Nie znaleziono plików .txt w katalogu '$1'."
    exit 6
fi
chmod 241 $txt_files

