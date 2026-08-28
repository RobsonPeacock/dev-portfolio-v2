data "cloudflare_zone" "dev_portfolio_zone" {
  filter = {
    name = "robsonpeacock.dev"
  }
}

resource "cloudflare_dns_record" "dev_portfolio_apex_record" {
  zone_id = data.cloudflare_zone.dev_portfolio_zone.id
  name    = "@"
  content = aws_cloudfront_distribution.react_frontend_distribution.domain_name
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_dns_record" "dev_portfolio_www_record" {
  zone_id = data.cloudflare_zone.dev_portfolio_zone.id
  name    = "www"
  content = data.cloudflare_zone.dev_portfolio_zone.filter.name
  type    = "CNAME"
  proxied = false
  ttl     = 300
}

resource "cloudflare_email_routing_dns" "dev_portfolio_email_dns" {
  zone_id = data.cloudflare_zone.dev_portfolio_zone.id
}

resource "cloudflare_email_routing_address" "dev_portfolio_email_address" {
  account_id  = var.cloudflare_account_id
  email   = var.destination_email
}

resource "cloudflare_email_routing_rule" "dev_portfolio_email_rule" {
  zone_id = data.cloudflare_zone.dev_portfolio_zone.id
  name = "Forward contact address"
  enabled = true

  matchers = [
    {
      type = "literal"
      field = "to"
      value = var.custom_email
    }
  ]

  actions = [
    {
      type = "forward"
      value = [var.destination_email]
    }
  ]
}

resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.react_frontend_certificate.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
    if dvo.domain_name == data.cloudflare_zone.dev_portfolio_zone.filter.name
  }

  zone_id = data.cloudflare_zone.dev_portfolio_zone.id
  name = trimsuffix(each.value.name, ".")
  type = each.value.type
  content = trimsuffix(each.value.record, ".")
  proxied = false
  ttl = 60
}