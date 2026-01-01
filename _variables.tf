variable "name" {
  type        = string
  description = "The name of the key"
}

variable "description" {
  type        = string
  description = "The description of the KMS key"
  default     = ""
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled. Defaults to true following checkout best practices"
  default     = true
}

variable "policy" {
  type        = string
  description = "The kms key policy to apply in addition to the management of the key which is done by this module. Ensure this policy is restrictive and does not grant broad actions like 'kms:*'."
}

variable "bypass_policy_lockout_safety_check" {
  type        = bool
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the Default Key Policy section in the AWS Key Management Service Developer Guide. The default value is false"
  default     = false
}

variable "deletion_window_in_days" {
  type        = number
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately."
  default     = 30
}

variable "customer_master_key_spec" {
  type        = string
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT"
  default     = "SYMMETRIC_DEFAULT"
}

variable "multi_region" {
  type        = bool
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false"
  default     = false
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to the key"
  default     = {}
}
