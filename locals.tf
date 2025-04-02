locals {
  environments = [
    {
      name                        = "dev"
      host_name                   = "agwy-vm-dev.razumovsky.me"
      backend_pool_name           = "backend-pool-dev"
      https_listener_name         = "https-listener-dev"
      http_listener_name          = "http-listener-dev"
      https_routing_rule_name     = "https-rule-dev"
      http_routing_rule_name      = "http-rule-dev"
      redirect_configuration_name = "http-https-redirect-dev"
      priority_https              = 10
      priority_http               = 30
    },
    {
      name                        = "qa"
      host_name                   = "agwy-vm-qa.razumovsky.me"
      backend_pool_name           = "backend-pool-qa"
      https_listener_name         = "https-listener-qa"
      http_listener_name          = "http-listener-qa"
      https_routing_rule_name     = "https-rule-qa"
      http_routing_rule_name      = "http-rule-qa"
      redirect_configuration_name = "http-https-redirect-qa"
      priority_https              = 20
      priority_http               = 40
    }
  ]

  https_port_name                = "front-port-443"
  http_port_name                 = "front-port-80"
  frontend_ip_configuration_name = "fipc-config-${var.prefix}"
  gateway_ip_configuration_name  = "gwipc-config-${var.prefix}"
  http_settings_name             = "backend-http-settings-${var.prefix}"
  ssl_certificate_name           = "razumovsky.me.pfx"

  frontend_ports = [
    {
      name = local.http_port_name
      port = 80
    },
    {
      name = local.https_port_name
      port = 443
    }
  ]
}
