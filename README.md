# Large-and-Complex-Cases-Infrastructure-Terraform
Large and Complex Cases Infrastructure Terraform

This repo contains a copy of the yaml pipelines, supporting pipeline task scripts and application and networking terraform folders
from the initial mono repo located here: https://github.com/CPS-Innovation/Large-and-Complex-Cases

Both the "devops-pipelines" and "terraform" folders are structured so that what is termed the "networking" and "application" are both separated and matched,
where pipelines defined inside "devops-pipelines/networking" will seek to apply terraform definitions contained in
"terraform/networking"; the same being true for the corresponding "application" folders.

The reason for this separation, is the networking terraform contains the shared definitions of all that will support
assets deployed within the PreProd and Prod subscriptions, e.g., the DNS resolver, fundamental subnets, the app-insights and log analytics
deployments and the vNet itself, and any other assets that can be shared across self-contained application deployments. The PreProd subscription
(https://portal.azure.com/#@CPSGOVUK.onmicrosoft.com/resource/subscriptions/7f67e716-03c5-4675-bad2-cc5e28652759/overview) is intended to contain any non-production versions of a complete deployment of the Large and Complex
Cases application - e.g., DEV, QA and any other that may be required (the config files in this repo offer support for a third, balancing environment called "TEST").

### The Pipelines
The "devops-pipelines/deployments" folder actually contains 4 sub-folders:
<li>"application": The main application deployment pipelines, organised into PR, build and release definitions</li>
<li>"networking": The shared, fundamental networking components, again organised into PR, build and release variants</li>
<li>"scripts": Contains two powershell scripts that are reused to test individual status endpoints, one that can be set to look for a custom value and one a custom string in any response from an endpoint.
The scripts poll and their behaviour can be set via additional inputs that are globally configured and injected into the pipelines via an Azure DevOps library called "complex-cases-global"</li>
<li>"templates": the pipeline definitions follow a templated structure and the sub-folders here are organised to follow the template -> stage -> job -> task structure of a YAML file for clarity's sake. Indeed,
each template is prefixed with the template type (e.g., "task_") to make it clear what the yaml template defines.</li>

The pipelines themselves are separated into the usual event-driven (triggered) PR, build and release variations. PR pipelines are intended
to be triggered by a PR raised by a developer wanting to merge their changes into main. The intention of the team was to continue the CI/CD model
used on the previous project (The Casework App) and make use of short-lived branches only and commit as often as possible to main, using feature flags to control the appearance of features to users.
The build pipeline trigger means that, if committed changes occur within certain folders, then the respective build pipeline will be run.
This in turn will act as a resource trigger for the related release pipeline, which will therefore have access to the build artifacts produced
by the triggering build pipeline.

As they were copied from a mono-repo, the networking pipeline triggers "look" at a specific set of folders and the application pipeline the same.
As the setup of the mono-repo pipelines was not completed, certain pipelines (e.g., the application PR pipeline has never been completed or registered with GitHub as a quality gate for merges (although the networking PR has))

Six of the pipelines (PR, build and release for the networking and application pipelines) have been registered with Azure DevOps but disabled as part of the overall refactor.

The other two pipelines in "application" are a manually triggerd build and corresponding release pipelines that are intended to be run, only on-demand and targeting the deployment of a TEST instance
of the application terraform and codebase to the PreProd environment. Again, this is a mirror of the ways-of-working that was adopted by the development team on the Casework App and intended for replication here in Large and Complex Cases.
Rather than opt for ephemeral environments, we decided on a simpler approach on the Casework App, where, by negotiation with the rest of the team a developer could build and release to "-test" suffixed versions of the application instances a specific in-flight branch and test separately from DEV and QA instances,
which were reserved for other purposes. The intention by this developer was for the terraform to initially create an "rg-LaCC-${local.suffixValue}application" resource group (where the suffix value is sourced from an instance-specific tfvars file) and all the app services and other assets within this resource group, the release pipeline
pushing to this separated, instance-specific resource group.

The ephemeral environment was never pursued, but could have been accomplished, but following evaluation, the project group as a whole decided we were already covered by various testing approaches and quality gates
and avoid taking on the workload in favour of the occasional push of a branch to such a "TEST" instance. That's the context, whether useful or relevant, or not!!

Following advice, the pipelines have been simplified back from the Casework App model upon which they were based.
A completed PR -> triggers a Build -> which triggers a Release

#### The PR
<b>Networking:</b> Solely concerned with terraform and runs a validation of the terraform files and generates a proposed plan against PreProd
<b>Application:</b> Also runs a terraform plan validation against the terraform files and generates a proposed plan against DEV within PreProd.
However, the application pipelines are also concerned with the validation and ultimate deployment of the codebase and so the application PR also runs unit tests against the backend codebase and cypress tests against a UI mock.
Test results are generated in Cobertura and aggregated together to form a single report that can be viewed against the PR run summary in Azure DevOps.
To enable the speedy running of the PR pipeline, a GIT DIFF command is used to generate a list of all changes and their location to understand if the terraform steps need to be run and/or the codebase and/or the ui.

Regardless of the changes and how widespread, or not, everything is rebuilt and re-released.
The release is now ultra simple, the complexities of the Casework App have largely been stripped out.
The application release (because of its mono-repo heritage) currently seeks to apply the terraform, deploy the codebase and check the status endpoints of any deployed app services.

### Pipeline Notes:
The UI and e2e Testing Steps have not been completed and still reflect the Casework App requirements. They will need to be fleshed out in conjuction with the UI DEVs (Renjith and Rhys B)
For this reason, the application PR has not been finalised and the UI steps commented out of the build and release pipelines for now.
The e2e test stage is also commented out in the application release pipeline. The model here was to call it (environment/instance specific version) as a child pipeline task.

To prevent collisions, all pipelines use a "wait for running" pipeline task that calls the Azure DevOps API to see if another instance of the same pipeline is already running. If so, the task polls for when it is free to run.
It will poll for up to 1 hour, in keeping with standard task timeout operations within Azure DevOps.
This has never happened, as pipeline runs will always complete (or fail!) within this timeout window.

### The Terraform
The terraform, as mentioned, is arranged is a sub-folder layout that matches the pipelines for logical/ordered reasons.
It is structure around the pipelines calling terraform task templates using pipeline parameters that denote the target environment and any environment specific variables that are held in any of two Azure DevOps
libraries for the LaCC project - these are called "complex-cases-global" and "complex-cases-terraform". These variables and the use of template parameters between them define the ".tfvars" file to use during Terraform initialisation
and the location of the terraform state file.

Other than this, the .tf files themselves are named as logically as possible and it is on the developer to run something like "terraform fmt" themselves at the command line to ensure that the layout of the files is consistent.
No linting tools are used in the pipelines currently (except for the React app, during build - e.g., prettier)

The CPS GitHub organisation has been setup up such that any new projects inherit a fundamental repo scanning design, where Checkov, ShiftLeft and CodeQl are used to scan any proposed changes for Terraform best practice, coding best practices and security best practices.
Rennovate is also used and runs in an automated fashion to suggest updates to front-end assets via automatically generated PR requests that can be evaluated by a front-end developer.
