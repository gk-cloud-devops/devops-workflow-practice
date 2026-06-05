terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# 1. Cloudflare Provider Access Authentication Setup
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API Token with Zone WAF and Zone Edit Permissions"
}

# 2. Dynamic Variable Loop for Multiple Domains
variable "my_domains" {
  type    = map(string)
  default = {
    "domain_1" = "gokulakannan.me"
  }
}

# 3. Fetching Zone IDs dynamically from Cloudflare
data "cloudflare_zones" "active_zones" {
  for_each = var.my_domains
  filter {
    name = each.value
  }
}

# 4. Creating the US Geo-Blocking Custom Rules
resource "cloudflare_filter" "block_us" {
  for_each    = var.my_domains
  zone_id     = data.cloudflare_zones.active_zones[each.key].zones[0].id
  description = "DevOps Lab Rule: Filter to isolate incoming US traffic"
  expression  = "(ip.src.country eq \"US\")"
}

resource "cloudflare_firewall_rule" "drop_us_traffic" {
  for_each    = var.my_domains
  zone_id     = data.cloudflare_zones.active_zones[each.key].zones[0].id
  description = "DevOps Lab Rule: Block traffic coming from United States"
  filter_id   = cloudflare_filter.block_us[each.key].id
  action      = "block"
}
