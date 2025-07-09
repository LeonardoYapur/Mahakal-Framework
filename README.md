<h1 align="center">🔱 MAHAKAL FRAMEWORK 🔱</h1>
<p align="center">
  <img src="https://img.shields.io/badge/MAHAKAL-Terminal%20Framework-red?style=for-the-badge&logo=gnubash" alt="Badge">
  <img src="https://img.shields.io/badge/Linux-Only-green?style=for-the-badge&logo=linux">
  <img src="https://img.shields.io/badge/Built%20With-Bash-blue?style=for-the-badge&logo=gnu">
</p>

---

<p align="center">
  <b>A powerful 🔐 cybersecurity terminal framework</b><br>
  <i>Built for Hackers, Red Teamers, and Cyber Warriors 💀</i><br><br>
  <b>🛠️ Created By:</b> <a href="https://github.com/Cyber-Mrinal">CYBER-MRINAL</a>
</p>

---

## ⚔️ Overview

> **MAHAKAL** is a modular, interactive, and professional-grade **Linux terminal framework** designed to unify reconnaissance, vulnerability scanning, cracking, system auditing, and anonymity into a single command-line interface.

🎯 Ideal for:
- 🧠 Ethical Hackers
- 🕵️ Red/Blue/Purple Teamers
- 🔬 Security Analysts
- 🧰 Penetration Testers

---

## ✨ Key Features

| Type              | Tools Integrated |
|-------------------|------------------|
| 🧠 AI Assistant    | Local AI CLI support (`cd ai`). You can install `ai` from the tool (HERE YOU CAN INSTALL AI USING `intdeb` OR `intarch` IN `MAHAKAL` SCRIPT) |
| 🌐 Recon Tools     | `nmap`, `whatweb`, `subfinder`, `dnsrecon`, `whois`, `shodan`, etc. |
| 💣 Web Scanners    | `wpscan`, `nikto`, `ffuf`, `gobuster` |
| 🔓 Cracking Tools  | `hydra`, `john`, `hashcat`, `medusa` |
| 🧪 Injection Tools | `sqlmap` |
| ⚡ Port Scanners   | `masscan`, `unicornscan` |
| 🛡️ System Hardening | `ufw`, `fail2ban`, `inxi` |
| 🕶️ Anonymity Setup | Optional install: `torctl`, `kali-anonsurf` |
| 📚 Command Logger | Logs saved to `/var/log/mahakal.log` |

---

## 🚀 Installation

```bash
git clone https://github.com/CYBER-MRINAL/Mahakal-Framework
cd Mahakal-Framework
chmod +x setup.sh
sudo ./setup.sh
````
🧩 During setup:

* 🧠 Auto-detects your Linux distro
* 📦 Installs all required tools
* 🔧 Offers `system-wide install` (via `/usr/local/bin`)
* 🕶️ Asks if you want to install:

  * `torctl` (for Arch-based)
  * `kali-anonsurf` (for Debian-based)

---
- If you getting shodan not found error then for debian based distro install `python3-shodan` and for arch based distro install `python-shodan`.
- One more thing before runt shodan commands you have to give it your api key. You can finde it on here -> [shodan](https://shodan.io) First signup if you have no account then go to account -> there you can see on Overview section -> `API KEY` just click on show and copy that. Then go to your terminal and type `shodan init <paste your api key>`. You fix your issue.
- If you getting `tgpt` command not found errot then just install from `mahakal` -> `cd ai` -> Then for debian `intdeb` and for arch or arch based distro `intarch`.

## 💻 Supported OS

| Distro          | Status          |
| --------------- | --------------- |
| Kali Linux      | ✅ Supported     |
| Ubuntu / Debian | ✅ Supported     |
| Linux Mint      | ✅ Supported     |
| Arch / Garuda / Athena os   | ✅ Supported     |
| Parrot OS       | ✅ Supported |

---

## 🧠 Using MAHAKAL

After install:

```bash
mahakal (If you install system wide)
  or
chmod +x mahakal.sh 
sudo ./mahakal.sh (For manual usecase)
```

You’ll be dropped into a futuristic hacker CLI. Use commands like:

```bash
cd nmap
ls
quick 192.168.1.1
cd ..
cd hashcat
ls
```

🟢 `mip` — Show public IP
🟢 `cd toolname` — Enter module
🟢 `ls` — See commands
🟢 `help` — Global guide
🔴 `exit` — Quit framework

---

## 📁 Modules Available

```shell
📁 ai         - Chat with AI module ( INSTALL AI USING `intdeb` OR `intarch` USING SCRIPT)
📁 nmap       - Network scanner
📁 css        - Check system status
📁 anony      - Anonymity controls
📁 curl       - Curl use for recon purpose
📁 whatweb    - Website tech fingerprinting
📁 wpscan     - WordPress vulnerability scanner
📁 wafw00f    - WAFW00F for web application firewall detection 
📁 subfinder  - Subdomain enumeration
📁 dnsrecon   - DNS recon
📁 dnsenum    - DNS enum
📁 httprobe   - HTTP probing tool
📁 mip        - Show your public IP address
📁 whois      - Perform a WHOIS lookup
📁 amass      - Amass for DNS enumeration
📁 hydra      - Login brute-forcer
📁 medusa     - Parallel password bruteforcer
📁 gobuster   - Directory brute-forcing
📁 hashcat    - Hash cracking
📁 john       - Password cracker
📁 nikto      - Web server scanner
📁 masscan    - High-speed port scanner
📁 ffuf       - Fuzzing URLs
📁 unic       - Unicornscan for network scanning
📁 enumli     - Linux enumeration
📁 sqlmap     - SQL Injection automation
📁 ufw        - Uncomplicated firewall management
📁 shodan     - Shodan for searching the internet
```

---

## 📦 Log & History

* 📁 Logs are saved to: `/var/log/mahakal.log`
* 📁 Command history: `/var/.mahakal_command_history`

---

## 🔐 Legal Disclaimer

> **MAHAKAL Framework** is intended for educational and lawful penetration testing use only.
> The user is fully responsible for any misuse. Unauthorized attacks are illegal.
> By using this tool, you agree to use it only on systems you own or are authorized to test.

---

## 📜 License

```text
MIT License — Free to use, modify, and distribute with credit.
```

---

## 🧠 Dev Notes

* Developed entirely in **Bash**
* Requires **root/sudo** for some operations
* Terminal color-coded and interactive interface

---

![image](https://github.com/user-attachments/assets/cff0b609-ef01-4244-948b-40d58e8ff199)


--- 
## ⚡ Connect with Me

| Platform    | Link                                                                         |
| ----------- | ---------------------------------------------------------------------------- |
| 🌐 Website  | [OMSWASTRA](https://cyber-mrinal.github.io/omswastra) |
| 💼 LinkedIn | [LINKEDIN](https://linkedin.com/in/CYBERMRINAL) |
| 🐙 GitHub   | [GITHUB](https://github.com/CYBER-MRINAL)                   |
|   Telegram  | [TELEGRAM-FOR-TOOL-ISSUE](https://github.com/cybermrinalgroup/3)  

---

## 🕉️ Jai Mahakal 🕉️

> “The destroyer of ignorance. The protector of truth.”
> This framework is built in the spirit of **Lord Shiva** — destroyer of evil, guardian of wisdom.

---

<p align="center">
  ⚡ Built with ❤️ by <b>CYBER-MRINAL</b> ⚡<br>
  <i>Indian Cybersecurity Engineer • Red Team • Blue Team • Sanatani</i><br>
  <i>[*] Can i get a star (⭐) & follow (🔔) for my work ?</i>
</p>
