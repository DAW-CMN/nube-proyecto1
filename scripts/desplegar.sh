#!/bin/bash
# Proyecto 1 · Librería Tinta
set -euo pipefail
export AWS_PAGER=""
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

REGION="us-east-1"
SUBNET_ID="subnet-025fe92b3ca3a9b10"
VPC_ID="vpc-04bc8f97c70ef5276"
MI_IP="37.222.179.67/32"
ALUMNO="Cristian Moresi"

# 1. Amazon Linux 2023
AMI_ID=$(aws ssm get-parameters --region "$REGION" \
  --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query "Parameters[0].Value" --output text)

# 2. Seguridad
SG_ID=$(aws ec2 create-security-group --region "$REGION" \
  --group-name libreria-web-cli-sg \
  --description "Web Libreria Tinta (CLI)" --vpc-id "$VPC_ID" \
  --query GroupId --output text)

aws ec2 authorize-security-group-ingress --region "$REGION" \
  --group-id "$SG_ID" --protocol tcp --port 80 --cidr 0.0.0.0/0 --output text >/dev/null
aws ec2 authorize-security-group-ingress --region "$REGION" \
  --group-id "$SG_ID" --protocol tcp --port 22 --cidr "$MI_IP" --output text >/dev/null

# 3. Servidor
INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \
  --image-id "$AMI_ID" --instance-type t3.micro --key-name vockey \
  --subnet-id "$SUBNET_ID" --security-group-ids "$SG_ID" \
  --user-data file://user-data1.sh \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=libreria-web-cli},{Key=Proyecto,Value=P1},{Key=Alumno,Value=$ALUMNO}]" \
  --query 'Instances[0].InstanceId' --output text)

echo "Instancia creada: $INSTANCE_ID"
aws ec2 wait instance-running --region "$REGION" --instance-ids "$INSTANCE_ID"
IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Abre en el navegador: http://$IP"
