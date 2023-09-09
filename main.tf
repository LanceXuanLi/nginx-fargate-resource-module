provider "aws" {
  version = "~> 5.16"
  region  = var.project-region
}

locals {
  waf-description = var.waf-description == ""? "${var.project-name}-${var.project-env}-war" : var.waf-description
}


module "vpc" {
  source      = "./modules/vpc"
  vpc-env     = var.project-env
  vpc-name    = var.project-name
  # https://repost.aws/questions/QU6ndN_tPYR9K9NoXGA2chBw/2-azs-vs-3-or-more-azs
  # 3 AZs minimum; that way if the worst happens and there's an AZ outage, you still have redundancy.
  first_n_azs = 3
}

module "s3" {
  source    = "./modules/s3"
  s3-bucket = var.project-name
  s3-env    = var.project-env
}

module "alb" {
  source            = "./modules/alb"
  alb-env           = var.project-env
  alb-name          = var.project-name
  alb-sg-id         = module.vpc.alb-sg
  alb-subnets       = module.vpc.public-subnets
  s3-bucket         = module.s3.s3-bucket
  alb-log-s3-prefix = var.alb-log-s3-prefix
  vpc-id            = module.vpc.vpc-id
}

module "waf" {
  source          = "./modules/waf"
  alb-arn         = module.alb.alb-arn
  waf-description = local.waf-description
  waf-name        = var.project-name
  waf-env         = var.project-env
}

module "ecs" {
  source               = "./modules/ecs"
  alb-target-group-arn = module.alb.target_group_arn
  ecs-env                   = var.project-env
  ecs-name                = var.project-name
  ecs-private-subnets-ids = module.vpc.private-subnets
  ecs-security-group = module.vpc.ecs-sg
  task-desired-count = 3
}

module "auto-scaling" {
  source             = "./modules/auto-scaling"
  auto-scaling-name  = var.project-name
  ecs-cluster-name = module.ecs.ecs-cluster-name
  ecs-service-name = module.ecs.ecs-service-name
}