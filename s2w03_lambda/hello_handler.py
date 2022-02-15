def hello_handler(event, context):
    # "print" statement (redirected to log)
    print('standard output to log')

    
    greeting = "Hello %s %s" % ( event['firstname'], event['surname'])
    
    # return value
    return {
        "message": greeting
        }
