# ec2-terraform

Plugin reinitialization required. Please run "terraform init".

Plugins are external binaries that Terraform uses to access and manipulate
resources. The configuration provided requires plugins which can't be located,
don't satisfy the version constraints, or are otherwise incompatible.

Terraform automatically discovers provider requirements from your
configuration, including providers used in child modules. To see the
requirements and constraints from each module, run "terraform providers".

To deploy a running Flask application, simply run:

`terraform apply`

Local key needs to be created, along with the necessary security policies
for this all to work.

To terminate instance:

`terraform destroy` 
