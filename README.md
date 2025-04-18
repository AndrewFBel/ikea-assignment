# Assignment

- [Assignment](#assignment)
  - [Task 1: Infrastructure Setup](#task-1-infrastructure-setup)
  - [Task 2: CI/CD Pipeline](#task-2-cicd-pipeline)
  - [Task 3: Monitoring , logging + blue/green deploy](#task-3-monitoring--logging--bluegreen-deploy)
- [Solution Notes](#solution-notes)
  - [Task 1: Infrastructure Setup](#task-1-infrastructure-setup-1)
    - [Local Deployment](#local-deployment)
    - [Deployment via GHA](#deployment-via-gha)
    - [Further Improvements](#further-improvements)
  - [Task 2: CI/CD Pipeline](#task-2-cicd-pipeline-1)
    - [Current Solution](#current-solution)
    - [Further Improvements](#further-improvements-1)
  - [Task 3: Monitoring , logging + blue/green deploy](#task-3-monitoring--logging--bluegreen-deploy-1)
    - [Current Solution](#current-solution-1)
    - [Further Improvements](#further-improvements-2)


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
Create a GitHub Actions:
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
- export SSH key which will be used to access VM: `export TF_VAR_ssh_public_key = "ssh-rsa AAAAByour-super-key email@machine-name"` 
- `az login`
- `terraform init`
- `terraform apply` or `terraform apply -auto-approve`
The public IP address of the VM will be output after the execution.

### Deployment via GHA

*Prerequisites*
- Create Azure Managed Identity, grant it access to Subscription and add Federated credentials
- Add following env vars to GHA secrets:
    - AZURE_SUBSCRIPTION_ID
    - AZURE_TENANT_ID
    - AZURE_CLIENT_ID
    - VM_SSH_PUBLIC_KEY (used to access VM)

The GHA workflow is located at `.github/workflows/terraform.yaml` and, in current solution, has only a manual [trigger](https://github.com/AndrewFBel/ikea-assignment/actions/workflows/terraform.yaml).

### Further Improvements

- Store TF State files in a remote location, not locally
- In case of project with greater complexity, separate services into separate `./terraform/modules`
- Develop a better approach for environments management. The current solution allows to deploy different environments only via separate branches
    - either create environment-specific directories
    - or, alternatively, use terraform namespaces
- Improve GitHub Actions workflow to allow triggering it, using environment as an input variable
- Security improvements (eg, run docker as a non-root user, etc)
- Output public IP directly to GHA run results summary
- Ensure that `terraform apply` runs only after approval (eg, via PR)
- Better branching strategy and GHA triggers to manage workflows
- Output and send (if needed) build artefacts
- Implement alerting for terraform warnings

P.S. `*.tfvars` entry was removed from `.gitignore` for illustrative purposes

## Task 2: CI/CD Pipeline

### Current Solution

GitHub Actions workflow is located at `.github/workflows/node.yaml`. It has triggers in `push` and `pull request` events towards the `main` branch. Besides, it can be [triggered manually](https://github.com/AndrewFBel/ikea-assignment/actions/workflows/node.yaml).

The workflow builds Docker Image and pushes it with the `latest` tag to ACR (created manually in advance).
The following GHA secrets needs to be added:
    - AZURE_REGISTRY_LOGIN_SERVER
    - AZURE_REGISTRY_PASSWORD
    - AZURE_REGISTRY_USERNAME

### Further Improvements

- When the complexity of the project incerases:
    - use multi-stage Docker builds
    - minimise number of loyers to keep image lightweight
- Better branching strategy and GHA triggers to manage workflows
- Use registry/GitHub-local storage for caching
- Use Node linter and tests (+ store its artifacts)
- Improve image versioning (using app version, eg, `node-app:v1.0.0`, or commit hash, eg, `node-app:${GITHUB_SHA}`)

## Task 3: Monitoring , logging + blue/green deploy

### Current Solution

Workflow at `.github/workflows/deploy.yaml` deploys image to Azure WebApp. It has basic release safety feature, implemented using log monitoring and rollback option.

Triggers:
- manual dispatch
- successful image build workflow

Flow: 
- Pulls image from ACR and deploys to Azure WebApp
- Waits 10 minutes (Azure delay) to query logs from Logs Analytic workplace
- Checks number of Error-level logs durng past 10 mins
- Rolls back to previous image if number of errors > 5

P.S. Azure delay can be up to 15 mins for Log Analytics

### Further Improvements

- Use Aure WebApp slots for blue-green deployent or Azure Containers/AKS
- Add application health-check API endpoint
- Improve loggint (eg, Application Insights) + specific metrics
- Better branching and taging strategies
- Implement notificatons