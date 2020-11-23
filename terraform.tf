terraform {
  required_version = "~> v0.13.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }
}

