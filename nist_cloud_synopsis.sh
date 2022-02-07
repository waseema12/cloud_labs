
URL="https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-146.pdf"
FILENAME="nist_cloud_synopsis.pdf"

if [ -f $FILENAME ]
then
    echo exists
else
    echo downloading
    curl -o "$FILENAME" "$URL"
fi

open "$FILENAME"



