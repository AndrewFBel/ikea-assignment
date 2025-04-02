# Assignment

## Task 1: Infrastructure Setup

Write a Terraform script (main.tf) that:
-  Deploys an AzureVM running Ubuntu
-  Installs Docker on the instance
-  Opens ports 80 and 22
-  Outputs the instance’s public IP
-  Can be configured based on environment
-  Ports are configurable as well

Expected Submission: Ok: Terraform script with an outputs.tf file showing the instance’s public IP.
Preferably: Repository with github action webhook to trigger the build.

## Task 2: CI/CD Pipeline
 Create a GitHub Actions:
-  Builds a simple Node.js application
-  Packages the app into a Docker container
-  Pushes the Docker image to Azure CR
-  Dockerfile has to be secure
-  Implement caching strategy for packages
-  Implement Secure Env’s
-  Image should not expose secrets or any sensitive information

Expected Submission: A repo with a Working GA.

## Task 3: Monitoring , logging + blue/green deploy
- Create a Possibility to Monitor failed releases:
    -  Based on the work in ## Task 2 create an alerting system for failed releases
- If the image is build, but for some reason the deployment contains more errors than previous deploy, provide a way to automatically redeploy old version of the app:
    -  The fallback rollout should use sampling for errors either in logs or any monitoring tool of your choice

Expected Submission: Demo of the deploy.

# Solution Notes

## Task 1: Infrastructure Setup

### Local Deployment

*Prerequisites*
- Terraform
- Azure CLI

Related terrafrom files are located at `./terraform` directory. Given the low complexity, all configs are in single `main.tf` file without any further structuring.

In order to deploy Azure VM locally, run the following commands in the related directory. Update variables in `./terraform/terraform.tfvars` as needed.
- `az login`
- `terraform init`
- `terraform apply` or `terraform apply -auto-approve`
The public IP address of the VM will be output after the execution.

### Deployment via GHA



### Further Improvements

- Store TF State files in a remote location, not locally
- In case of project with greater complexity, separate services into separate `./terraform/modules`
- Develop a better approach for environments management. The current solution allows to deploy different environments only via separate branches
    - either create environment-specific directories
    - or, alternatively, use terraform namespaces
- Improve GitHub Actions workflow to allow triggering it, using environment as an input variable
- Security improvements (eg, run docker as a non-root user, etc)

P.S. `*.tfvars` entry was removed from `.gitignore` for illustrative purposes