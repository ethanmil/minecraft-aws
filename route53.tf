/*resource "aws_route53_zone" "themightymillers" {
  name = "${var.DOMAIN}"
}

resource "aws_route53_record" "server-record" {
  zone_id = "${aws_route53_zone.themightymillers.zone_id}"
  name = "server.${var.DOMAIN}"
  type = "A"
  ttl = "5"
}

output "ns-servers" {
  value = "${aws_route53_zone.themightymillers.name_servers}"
}

resource "aws_acm_certificate" "cert" {
  domain_name = "${var.DOMAIN}"
  validation_method = "DNS"
}
 
resource "aws_route53_record" "cert_validation_dns_record" {
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "CNAME"
  zone_id = "Z3N0PU2D61X0DL"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}
 
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"]
}*/