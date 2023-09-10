# --------------------- waf-acl ---------------------
resource "aws_wafv2_web_acl" "waf" {
  name        = var.waf-name
  description = var.waf-description
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rate-limiter"
    priority = 20

    action {
      block {}
    }
    statement {
      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based-request-limiting.html
      # AWS WAF checks the rate of requests every 30 seconds, and counts requests for the prior 5 minutes each time.
      # Because of this, it's possible for an aggregation instance to have requests coming in at too high a rate for up to 30 seconds before AWS WAF detects and rate limits the requests for the instance.
      # Similarly. the request rate can be below the limit for up to 30 seconds before AWS WAF detects the decrease and discontinues rate limiting for the instance.
      rate_based_statement {
        # 60 per minute = 300 per 5 minute, limit is
        limit         = 300
        aggregate_key_type  = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limiter-metric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    # This blocks appropriate OWASP top 10 attacks
    # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-crs
    name     = "managed-common-rule-set"
    priority = 10
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        # Do not set version to use static version.
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "managed-common-rule-set-metric-name"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.waf-name}-waf-metric"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.waf-name}-waf"
    Env  = var.waf-env
  }
}

# --------------------- waf-acl-association ---------------------


resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.alb-arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
