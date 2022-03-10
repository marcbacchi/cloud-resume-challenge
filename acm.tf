# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider = aws.acm_provider
  domain_name = var.domain_name
  # subject_alternative_names = ["*.${var.domain_name}"]
  subject_alternative_names = ["www.${var.domain_name}"]
    
  # I had to comment out the subject_alternative_names value with 
  # the wildcard "*" it was causing an issue on AWS ACM trying to create another 
  # cert for the additional domains, and failing "CNAME already exists" 
  # With explicit config using the "www." in the working value, this succeeded.

  # validation_method = "EMAIL"

  # I didn't have email setup on my domain, used DNS:
  # when the script gets to the "validating cert" step and is waiting
  # Must go to domain registrar and enter the AWS NameServer values it 
  # assigns, in to the domain custom DNS fields
  # Once saved after a few seconds maybe a minute, the step will succeed and continue.

  validation_method = "DNS"

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert" {
  provider = aws.acm_provider
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}