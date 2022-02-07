Background
==========

In contrast to on-premises physical / virtual servers, EC2 instances are
often single-purpose and disposable. Many EC2 users do not “maintain” an
EC2 instance, but instead create / destroy them at will. This often
happens automatically as we’ll see when we look at autoscaling.

Often, the only time a machine has any sysadmin work done is when
setting it up. Rather than have to SSH in, EC2 provides a facility to
perform arbitrary commands after an instance’s *first* launch. (This is
one reason the option not to put a key pair on a machine exists!)

Scenario
========

We want to set up an EC2 instance. Without intervention, we want to:

1.  Update the software

2.  Install the apache web server, the elinks text mode browser and the
    git version control program.

3.  Configure the web server to start on boot

4.  Start the web server

5.  Clone the contents of a github repository into the web server’s
    document root folder

We will use the User Data feature to perform these actions without
logging in to the server at all.

User data
=========

When setting up an instance, we can pass in user data that is passed to
the `cloud-init` service on the EC2 instance. User data can take many
forms. The simplest form is a shell script executed when the EC2
instance is launched.

User data Script
----------------

A basic user data shell script looks like any other:

``` {.bash}
#!/bin/bash

# commands go here, for example:
yum -y update
```

It is **executed as root** *shortly after* the instance launches. Points
to note:

-   The user data is script only executes on the *first* boot of the
    EC2 instance. It **will not** execute on subsequent boots.

-   User data script is executed as root user. No need for `sudo`!

-   Use absolute paths or change directory to known location using `cd`.

-   Script executes once EC2 instance is up and running. May appear as
    if script hasn’t worked if you login and check too soon!

-   You must avoid any command asking for keyboard input. Otherwise
    script will become stuck.

    -   Most commands have a switch to prevent confirmation prompts and
        the like. For example on `yum` it’s the `-y` switch. Consult man
        pages for other commands, look for non-interactive or
        similar wording.

-   Try to code defensively, e.g. the `-p` switch to `mkdir`.

-   You can modify files like `/etc/fstab` using `echo` and the shell
    redirection operators (`>>`).

Cloud init
==========

The ability to provision servers automatically consists of two
components: `cloud-init` on the EC2 instance, coupled with the Instance
Meta Data Service (IMDS) provided by AWS.

Instance metadata service (IMDS)
--------------------------------

IMDS is a web service accessible within the EC2 instance at\
`http://169.254.169.254/latest/meta-data/`.

This is a so-called Link Local address for each instance, with the same
IP address for all EC2 instances. Most data is accessible as either
plain strings or JSON. JSON can be parsed easily in Bash using the `jq`
program.

EC2 component
-------------

Cloud init is a program that runs on the EC2 instance. After the first
boot, it reads the user data provided by IMDS.

If the user data is a shell script, it is run as root.

Cloud init also supports other formats to supply configuration
information including setup scripts as part of user data.

Provisioning instances using cloud-init
=======================================

Assume Powershell is in a folder where we have a userdata.sh script, we
can start a new instance the same way as we started our linux instances
except this time we now pass an additional argument with our user data.

``` {.powershell}
# setup script in userdata.sh in this folder
# assume variables $SubnetId, $ImageId, $SGId are set!
aws ec2 run-instances `
--subnet-id $SubnetId `
--image-id $ImageId `
--instance-type t2.micro `
--key-name LAB_KEY `
--security-group-ids $SGId `
--user-data file://userdata.sh 
```

Logging
=======

Cloud-init logs are stored in `/var/log`.

Lab task
========

Lab setup script: [cloudinit\_lab\_setup.ps1](cloudinit_lab_setup.ps1).

Today’s lab will create an EC2 instance that uses a user data script to
complete its setup:

1.  Run the setup script. Recommended: copy/paste all the IDs as
    PowerShell variables

2.  Use the AWS CLI to setup a t2.micro EC2 instance running Amazon
    Linux within the `LAB_1_SN` subnet protected by the `LAB_SG`
    security group with the SSH key `LAB_KEY`.

3.  Login over SSH to the instance. Issue the commands manually to
    perform the following actions AS ROOT:

    1.  Update all system software (without any prompts)

    2.  Install the following packages: httpd, elinks and git

    3.  Configure httpd to start automatically on boot

    4.  Start httpd

    5.  Clone the contents of the git repository
        <https://github.com/peadargrant/test_static_website> to the
        `/var/www/html` folder.

4.  Confirm that your web server is running by viewing the process
    listing. Use the elinks web browser to confirm that it is serving
    the static site. Browse to the public IP of your instance from your
    local PC and confirm that you see the web page.

5.  Note down the commands (or capture the shell history). Either copy &
    paste or SFTP the commands. Terminate the instance.

6.  Use the commands you typed previously to construct a userdata.sh
    script. This script will be run as root, so no need to use sudo.

7.  Create a new EC2 instance using the AWS CLI that will automatically
    run the userdata.sh script above.

8.  Login to the new EC2 instance and confirm that your userdata script
    has run. Look at the cloudinit output log in `/var/log`.


