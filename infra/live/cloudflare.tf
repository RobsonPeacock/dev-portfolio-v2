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