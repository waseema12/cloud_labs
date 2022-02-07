---
title: AWS account setup
---

Many of the labs in this course will use Amazon Web Services, or AWS.
(Other cloud providers too - IBM, Google, Azure, others - this is not an
endorsement of Amazon. Most of the ideas translate to the others.) To do
the labs in this course, you will need an AWS account.

Almost all AWS services are chargeable. Many services have a
time-limited free tier. AWS Academy has a number of resources including
free credits so that labs exceeding the free tier don’t incur charges.

AWS account setup {#sec:aws-account-setup}
=================

You will get a sign-up email for AWS Academy Learner Labs. Go ahead and
create the account.

AWS account usage
=================

Login to your account at:\
<https://awsacademy.instructure.com/courses/8294/modules/items/794040>

AWS Console access
------------------

Click the AWS link on the left to be taken to the AWS console.

Cloud Shell
-----------

You can access the AWS CLI running on Bash on Linux directly from the
AWS console. There are a few extra tools like `git` installed on this
environment.

Setup AWS command-line interface
================================

The AWS Command Line Interface is a client program that runs on your
local PC to allow you to manage AWS resources from the command-line
(PowerShell, Bash). We will use the command-line extensively in this
module.

PowerShell execution policy
---------------------------

PowerShell by default will not allow scripts to run that were downloaded
from online. The following command will change this behaviour:

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

AWS CLI installation
--------------------

If you’re on a lab computer OR if you already have the AWS CLI
installed, then skip ahead to .

Install the command-line tools from <https://aws.amazon.com/cli/>

Config file setup {#sec:config-file-setup}
-----------------

There is a script file `setup_config_file.ps1` that will setup your
configuration file for you. Run it once.

Access key setup {#sec:access-key-setup}
----------------

**Needs to be done EVERY time you log in on a student account!**

Log in to AWS academy. Go to
<https://awsacademy.instructure.com/courses/8294/modules/items/794040>.

Hit the *AWS Details* button. Look for *Cloud Access* and *AWS CLI* on
the right. Click *Show*. Copy this.

### PowerShell

You can paste the above using:

    Get-Clipboard | Out-File ~/.aws/credentials

Alternatively you can use the script:

    .\paste_credentials.ps1

### Manual alternative

Paste the contents into a file named EXACTLY

    C:\Users\yourusername\.aws\credentials

(no `.txt` etc at the end).

Check CLI configured
--------------------

To check that the AWS CLI is correctly configured, you can try running
the command:

    aws ec2 describe-instances

If it shows something similar to:

    {
        "Reservations": []
    }

then the AWS CLI is working OK.

Mac, Linux, UNIX users
======================

*Windows users can ignore this section.*

Mac, Linux, Unix users will have no problems installing the AWS CLI, and
the commands work identically to those on Windows.

The difference between Mac/Linux and Windows centres on the use of
Bash/zsh by Mac/Linux/UNIX vs PowerShell on Windows. The AWS CLI is
perfectly scriptable using Bash, particularly in conjunction with `jq`
to parse JSON. However, some of the scripts you will be provided with in
this module will be PowerShell only due to time constraints.

The good news is that PowerShell Core 7 can be installed easily on a Mac
with no issues. You *do not* need a Windows VM on your Mac to use any of
the PowerShell or AWS commands in *this* course. Please go to the
[PowerShell page on GitHub](https://github.com/PowerShell/PowerShell)
for instructions.

When you have PowerShell installed, open the Terminal app and type
`pwsh` and you’ll be at a PowerShell prompt. Repeat the
`aws ec2 describe-instances` command to confirm that the `aws` command
is available in PowerShell.

Check script
============

Run the `lab_checks.ps1` powershell script to confirm that your
environment is set up correctly.
