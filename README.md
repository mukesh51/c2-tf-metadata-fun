This Terraform project creates and EC2 instance, associates a security group with specific ports and then installs Nginx server on it. It also retrieves instance metadata at instance start-up creating a JSON file and then copies that JSON file at nginx doc root folder, so that it is accessible via browser.

How to run this Project.

1. Clone this project. Ensure you've Terraform 0.12 installed.
2. Move to that specific folder and then run terraform init to initialize the repository.
3. Create a public/private key by running the command ssh-keygen -f mykey (use all the default values).
4. The above public key is uploaded to EC2 instance and copies the metadata.sh script to ec2 instance. This script is run using the provisioner "remote-exec".
5. By default terraform provides lots of metadata attributes using terraform variables, which are shown on screen, but an alternaitve way is to run the metadata.sh script, which also retrieves metadata instance and serves in this case via a web-page.
6. Run terraform plan followed by terraform apply to execute the terraform script.
7. Once done, use EC2 instances public ip address followed by metadata.json ( http://public_ip_address/metadata.json ) to see the metadata of EC2 instance.
8. Also the terraform displays all the attributes on the screen, which gets most of the information needed in day to day scenarios.

### Browser Screenshot of Instance Metadata

![Browser Screenshot](https://github.com/mukesh51/c2-tf-metadata-fun/blob/master/images/Browser-screenshot.png)

### Output of Terraform Apply

![Terraform Apply Output](https://github.com/mukesh51/c2-tf-metadata-fun/blob/master/images/terraform-apply-output.png)

### Output of Terraform Apply showing IP Address and Security Groups

![Terraform Apply Output-2](https://github.com/mukesh51/c2-tf-metadata-fun/blob/master/images/terraform-apply-output-2.png)

### Inbound ports as set by Terraform configuration

![Inbound Ports](https://github.com/mukesh51/c2-tf-metadata-fun/blob/master/images/inbound-ports.png)

### Outbound ports as set by Terraform configuration

![Outbound Ports](https://github.com/mukesh51/c2-tf-metadata-fun/blob/master/images/outbound-ports.png)
