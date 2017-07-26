output "public_subnet" {
  value = ["${aws_subnet.public.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.id}"]
}

output "igw_id" {
  value = "${aws_internet_gateway.mod.id}"
}
