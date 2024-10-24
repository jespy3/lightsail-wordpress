data "aws_route53_zone" "primary" {
  name = local.domain_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.${local.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_lightsail_instance.wordpress_and_db.public_ip_address]
}

resource "aws_route53_record" "no_www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${local.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_lightsail_instance.wordpress_and_db.public_ip_address]
}

