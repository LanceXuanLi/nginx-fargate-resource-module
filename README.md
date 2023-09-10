# Terraform Module: AutoScaling Nginx Servers with AWS ALB, ECS Fargate, and WAF

This Terraform module sets up an autoScaling Nginx server on AWS using an Application Load Balancer (ALB) and ECS
Fargate. It also associates an AWS Web Application Firewall (WAF) with the ALB, enforcing rate limits and blocking OWASP
top 10 attacks.

## Features

- Deploys Nginx servers on AWS using ECS Fargate.
- Utilizes an Application Load Balancer for traffic distribution.
- Implements AWS Web Application Firewall for enhanced security.
    - Enforces a rate limit of 60 requests per minute per IP address.
    - Blocks OWASP top 10 attacks.
- Utilizes Capacity Providers for efficient Fargate resource allocation.
    - 1:1 ratio of Fargate to Fargate Spot, starting initially with one Fargate container.
- Implements auto-scaling for increased availability.

## Usage

```hcl
module "public_nginx_server" {
  source = "git::https://github.com/LanceXuanLi/nginx-fargate-resource-module.git"

  // Add necessary variables here, change them to your preference
  project-name      = "test"
  project-env       = "prod"
  alb-log-s3-prefix = "test"
  waf-description   = "test-waf"
}
```

## Requirements

- Terraform v0.12.0+
- AWS provider plugin v5.16.0+
- AWS CLI configured with necessary credentials

## Variables

- `project-name`        Name of project
- `project-env`         Environment of project
- `alb-log-s3-prefix`  Prefix of ALB log in s3
- `waf-description`    Description of waf
- `first-n-azs`        First n azs will be used

## Outputs

The module provides the following outputs:

- **VPC ID**:
    - Description: The ID of the Virtual Private Cloud (VPC) created by the module.
    - Value: `module.vpc.vpc-id`

- **ALB ARN**:
    - Description: The Amazon Resource Name (ARN) of the Application Load Balancer (ALB) created by the module.
    - Value: `module.alb.alb-arn`

- **WAF ID**:
    - Description: The ID of the AWS Web Application Firewall (WAF) created by the module.
    - Value: `module.waf.waf-id`

- **ECS Cluster Name**:
    - Description: The name of the ECS cluster created by the module.
    - Value: `module.ecs.ecs-cluster-name`

- **ECS Service Name**:
    - Description: The name of the ECS service created by the module.
    - Value: `module.ecs.ecs-service-name`

## Structure

![](Nginx%20Diagram.drawio.png)

## Authors

- Lance li <lance.nanxuanli@gmail.com>

## License

This project is licensed under the [MIT License](LICENSE.txt).

## Acknowledgments

- AWS documents
  - https://aws.amazon.com/de/blogs/compute/task-networking-in-aws-fargate/
  - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html
  - https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based-request-limiting.html
  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html
- AWS provider
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs  (v5.16.1)

## Support

For any questions or concerns,
please [open an issue](https://github.com/LanceXuanLi/nginx-fargate-resource-module/issues) or contact us
at [lance.nanxuanli@gmail.com](mailto:lance.nanxuanli@gmail.com).