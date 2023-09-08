variable "vpc-name" {
  description = "Name of vpc in tag"
  type = string
}

variable "vpc-env" {
  description = "Current env of vpc in tag"
  type = string
}

variable "first_n_azs" {
  description = "First n azs will be used"
  type = number
  # https://repost.aws/questions/QU6ndN_tPYR9K9NoXGA2chBw/2-azs-vs-3-or-more-azs
  # 3 AZs minimum; that way if the worst happens and there's an AZ outage, you still have redundancy.
  default = 3
}
