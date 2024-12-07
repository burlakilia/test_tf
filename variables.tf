variable "folder_id" {
  type        = string
  default     = "b1gul1ta5kjgetdeqi9e"
  description = "Идентификатор каталога"
}

variable "zone1" {
  type        = string
  default     = "ru-central1-a"
  description = "Сетевая зона"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона для сети"
}

variable "app_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "CIDR для приватной сети"
}

variable "public_s3_name" {
  type = string
  default = "burlakilia-practice-v1"
  description = "имя публичного бакета для статики" 
}