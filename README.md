## System-Tools
**System-Tools** is a **utility** for anyone to check certain info or **flash images phone-to-phone.**
It is a **debian package** for **Termux** with **automation scripts**, so it is easy to install.
## Install
Run this **commnand** to **install system-tools:**
```bash
curl -sL https://jordan15citizen.github.io/src/install | bash
```
* This will **install system-tools**
* It will add the **gpg key**
* This makes **system-tools** easy to install
## Updates
A **tag** with a **release debian package** means it is **stable**.
You can **install** that **debian package** with this **command**; however, the **package** must be in the **currect directory:**
```bash
pkg install ./*.deb
```
This isn't the **latest;** however as when i **push an update**, **APT fetches** it from **termux/**.This means **APT** uses more **unstable packages** that i **pushed** without **bug checking**.