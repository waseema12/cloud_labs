# DynamoDB demo commands
# Peadar Grant

$TableName='demotable'

# create table (via GUI) 
# identify primary key (via GUI)
# insert basic table contents (via GUI)

# get table contents
aws dynamodb scan --table-name $TableName

# delete table
aws dynamodb delete-table --table-name $TableName

