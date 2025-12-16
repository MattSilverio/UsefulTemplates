#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="."
OLD_PATH="original name of your remote repo"
NEW_PATH="new name of your remote repo"
echo "Scanning for Git repositories under: $(pwd)"
echo "Replacing:"
echo " $OLD_PATH"
echo "with:"
echo " $NEW_PATH"
echo
found_configs=0
updated_configs=0
s# Find all .git/config files under the current directory
while IFS= read -r -d '' config_file; do
 found_configs=$((found_configs + 1))
 if grep -q "$OLD_PATH" "$config_file"; then
 echo "Updating: $config_file"
 # Create a temporary file for safe replacement (works on GNU and
macOS)
 tmp_file="${config_file}.tmp"
 sed "s#${OLD_PATH}#${NEW_PATH}#g" "$config_file" > "$tmp_file"
 mv "$tmp_file" "$config_file"
 updated_configs=$((updated_configs + 1))
 else
 echo "Skipping (no matching URL): $config_file"
 fi
done < <(find "$ROOT_DIR" -type f -path "*/.git/config" -print0)
echo
echo "Scan complete."
echo " Git configs found: $found_configs"
echo " Git configs updated: $updated_configs"
if [ "$updated_configs" -gt 0 ]; then
echo
 echo "You can verify in a repo with e.g.:"
 echo " cd <some-repo>"
 echo " git remote -v"
fi
