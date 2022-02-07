import com.amazonaws.regions.Regions;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClient;
import com.amazonaws.services.sqs.model.DeleteMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import java.util.List;

public class Consumer {

    public static void main(String args[]) {
        
        if ( args.length <1 ) {
            System.err.println("usage: must supply Queue URL as first argument");
            System.exit(1);
        }
        
        // takes the Queue URL from the arguments list
        String QUrl = args[0];
        
        // instantiate the SQS client
        AmazonSQS sqs = AmazonSQSClient.builder().withRegion(Regions.DEFAULT_REGION).build();
        
        // setup the receive message request (not send it yet!)
        ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(QUrl)
                .withWaitTimeSeconds(1)
                .withMaxNumberOfMessages(1);

        while(true) {
            
            // receive (using request)
            List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();
            
            // change to 20 second polling time (otherwise no messages won't print first time)
            receiveMessageRequest.setWaitTimeSeconds(20);
            
            // print to confirm no messages
            if ( messages.isEmpty() ) {
                System.out.println("no messages");
            }
            
            // using the "new" functional form to loop over all messages
            messages.forEach((message) -> {
                System.out.println("received: " + message.getBody());
                
                // delete (by making request and then sending it)
                sqs.deleteMessage(
                        new DeleteMessageRequest()
                                .withQueueUrl(QUrl)
                                .withReceiptHandle(message.getReceiptHandle()))
                        ;
            });
        }
    }
}
