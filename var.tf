variable "ami_id" {
  default     = "ami-07ffb2f4d65357b42"
  description = "launching ubuntu os image"
}

variable "instance_type" {
  default = "t2.micro"

}

variable "key_name" {
  default = "test-key"

}

variable "region" {
  default = "ap-south-1"

}