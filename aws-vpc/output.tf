# output.tf

output public_subnet_id {
    value = aws_subnet.public.id
}

output vpc {
    value = aws_vpc.default
}

output network_info {
    value = {
        vpc_id     = aws_vpc.default.id
        subnet_id  = aws_subnet.public.id
        cidr_block = aws_vpc.default.cidr_block
    }
}