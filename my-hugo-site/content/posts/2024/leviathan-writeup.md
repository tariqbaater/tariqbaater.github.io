---
title: "OverTheWire: Leviathan Writeup"
date: 2024-12-23
draft: false
categories: ["Cybersecurity"]
tags: ["Cybersecurity", "Ctf", "Overthewire", "Linux", "Writeup"]
---

Leviathan#
The Leviathan wargame from OverTheWire tests basic Linux privilege escalation skills. Here&rsquo;s my walkthrough.
leviathan0#
Use grep to find the password.
leviathan1#
Read the binary and trace with ltrace and strings.
leviathan2#
If you ltrace the binary printfile you will see it&rsquo;s using the access() function — which is known for a TOCTOU (Time-of-check to time-of-use) vulnerability, mostly abused using symlinks.
Check how the binary works:
ltrace -f ./printfile filename

Since access() has a delay before reading files, we can exploit that window. The idea is to modify the file between the moment it gets checked for permissions and when it gets opened. This is done by creating a symlink targeting the file we want to access.
Run on two separate screens:
Screen 1 — chain commands to symlink and watch it run every 0.1 seconds:
watch -n 0.1 touch /tmp/tmpfolder/lev3; ln -sf /etc/leviathan_pass/lev3 /tmp/tmpfolder/lev3; rm /tmp/tmpfolder/lev3

Screen 2 — loop to print the file 50 times, hoping to catch the race condition:
for i in {1..50}; do ./printfile /tmp/sbin/lev3; done

After a few loops the password is revealed.
leviathan3#
Read the binary level3 and trace with ltrace and strings. There&rsquo;s a string comparison — same technique as leviathan1.
leviathan4#
There&rsquo;s a binary labelled bin in a hidden trash directory. When executed it prints binary bytes. Use this script to decode:
#!/bin/bash
for binary in &#34;$@&#34;; do
  printf &#34;\\$(printf &#39;%03o&#39; &#34;$((2#$binary))&#34;)&#34;
done

leviathan5#
Use ltrace to trace the binary and follow symlinks to read restricted files.
leviathan6#
Brute force the 4-digit PIN:
for i in $(seq -w 0000 9999); do ./leviathan6 $i 2>/dev/null && echo &#34;Found: $i&#34; && break; done

leviathan7#
Congratulations — you&rsquo;ve completed Leviathan!
