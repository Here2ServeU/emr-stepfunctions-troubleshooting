provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "scripts_bucket" {
  bucket = "emr-bootstrap-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_object" "bootstrap_script" {
  bucket = aws_s3_bucket.scripts_bucket.id
  key    = "scripts/bootstrap.sh"
  source = "../scripts/bootstrap.sh"
}

resource "aws_emr_cluster" "emr_cluster" {
  name          = "EMR-ML-Cluster"
  release_label = "emr-6.10.0"
  applications  = ["Spark"]
  service_role  = aws_iam_role.emr_service.arn
  ec2_attributes {
    instance_profile = aws_iam_instance_profile.emr_profile.arn
  }

  master_instance_type = "m5.xlarge"
  core_instance_type   = "m5.xlarge"
  core_instance_count  = 2

  bootstrap_action {
    path = "s3://${aws_s3_bucket.scripts_bucket.id}/${aws_s3_bucket_object.bootstrap_script.key}"
  }

  autoscaling_role = aws_iam_role.autoscale_role.arn
  visible_to_all_users = true
}

resource "aws_iam_role" "emr_service" {
  name = "EMR_DefaultRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "elasticmapreduce.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  role       = aws_iam_role.emr_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role" "autoscale_role" {
  name = "EMR_AutoScaling_DefaultRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "application-autoscaling.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "autoscale_policy" {
  role       = aws_iam_role.autoscale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}

resource "aws_iam_role" "emr_ec2_role" {
  name = "EMR_EC2_DefaultRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "EMR_EC2_Profile"
  role = aws_iam_role.emr_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.emr_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}
