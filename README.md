terraform_application in s3,cloudfront,apigateway,lambda,dynamodb


                                   |-- get_method --> get_lambda----->|
    s3--->clodfront-->apigateway-->|                                  |----->dynamodb
                                   |-- post method--> insert_lambda-->|

Prerequisites:

   -Ensure that you have uploaded the JS and HTML files to an S3 bucket.
   -Configure the S3 bucket permissions to restrict public access.
   -Make sure the DynamoDB table name matches the one specified in your JS code.
   -Ensure that the DynamoDB table has a hash key that corresponds to the one specified in your JS code.

Objective:

   The objective is to use Terraform to create the necessary infrastructure components (CloudFront, API Gateway, Lambda, and DynamoDB table) that will enable access to dynamic content stored in an S3 bucket.
   Additionally, implementing a global replica for DynamoDB to ensure high availability and disaster recovery.

Deployment:
   -Required arguments can be given in .tfvars file based on our requirements.
   -backend.hcl file shall be configured to store the Terraform state file.

Terraform commands to deploy the code:

 -terraform init -backend-config=backend.hcl
 -terraform plan -var-file=terraform.tfvars
    (for other envs mention env/abc.tfvars)
 -terraform apply -var-file=terraform.tfvars --auto-approve
 -terraform destroy -var-file=terraform.tfvars

Validation:
   After deploying the infrastructure, the API Gateway URL will be copied to the JavaScript (JS) file and uploaded to the S3 bucket. By using the CloudFront distribution domain name, the dynamic content can be accessed from the browser.

In the browser, there will be functionality to save employee profiles. When a HTTP POST method is invoked, a Lambda function (insert_lambda) will be triggered. This Lambda function will add the data to the DynamoDB table.

Similarly, there will be a functionality to view employee profiles. When a HTTP GET method is invoked, another Lambda function (get_lambda) will be triggered. This Lambda function will collect all the information from the DynamoDB table.

To validate the disaster recovery configuration, you can modify the .tfvars file by setting the "dr" variable to "true". This will ensure that the data is added to the global replica, which is located in another region. This validates the ability to recover data in case of a disaster or regional outage.

By following these steps and configurations, the system will be set up to allow accessing dynamic content, saving employee profiles, retrieving employee profiles, and validating the disaster recovery configuration in the Terraform deployment.

