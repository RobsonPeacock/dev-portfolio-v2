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