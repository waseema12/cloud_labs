1. Setup script
	- creates VPC, etc components
	- creates a queue
	- puts queue URL into qprocessor.service (from qprocessor_template.service)
	- create S3 bucket
	- uploads file(s)
	- puts bucket name into user_data.sh (from user_data_template.sh)
	- runs instance
	- captures info about instance
	
2. user data script
	- sets up aws config
	- installs required python modules
	- copies qprocessor.py from s3
	- copies qprocessor.service from s3 directly to /etc/systemd/system
	- enables service
	- starts the service
	
