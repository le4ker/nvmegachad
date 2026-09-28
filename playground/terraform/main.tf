terraform {
required_version = ">= 1.4"
}

resource "terraform_data" "greeting" {
count=length(var.names)
  input = "Hello, ${var.names[count.index]}!"
}
