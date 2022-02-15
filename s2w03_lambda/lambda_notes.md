---
title: 'Serverless functions: lambda'
---

Recommended reading {#recommended-reading .unnumbered}
===================

1.  [AWS lambda developer
    guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

Serverless compute
==================

Serverless function are the basic PaaS compute component. This is
sometimes referred to as Function-as-a-Service, although this
terminology can mean different things to different people. The basic
FaaS offering in AWS is called Lambda.

Key components
--------------

From the [AWS lambda
concepts](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-concepts.html):

Function

:   is an AWS resource you can *invoke* to run your own code on
    AWS infrastructure.

    -   Lambda runs your custom code *without* requiring EC2 instances
        or their accompanying VPC infrastructure.

Executable

:   consists of code within a lambda-provided runtime.

    Code

    :   is provided by you, either as source code, bytecode or
        compiled code.

    Runtime

    :   is provided by AWS. You need to pick the correct runtime for the
        code you wish to run.

Event

:   invokes the lambda function. This might be an explicit `invoke` at
    the CLI or console, or an event triggered from other AWS services
    (S3, SNS, API Gateway) including within Lambda itself (SQS polling).

Use Cases
---------

[AWS list a number of use cases in the developer
guide](https://docs.aws.amazon.com/lambda/latest/dg/applications-usecases.html).

Code
====

Runtime
-------

The Runtime refers to the support AWS Lambda offers for different
languages. You can in theory run code in any language that AWS EC2
supports on Lambda. Supports offered for different languages varies:

-   Python and JavaScript are best supported. You can write / edit
    functions in the AWS Console. Most examples online involve
    these languages.

-   A number of other languages are fully supported, but must be
    authored / edited locally and uploaded in a *deployment package*.
    These include: Java, .net (incl. C\# and PowerShell).

-   Code that can run on EC2 using Amazon Linux can be run on Lambda by
    creating a *custom runtime*. This is an involved process but very
    useful for porting legacy code to Lambda.

Deployment package creation
---------------------------

Code is bundled into a ZIP file, named a *deployment package*. The
precise layout will depend on the chosen runtime.

-   Interpreted languages (like Python, JS) will need the source files.

-   Bytecode-compiled languages (like Java) will consist of the
    bytecode-compiled class files.

The relevant files can be ZIPped using the cmdlet.

Execution role
==============

Execution roles are assumed by a lambda function, and grant the function
permissions to use other AWS resources in your account.

Each execution role has a name (e.g. `helloworld-ex`) from which we can
derive its ARN:

``` {.powershell}
$ExecutionRoleName="helloworld-ex"
$ExecutionRoleArn="arn:aws:iam::123456789012:role/helloworld-ex"
Write-Host $ExecutionRoleArn
```

Trust policy {#sec:trust-policy}
------------

The trust policy specifies what AWS component(s) can assume the role.

Attached policies
-----------------

Execution roles can then have policies attached using `iam`. Rather than
write these from scratch, we will attached AWS Managed Policies. The
simplest policy allows a lambda function to write to CloudWatch Logs:

``` {.powershell}
```

Additional policies can be attached (or created and attached) if the
lambda function needs access to other AWS services.

Hello World example
===================

Our simple `Hello World` will just output a message to CloudWatch logs.
It will ignore the input.

The program is a single function, named `hello_handler` in a file named
`hello_handler.py`. It will run as the execution role `hello-ex`.

Code
----

We have a python file `hello_handler.py` with the following simple
program:

.

Deployment package creation
---------------------------

To package the code into a ZIP we can:

``` {.powershell}
Compress-Archive -Path hello_handler.py -DestinationPath hello_code.zip

# issues on Mac/Linux in PowerShell due to file permissions, use instead (in Bash):
zip hello_code.zip hello_handler.py
```

Execution role creation
-----------------------

Our simple trust policy allows Lambda to assume the role (and will work
for most functions), defined in `trust_policy.json`:

Then we can create the execution role itself:

``` {.powershell}
# create the role 
aws iam create-role `
--role-name hello-ex `
--assume-role-policy-document file://trust_policy.json

# attach AWSLambdaBasicExecutionRole (for basic I/O needed by Lambda function)
aws iam attach-role-policy `
--role-name helloworld-ex `
--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

Function creation
-----------------

The handler parameter specifies the entry point that handles the event.
Its format varies depending on the runtime (language) used. For python
it normally is:

    [file (without extension)].[function name]

``` {.powershell}
aws lambda create-function `
--function-name hello `
--zip-file fileb://hello_code.zip `
--handler hello_handler.hello_handler `
--runtime python3.8 `
--role arn:aws:iam::123456789012:role/hello-ex 
```

Invoking the function
---------------------

We invoke (or run) the function:

``` {.powershell}
# invoke the function
aws lambda invoke `
--function-name hello `
out.txt

# read output produced
Get-Content hello_out.txt 
```

Updating code
-------------

If we want to update the function’s code, we can modify the source files
and then:

``` {.powershell}
# new ZIP file:
Compress-Archive -Force -Path hello_handler.py -DestinationPath hello_code.zip

# update the code on Lambda
aws lambda update-function-code `
--function-name hello `
~--zip-file fileb://hello_code.zip 
```

Deletion
--------

``` {.powershell}
aws lambda delete-function --function-name hello
```

Input handling
==============

Input is passed in/out of lambda functions using JSON-formatted text.
Python has a built-in dictionary time which the incoming JSON is
transparently converted to. Imagine we modified our hello function to
be:

We expect a firstname and surname input. These are provided as JSON, so
here we make a file for PowerShell to send the lambda function:

Then invoke, this time with the payload given:

``` {.powershell}
aws lambda invoke --function-name hello `
--payload fileb://payload.json hello_out.txt
```
