#!/bin/bash
read -p "Enter version (e.g., 1.5): " VERSION
KEY_ID="704CAC6E"
PASS="your_passphrase_here"

# 1. Update Manifest
sed -i "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" manifest.json

# 2. Build & Clean (The Single-Deb Rule)
termux-create-package manifest.json
rm -f termux/*.deb
mv system-tools_${VERSION}_aarch64.deb termux/

# 3. Indexing
dpkg-scanpackages termux /dev/null > termux/Packages
gzip -fk termux/Packages

# 4. Create Release File
cat << EOR > termux/Release
Origin: jordan15citizen
Label: jordan15citizen
Suite: termux
Codename: termux
Architectures: aarch64
Description: Signed System Tools
Date: $(date -R)
EOR

# Add Checksums to Release
echo "MD5Sum:" >> termux/Release
printf " $(md5sum termux/Packages | cut -d' ' -f1) $(stat -c%s termux/Packages) Packages\n" >> termux/Release
printf " $(md5sum termux/Packages.gz | cut -d' ' -f1) $(stat -c%s termux/Packages.gz) Packages.gz\n" >> termux/Release
echo "SHA256:" >> termux/Release
printf " $(sha256sum termux/Packages | cut -d' ' -f1) $(stat -c%s termux/Packages) Packages\n" >> termux/Release
printf " $(sha256sum termux/Packages.gz | cut -d' ' -f1) $(stat -c%s termux/Packages.gz) Packages.gz\n" >> termux/Release

# 5. SIGNING (The Official Part)
gpg --batch --yes --clearsign --pinentry-mode loopback --passphrase "$PASS" --default-key $KEY_ID -o termux/InRelease termux/Release
gpg --batch --yes --detach-sign --armor --pinentry-mode loopback --passphrase "$PASS" --default-key $KEY_ID -o termux/Release.gpg termux/Release

# 6. Push to GitHub
git add .
git commit -m "Release v$VERSION (Signed)"
git push origin main
echo "v$VERSION is live and signed!"
