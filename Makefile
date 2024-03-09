all:
	stow --verbose --target=$$HOME --restow --no-folding */
delete:
	stow --verbose --target=$$HOME --delete --no-folding */
