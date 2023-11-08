#!/bin/bash

# Context: CodeEditorLand/Application

Directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

readarray -t Repository < "$Directory"/../Cache/Repository/CodeEditorLand.md

for Repository in "${Repository[@]}"; do
	Folder="${Repository/'CodeEditorLand/'/}"

	Rename=""

	Rename=$(tr '[:lower:]' '[:upper:]' <<< "${Folder:0:1}")

	for ((i = 1; i < ${#Folder}; i++)); do
		if [ "${Folder:i:1}" = "-" ]; then
			Next="${Folder:i+1:1}"
			if [[ "$Next" =~ [a-z] ]]; then
				Upper=$(tr '[:lower:]' '[:upper:]' <<< "$Next")
				Rename="${Rename}${Upper}"
				((i++))
			else
				Rename="${Rename}-"
			fi
		else
			Rename="${Rename}${Folder:i:1}"
		fi
	done

	Rename=$(echo "$Rename" | sed -E "s/vscode/Land/gI")

	cd "$Folder" || exit

	gh repo set-default "$(git remote get-url origin)"
	gh repo rename "$Rename" --yes

	cd - || exit
done
