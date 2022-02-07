---
title: SSH lab
---

Basic connection
================

You will be given details of server(s) by the lecturer, to include
name/IP and username. Make an SSH connection to each server using the
`ssh` command. Note down what operating system each server appears to be
running.

Basic connection using PuTTY
----------------------------

Use the PuTTY application to connect to the server instead of the SSH
command. Take time to modify the fonts/colours to make the text more
readable. Save the configuration for next time.

Re-connect using your saved configuration.

Key setup
=========

Following the notes, use `ssh-keygen` to set up a public/private key
pair.

Use `check_key_exists.ps1` to confirm that your keys are in the correct
place.

Submit key
----------

Submit your PUBLIC key as shown by the lecturer.

Key-based connection
====================

Use the key to login as before. Note the lack of a password prompt.
