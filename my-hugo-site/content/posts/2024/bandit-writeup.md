---
title: "OverTheWire: Bandit Writeup"
date: 2024-12-23
draft: false
tags: ["Cybersecurity", "Ctf", "Overthewire", "Linux", "Writeup"]
---

Bandit is the best starting point for anyone new to wargames. It teaches you the Linux command line through increasingly tricky challenges. Here&rsquo;s my walkthrough.
bandit0#
This one is easy — the password is in the readme file.
cat readme

bandit1#
To read files with special characters as the name, prepend ./:
cat ./-

bandit2#
To read files with spaces, quote the filename:
cat &#39;spaces in this filename&#39;

bandit3#
Use ls -la to see hidden files and directories:
ls -la inhere/

bandit4#
The inhere directory has many files. Use grep with a regex to find the human-readable one:
cd inhere
grep &#39;[a-zA-Z0-9]&#39; ./*

bandit5#
Find a file that is human-readable, 1033 bytes, and not executable:
find . -type f -size 1033c 2>/dev/null | xargs cat

bandit6#
The file is owned by user bandit7, group bandit6, and is 33 bytes:
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat

bandit7#
The password is next to the word &ldquo;millionth&rdquo; in data.txt:
grep millionth data.txt

bandit8#
The password is the only line that occurs exactly once:
sort data.txt | uniq -u

bandit9#
The password is a human-readable string preceded by several = characters:
strings data.txt | grep &#34;==&#34;

bandit10#
The data is base64 encoded:
base64 -d data.txt

bandit11#
The data has been encrypted with ROT13:
cat data.txt | tr &#39;A-Za-z&#39; &#39;N-ZA-Mn-za-m&#39;

bandit12#
This is a hexdump of a file that has been repeatedly compressed. Save it to /tmp, reverse the hexdump, then repeatedly decompress:
mkdir /tmp/mydir && cd /tmp/mydir
xxd -r ~/data.txt > data
# then identify file type with &#39;file data&#39; and decompress accordingly
# repeat until you get ASCII text

bandit13#
The password is in /etc/bandit_pass/bandit14 and can only be read by bandit14. You have a private SSH key — use it:
ssh -i sshkey.private bandit14@localhost -p 2220

bandit14#
Submit the current level&rsquo;s password to port 30000:
echo <bandit14-password> | nc localhost 30000

bandit15#
Submit the password to port 30001 using SSL:
echo <bandit15-password> | openssl s_client -connect localhost:30001 -quiet

bandit16#
Scan for open ports in the 31000–32000 range, find which ones speak SSL, then submit the password to get an RSA private key for the next level:
nmap -p 31000-32000 localhost
# try each SSL port with openssl s_client

bandit17#
The password is the only line that differs between passwords.new and passwords.old:
diff passwords.old passwords.new
