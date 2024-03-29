resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.environment}-${var.app_name}-key" # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh


}
/*=====
The below block will keep executing in plan and apply if it doesn't find the file in the directory
=====*/
resource "local_sensitive_file" "pemfile" {
  content  = tls_private_key.pk.private_key_pem
  filename = "./${var.environment}-${var.app_name}-key.pem"
}