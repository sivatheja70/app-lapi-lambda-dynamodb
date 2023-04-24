variable "api_gateway_environment"{

}
variable "function_name"{

}
variable "function_arn"{

}
variable "stage_name"{}

variable "path"{}
variable "type"{}

variable "api_gateway_methods" {
  type = list(string)
}
variable "integration_type"{}