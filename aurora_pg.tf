
# # Aurora with serverles with mutiple az with Postgres 14.6 
# # aurora subnet group for db
# resource "aws_db_subnet_group" "test-aurora-subnet-group" {
#   name       = "aurora-subnet-group"
#   subnet_ids = [aws_subnet.az1-priv.id, aws_subnet.az2-priv.id, aws_subnet.az3-priv.id]
# }

# resource "aws_security_group" "test-aurora-sg" {
#   name   = "test-aurora-sg"
#   vpc_id = aws_vpc.vpc-test.id
# }

# resource "aws_db_parameter_group" "test-aurora-parameter-group" {
#   name   = "test-aurora-parameter-group"
#   family = "aurora-postgresql12"

#   parameter {
#     name         = "max_connections"
#     value        = "100"
#     apply_method = "pending-reboot"
#   }
# }

# resource "aws_rds_cluster" "test-aurora-cluster" {
#   cluster_identifier              = "test-aurora-cluster"
#   engine                          = "aurora-postgresql"
#   engine_version                  = "14.6"
#   database_name                   = "mydatabase"
#   master_username                 = var.db_username
#   master_password                 = var.db_password
#   vpc_security_group_ids          = [aws_security_group.test-aurora-sg.id]
#   db_subnet_group_name            = aws_db_subnet_group.test-aurora-subnet-group.id
#   db_cluster_parameter_group_name = aws_db_parameter_group.test-aurora-parameter-group.name
#   skip_final_snapshot             = true
#   backup_retention_period         = 7
# }

# resource "aws_rds_cluster_instance" "test-aurora-instance" {

#   for_each           = aws_subnet.az1-priv.availability_zone != "" ? toset(["az1", "az2", "az3"]) : toset(["az1"])
#   cluster_identifier = aws_rds_cluster.test-aurora-cluster.id
#   instance_class     = "db.serverless"
#   engine             = "aurora-postgresql"
#   availability_zone  = each.key



# }