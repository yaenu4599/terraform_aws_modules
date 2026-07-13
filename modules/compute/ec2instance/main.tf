/*

resource "aws_key_pair" "main" {
  key_name   = "${var.environment}-keypair"
  public_key = var.public_key
}
*/

resource "aws_network_interface" "main" {
  count = length(var.subnet_ids)
  subnet_id = var.subnet_ids[count.index]
  security_groups = var.security_group_ids
  source_dest_check = true

  tags = merge( var.common_tags, {
    Name = "${var.environment}-instance-eni"
  })
}

resource "aws_instance" "main" {
  count                       = length(var.subnet_ids)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  # key_name                    = aws_key_pair.main.key_name
  
  primary_network_interface {
    network_interface_id = aws_network_interface.main[count.index].id    
  }
  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-instance"
    })

  volume_tags = merge(var.common_tags, {
    Name = "${var.environment}-instance-volume"
  })
}