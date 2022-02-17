import json

def display_event(event, context):

    event_as_string = json.dumps(event, indent=4)

    # "print" statement (redirected to log)
    print('received: %s' % event_as_string)
    
    # pull out subject & message
    subject = event['Records'][0]['Sns']['Subject']
    message = event['Records'][0]['Sns']['Message']
    
    # use message (& subject?) if needed
    print('message: %s' % message)
    
    # return value
    return event
