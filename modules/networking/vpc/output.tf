output "vpc_id" {
  description = "vpc id to use in the root module or and in other modules"
  value       = aws_vpc.main.id
}

output "subnets_public_ids" {
  description = "the ids of the public subnets in the vpc in a list"
  value       = aws_subnet.public[*].id
}

output "subnets_private_ids" {
  description = "the ids of the private subnets in the vpc in a list"
  value       = aws_subnet.private[*].id
}