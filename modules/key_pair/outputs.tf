output "key_pair_name" {
  value = aws_key_pair.generated_key.key_name

}

output "private_key_pem" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "private_key_path" {
  value = local_file.private_key_pem.filename
}
