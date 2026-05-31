# 1. Create a scalable custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "gk-eks-sprint-vpc"
  }
}

# 2. Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "gk-eks-sprint-igw"
  }
}

# 3. Public subnet 1 (Availability zone A)
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a" # Sydney AZ-A
  map_public_ip_on_launch = true

  tags = {
    Name = "gk-public-subnet-1"
  }
}

# 4. Public subnet 2 (Availability zone B - crucial for EKS!)
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b" # Sydney AZ-B
  map_public_ip_on_launch = true

  tags = {
    Name = "gk-public-subnet-2"
  }
}

# 5. Global public route table 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "gk-public-rt"
  }
}

# 6. Associate route table with subnet 1
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Associate route table with subnet 2
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# 8. IAM role for EKS cluster control plane
resource "aws_iam_role" "eks_cluster_role" {
  name = "gk-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster_role.name
}

# 9. IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "gk-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks_node_role.name
}

# 10. AWS EKS Cluster Control Plane Configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = "gk-sprint-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# 11. AWS EKS Managed Worker Node Group Configuration
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "gk-managed-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.micro"] # Standard production compute capacity for EKS

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_registry_policy
  ]
}
