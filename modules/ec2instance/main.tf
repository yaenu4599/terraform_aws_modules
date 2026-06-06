/*

resource "aws_key_pair" "main" {
  key_name   = "${var.environment}-keypair"
  public_key = var.public_key
}
*/

resource "aws_instance" "main" {
  count                  = length(var.subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_id
  subnet_id              = var.subnet_ids[count.index]
  # key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = false

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-instance"
    }
  )
}