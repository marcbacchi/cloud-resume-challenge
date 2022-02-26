# cloud-resume-challenge

This project is my online resume, a static web page, serving my
resume html and css written from scratch by myself, since I wanted to keep it as simple as 
could be.

The complex work is setting up the infrastructure needed to serve the page, and have it 
use https: and be a secure site.  The cert process was a big learning step for me.

I use "aws-vault" to store and call my aws-cli and Terraform commands, so credentials 
are secure on local computer for now.

# Installation from scratch
If you're deploying this from absolutely nothing:
### terraform init
### terraform apply
You will get a loop in the script when its waiting for Certificate validation
Go you Namecheap (registrar), enter the Nameserver vlaues in your Custom DNS config, from the values now available in the AWS Route 53 details.
Then it should continue on after a minute or two as the DCV is confirmed. Domain ownership.


