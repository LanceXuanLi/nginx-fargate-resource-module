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


}
