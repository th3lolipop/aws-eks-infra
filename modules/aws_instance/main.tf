resource "aws_instance" "app" {
  count = var.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Terraform   = "true"
    Name     = format("%s-%s", var.project_name, format("%02d", count.index + 1))
    Environment = var.environment
  }
}