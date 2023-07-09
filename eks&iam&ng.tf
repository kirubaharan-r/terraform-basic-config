
# # IAM role for EKS Cluster and policies

# resource "aws_iam_role" "eks-test-role" {
#   name = var.aws_iam_role
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]

#   })
# }
# resource "aws_iam_role_policy_attachment" "eks_clusterpolicy" {
#   role       = aws_iam_role.eks-test-role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

# }
# resource "aws_iam_role_policy_attachment" "eks_servicepolicy" {
#   role       = aws_iam_role.eks-test-role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
# }
# resource "aws_iam_role_policy_attachment" "eks_vpccontroller" {
#   role       = aws_iam_role.eks-test-role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
# }

# # EKS Cluster with Private subnets 

# resource "aws_eks_cluster" "test-eks-ireland" {
#   name     = var.aws_eks_cluster
#   role_arn = aws_iam_role.eks-test-role.arn
#   vpc_config {
#     subnet_ids = [aws_subnet.az1-priv.id, aws_subnet.az2-priv.id, aws_subnet.az3-priv.id]
#   }
#   depends_on = [
#     aws_vpc.vpc-test
#   ]
# }

# output "arn-eks" {
#   description = "open id issuer add it to iam role for alb  dr_eks_alb_role"
#   value       = aws_eks_cluster.test-eks-ireland.identity[0].oidc[0].issuer

# }



# # IAM role for EKS Node Group and policies


# resource "aws_iam_role" "eks_node_role" {
#   name = "test-eks-node-group-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]

#   })
# }
# resource "aws_iam_role_policy_attachment" "eks_node_workernode_role_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }
# resource "aws_iam_role_policy_attachment" "eks_node_registry_role_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }
# resource "aws_iam_role_policy_attachment" "eks_node_cni_role_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# # on-demand node group

# resource "aws_eks_node_group" "test-eks-ireland-nodegroup" {
#   cluster_name    = aws_eks_cluster.test-eks-ireland.name
#   node_group_name = "test-eks-ireland-nodegroup-ondemand"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = [aws_subnet.az1-priv.id, aws_subnet.az2-priv.id, aws_subnet.az3-priv.id]
#   instance_types  = ["t3.xlarge"]
#   update_config {
#     max_unavailable = 1
#   }
#   capacity_type = "ON_DEMAND"
#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 1
#   }
#   depends_on = [
#     aws_eks_cluster.test-eks-ireland
#   ]
# }

# # Spot node group
# resource "aws_eks_node_group" "test-eks-ireland-nodegroup-spot" {
#   cluster_name    = aws_eks_cluster.test-eks-ireland.name
#   node_group_name = "test-eks-ireland-nodegroup-spot"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = [aws_subnet.az1-priv.id, aws_subnet.az2-priv.id, aws_subnet.az3-priv.id]
#   instance_types  = ["t3.xlarge"]
#   update_config {
#     max_unavailable = 2
#   }
#   capacity_type = "SPOT"
#   scaling_config {
#     desired_size = 2
#     max_size     = 10
#     min_size     = 2
#   }
#   depends_on = [
#     aws_eks_cluster.test-eks-ireland
#   ]
# }