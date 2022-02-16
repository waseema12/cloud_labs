import json

def display_event(event, context):

    event_as_string = json.dumps(event, indent=4)
    
    # add a comment
    event['comment'] = 'altered by lambda function'

    # "print" statement (redirected to log)
    print('received: %s' % event_as_string)
    
    message = event['Records'][0]['Sns']['Message']
    print('message: %s' % message)
    
    # return value
    return event
