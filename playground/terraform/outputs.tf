output "greetings" {
  value = terraform_data.greeting[*].output
}
