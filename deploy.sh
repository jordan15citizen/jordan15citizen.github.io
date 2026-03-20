#!/bin/bash
# 1. Ask for the new version number
read -p "Enter version (e.g., 1.2): " VERSION

# 2. Update manifest.json with the new version
sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" manifest.json

# 3. Build the new package
termux-create-package manifest.json

# 4. CLEAN: Remove ALL old .debs from the termux folder
rm -f termux/*.deb

# 5. Move the new one in
mv system-tools_${VERSION}_aarch64.deb termux/

# 6. Re-index (The 1.5 kB magic)
dpkg-scanpackages termux /dev/null > termux/Packages
gzip -fk termux/Packages

# 7. Git Push
git add .
git commit -m "Release v$VERSION"
git push origin main

echo "Done! Version $VERSION is live."
