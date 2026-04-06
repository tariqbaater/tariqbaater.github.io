---
title: "Mr Robot CTF Writeup"
date: 2024-11-30
draft: false
tags: ["Thm", "Cybersecurity", "Ctf", "Writeup"]
---

This is the writeup for the Mr Robot CTF challenge on TryHackMe.
Solution#
First we start by enumerating the ports:
nmap -p- -Pn -T4 <IP> | tee ports.txt

Then we run the nmap script to find more information on the ports discovered:
nmap -sC -sV -p <PORT> -T4 <IP> | tee ports.txt

It is good practice to run a gobuster scan to find directories while busy enumerating the box further:
gobuster dir -u <IP> -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt

After the gobuster scan we get the following directories:

/robots.txt
/key-1-of-3.txt
/wp-login.php
There is some interesting content in the /robots.txt file.
The box runs a WordPress site. Using the discovered credentials and standard WordPress enumeration techniques, we can escalate to a reverse shell and find all three keys.
Key takeaway: Always check robots.txt — sites often inadvertently expose sensitive paths there.
