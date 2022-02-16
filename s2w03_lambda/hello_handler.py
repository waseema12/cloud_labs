def hello_handler(event, context):
    
    greeting = "Hello %s %s" % ( event['firstname'], event['surname'])

    # "print" statement (redirected to log)
    print(greeting)
    
    # return value
    return {
        "message": greeting
        }
