# Сделать скрипт, который будет запускать и останавливать AWS EC2 инстанс 
# по расписанию в зависимости от текущего времени.

# В скрипте инициализируем переменную work_hours 
# в которой указываем диапазон времени в которое инстанс должен работать, 
# в остальное время инстанс должен быть остановлен.

# Язык не важен.
# Пример переменной: work_hours="9:00-17:00"
# Для тестов можно использовать AWS Free Tier

terraform {
  required_providers {
    aws = {
      version = "~> 3.7"
    }
  }
}

locals {
	work_hours = "10:00-17:00"
	
	project = "Example"
	instance_type = "t2.micro"
	instance_id = aws_instance.example_ec2.id
}

provider "aws" {
	region = "eu-central-1"
}

#ami autosearch
data "aws_ami" "latest_ubuntu_linux"{
	owners = ["099720109477"]
	most_recent = true
	filter {
		name = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
	}
}


#create instance
resource "aws_instance" "example_ec2" {
	ami = data.aws_ami.latest_ubuntu_linux.id
	instance_type = local.instance_type
	tags = {
		Name = "${local.project}"
	}
}

output "ec2-id" {
	value = aws_instance.example_ec2.id
}

#shutdown init
resource "null_resource" "shutdown_ec2" {
	provisioner "local-exec" {
		command = "aws ec2 stop-instances --instance-ids ${aws_instance.example_ec2.id} --profile default"
	}
}

#set shedule
resource "null_resource" "ec2_schedule_1" {
		provisioner "local-exec" {
		command = "./aws_ec2_schedule.sh ${local.work_hours} ${local.instance_id}"
	}
}





