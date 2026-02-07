Go to this [page](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and install Terraform


![alt text](image-3.png)

A Terraform (.tf) file generally looks like  this

![alt text](image.png)

When we want to create an AWS instance using a Terraform file, this may look like this

![alt text](image-1.png)

For example, an S3 object in AWS might be created like this

![alt text](image-2.png)



### But what is a resource?

A resource is an object that Terraform manages for us. It can be a local file or an AWS object, or service, or many more!!

![alt text](image-4.png)


# The workflow

First, we write the configuration file (local.tf)

Then, we initialize, plan, and apply the changes.

![alt text](image-5.png)

For example, let's create a local.tf file to generate a pets.txt (mentioned in the filename). It should have the content "We love cat" (mentioned in the content)
We are following this [documentation](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)

![alt text](image-6.png)

Once done, let's write "terraform init" to initialize the file on our terminal

![alt text](image-7.png)

Then we will use Terraform plan to see what Terraform will execute now

![alt text](image-8.png)

These variable informations are available in the official documentation.

![alt text](image-12.png)

<img width="689" height="647" alt="image" src="https://github.com/user-attachments/assets/6d01301e-f5a4-4bd2-900c-345d584ad6c3" />



You can see that the content is what we wrote, also, the filename should be pets.txt, and + icon means these should be added.

We can also see "+create" meaning it will be created.

Let's apply the changes using terraform apply

![alt text](image-9.png)

Once I have written yes, you can now see the pets.txt file generated on the left

![alt text](image-10.png)



For a better understanding of the commands we can use in a .tf file, check out this one

![alt text](image-11.png)

Here we have an example to work with [amazon bedrock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_provisioned_model_throughput) (used to generate AI resources)


You can see the list of commands from "Argument Reference". For example, model_arn, commitment_duration, model_units, etc were used in the Example Usage.

Note: Only the required fields must be included in the .tf file





# Update resource

Let's add a new line called file_permission which has value 0700

![alt text](image-13.png)

Now let's use terraform plan

![alt text](image-14.png)

This time you can see that the system is intelligent enough to detect an existing pets.txt file . It then changes the file_permission from 0777 (by default) to 0700.

Once we write terraform apply command and provide yes value, it will destroy the previous file and create one with the new file_permission

![alt text](image-15.png)

# Destroy or delete the resource permanently

To delete a resource permanently, use the terraform destroy command

Once the command is used, it will show which files or content will be removed with the (-) icon

Here, we have used terraform destroy command in our terminal now

![alt text](image-16.png)

If I write yes, now and press enter, the file pets.txt will be gone!!

![alt text](image-17.png)

There is no pets.txt file now left
![alt text](image-18.png)


# How many tf files should we create?

Rather than having multiple tf files, we should have one main.tf file

NOTE: Here the local.tf file creates a pets.txt file with some content in it. And cat.tf file creates cat.txt file with some content in it.


![alt text](image-19.png)

In this case , for each .tf file, there will be resources created that might not be our goal.

![alt text](image-20.png)

So, we should have main.tf with all of the content.

![alt text](image-21.png)


But what do professional dev people do in this case?

The best practice is to split different configuration files (main.tf, variables.tf). 

![alt text](image-22.png)
You may ask that then why did I copy the content of local.tf and cat. tf in main.tf, right?

The answer is easy. As I could keep it in one single file to generate, why should I have multiple? But for the provider.tf, variables.tf, etc, we have to keep them different as there might be too many providers (AWS, Google, Azure) and too many variables. We can't keep all of them in the main.tf file


# Terraform providers


Check out the providers from [here](https://registry.terraform.io/browse/providers)


![alt text](image-23.png)

When we used this local_file, where "local" is the provider ([hashicorp/local](https://registry.terraform.io/providers/hashicorp/local/latest)) and "file" is the resource, once we pressed terraform init, the hashicorp/local file was downloaded to a secret file called (/root/terraform-local-file/.terraform)

![alt text](image-24.png)

Here in hashicorp/local, hashicorp is the organization name,and local is the type

![alt text](image-25.png)


# Using multiple providers

Assuming we have loca.tf where we used local_file and installed hashicorp/local via terraform init. Then we decided to copy the content from local.tf here in the main.tf. Just because we thought to act like a professional dev. Hehe!

now let's add another resource_type called random_pet in our main.tf. It means random is the provider and per it he resource.

![alt text](image-26.png)

Once we press terraform init, we can see that it uses the previously installed Hashicorp/local provider for the local_file

and is now installing the Hashicorp/random provider for random_pet

![alt text](image-27.png)

Then use terraform plan and terraform apply.

![alt text](image-28.png)
![alt text](image-29.png)

Note: When using a random provider, it stores random values. Here, Mrs. hen was stored in id.

Another example can be,

![alt text](image-30.png)

Here, 2 providers, hashicorp/random and hashicorp/aws, will be used.

The random_string will create a 6-length string that has no uppercase and no special characters. Whereas the AWS resource will create an instance which is of instance_type m5.large and has a tag. This tag will use the randomly generated string we earlier created.

Why are we even creating tag?

In AWS, we create tags to later use them in various tasks. So, rather than manually setting the name for tags, we are using this random reso


### Version of a provider
The local provider has various versions. By default, when using terraform init, it installs the latest version. We may need to change it

![alt text](image-31.png)

For example, go to this page and choose version 1.4.0 from the dropdown menu

![alt text](image-32.png)

Then, press Use Provider, and we will get a code that we can paste alongside the previous content we had.

![alt text](image-34.png)

![alt text](image-33.png)

Here we can see the required providers contain the local provider, which can be found in hashicorp/local, and the version is 1.4.0

Also, to ignore a specific version or control versions, we can use >, <, !=, ~>, etc 

![alt text](image-35.png)

Once presseed terraform init, it will then do what we mentioned.

![alt text](image-36.png)


### Aliases

Assume we have to create 2 key_pair resources in two regions of AWS, and we have just set the provider aws in the us-east-1 region

**NOTE**: AWS uses key pairs primarily to provide a secure and robust method for authenticating and connecting to EC2 instances. This mechanism leverages public-key cryptography, offering a more secure alternative to traditional password-based authentication, especially for Linux instances.

![alt text](image-37.png)

If we continue, it will create two key_pairs in the us-east-1 region.

So, let's create another provider that has region ca-central-1 mentioned, and the alias is set to central here.

![alt text](image-38.png)

Assume that we want to  use this region. For that, we need to write provider=provider_name.alias in our main.tf file.


![alt text](image-39.png)


Now, once you press terraform show, you can see that a resource is created in us-east-1 and another one in ca-central-1

![alt text](image-40.png)


# Variables

Instead of using values in the main.tf file, 

![alt text](image-26.png)

We can set variables and define them like this

![alt text](image-41.png)

This is another example to create an AWS instance using 
![alt text](image-42.png)

Also, we have another option to manually input the value later. To do that, we need to remove the default variable now.

![alt text](image-43.png)

Then, once pressed, terraform apply, we have to input the values.

![alt text](image-44.png)

Or, we can pass the values using -var and then the variable and the value name

![alt text](image-45.png)


Or, we can keep the variable values again in another folder named variables. tfvars (keep in mind that we already have variables.tf and maint.tf)

Then pass this file to the terminal using -var-file variable.tfvars

![alt text](image-47.png)

If we use multiple ways to store the variable, it will follow a priority order


![alt text](image-48.png)

Keep a note that we can set various values for our variables

![alt text](image-49.png)


variable type can be of number, boolean, list, dictionary, string, etc.
Here, we have default which is of type list. And has 3 values. We can refer them to 0, 1, 2

Note: Don't assume type= list 0 1 2 is a value.It's used to make you understand the default list we have set.


![alt text](image-50.png)


You can see that, we have used the var.servers[indexing] here in the main.tf


Also, we can define a variable like this

![alt text](image-51.png)

Various types of variables are used. Specially list(string) means that a list is there which has string values ("fish", "chicken", "turkey")


What if we want to output a particular variable value every time we write terraform apply?

To do that, we need to set the output "variable_name"  and provide a value and argument there in the main.tf file.

![alt text](image-52.png)

Now, once pressed terraform apply, it shows the output variable's value pub ip = 54.214.145.69 which is actually aws_instance.cerberus.public_ip. The public IP of the instance is printed.


OR, we can see that using these commands (terraform output pub_ip) as well

![alt text](image-53.png)

# Keep sensitive data safe
We can set sensitive=true for variables. Then this value will be sensitively handled.

![alt text](image-54.png)
While doing the Terraform plan, you can now see the sensitive value tag used.

![alt text](image-55.png)

If in the future you want to print any specific variable (ami instance or, instance type) value in the output, we can put that in the value of the output.


![alt text](image-56.png)

Once pressed terraform apply, we can see this kind of message. As we set sensitive = true for variable "ami" and we are again asking to show it in the output, it's showing this error


![alt text](image-57.png)

Let's set sensitive = true for the output "info_string". 

![alt text](image-58.png)

The output will display the "sensitive" word for the info_string now.

![alt text](image-59.png)

Although using terraform output "variable_name", we can see the secret value

![alt text](image-60.png)



Earlier, we have seen how we can pass resources created from one to another. Here is another example where we pass the kay_name generated from aws_key_pair to aws_instance

![alt text](image-61.png)


Once we apply the changes, key_pair will be created first and then the instance.

Also, we can make sure that one can be created first and another second by using depends_on ; on the second resource

![alt text](image-62.png)


This is another example of using resources from one to another.

![alt text](image-63.png)

When random provider is used, an id is generated. This is an example we used earlier. You can see id=Mrs.hen generated there.

![alt text](image-29.png)

So,  a random id value is set in the main.tf file

Now, if we decide that the string should be of length 5 (earlier we had 6), and apply changes, it will create a random string of length 5 and rename the tag for the instance with this string. 

![alt text](image-64.png)

If we just want to create a 5-length string but don't want to apply this change to the AWS instance that depends on this string, we can use this

![alt text](image-65.png)

In this way, a random variable of length 5 will be generated, but the tag for the instance won't have any changes to it.

It's called resource targeting, which we did only for the resource "random_string" "server-suffix."



# Data Source

Earlier we have seen how we can use one resource in another

![alt text](image-66.png)

Here you can see that we are using the public key created by resource (aws_key_pair.alpha) while creating an instance (aws_instance.cerberus)

Now assume that, we have created key pair manually and saved that in AWS. We then want to use that while creating a resource using terraform.


![alt text](image-67.png)

To do that, we need to use data source here.We need to create a "data" block for that. Then set the key value pair (key_name="alpha"). Later we can use that key while creating an IAM instance.


In the documentation for aws_key_pair, you can check that we had options to add key_name, key_id, filters in the data source block
![alt text](image-68.png)


So, in general there is a difference between "resource" block and "data" block (data resource : which is not created using terraform rather created manually or imported from other media)

# Terraform state

When we create any resource using the apply command, a .tfstate file is created within the same folder

![alt text](image-69.png)
Terraform also creates a backup of the file incase someone mistakenly deleted the .tfstate file.

So, what does this .tfstate file store? It stores all of the information about the resources we are creating
![alt text](image-70.png)

So, how does it work?

When we use terraform plan, it checks the .tfstate file and compares prposed changes with the current .tfstate file.


For exaple, let's assume this is the current .tfstate file


![alt text](image-72.png)
Now, we have made changes to the variables.tf file

![alt text](image-73.png)

Once pressed the terraform plan command, it will now compare these changes. You can see that, it found a different in the variable value for "instance_type"
![alt text](image-74.png)
![alt text](image-75.png)

So, .tfstate file works as a blueprint.

It also stores the dependency. So, this helps terraform create or delete the dependency resources before another ones

![alt text](image-76.png)

In case, we don't want .tfstate to get the updated information, we can use -refresh=false 

![alt text](image-71.png)


One of the issues of .tfstate file is, it stores sensitive informations. So, we should not upload it to version control system like GitHub, GitLab etc. You can upload normal .tf files in these platforms.

Rather it should be stored in Amazon s3, Terraform cloud etc.
![alt text](image-77.png)


# Remote state
Earlier we dealth with local .tfstate files kept in our laptop, pc etc.

Earlier we mentioned, we should upload the .tfstate files in Amazon s3 etc.Moreover, there is a reason why can't upload them on GitHub etc.

When multiple team mates are using same resources to work on, terraform needs state lock mechanism to apply the changes. 

![alt text](image-78.png)
![alt text](image-79.png)

Sadly, GitHub and other version control system does not provide that.

To work with team mates with same resources, we need to move to cloud. But we can't move these .tfstate files to GitHub etc. So, that's why we should uplaod them to AWS S3, Terraform cloud, HashiCorp Consul etc.

![alt text](image-80.png)

So, once we are using remote statefile, it's automatically updated everytime we use terraform apply.

But how to create remote state file when we already have a local state file ?

![alt text](image-81.png)

Here you can see main.tf file there to create some resources. Also a .tfstate file is created there.

To have remote state, we need another .tf file which will have terraform block


![alt text](image-82.png)

Then apply the changes

![alt text](image-84.png)


Here s3 resource is created. But, we have no files to track. Then we need to use terraform init command to copy the .tfstate file we have loally

![alt text](image-83.png)

Now, as the local file is copied in the cloud, we can remove this file locally.
![alt text](image-85.png)

So, if there are any changes ; it will be compared with the remove state file.


# Dependency lock file


![alt text](image-86.png)

When the init command was used, it updates the lock file or updates it. 
![alt text](image-87.png)

When you plan to update providers, you can update the providers.tf file

![alt text](image-88.png)

Then use the terraform init -upgrade command to upgrade those dependencies in the lock file.

![alt text](image-89.png)


Note: You need to upload this lock file in platforms like GitHub etc to ensure other team mates can access the updated dependency info.


# Some terraform commands and their usage

terraform fmt command makes our code readable

![alt text](image-91.png)

From this to this........
![alt text](image-92.png)

terraform validate command checks if we have made any mistake in our code.

terraform show command shows current state.

terraform show -json can be used to show the code in json format.
![alt text](image-90.png)

terraform providers show the providers we have used as of now.

terraform output prints the output from the output block

![alt text](image-93.png)

terraform plan refreshes terraform states prior to plan, compares the desired state with the current state, shows an execution plan.

![alt text](image-94.png)

terraform apply -refresh-only will refresh the state files if there was any manual changes made to resources outside terraform.


for terraform state files, we should not use vim editor etc, rather use list, mv, pull, rm, show, push etc.


![alt text](image-95.png)

terraform state list command shows existing resources in the state file

![alt text](image-96.png)

Again, terraform state show < resource > will show the attributes for the resource

![alt text](image-97.png)

terraform state mv < > < > moves or, renames file

![alt text](image-98.png)
Here, the name has been changed.

![alt text](image-99.png)

Then we should use terraform to create this resource.


When we have the remote state file, we might need to locally download it. We can do that using terraform state pull command.

![alt text](image-100.png)

We can also pass the output generated (after using the state pull command) to a JSON query to filter out data


We can use terraform state rm command to remove resources from the state file

![alt text](image-101.png)

Note: once we removed it from statefile, it's not actually removed. Terraform won't just handle the resource from now on. So, manually delete the resource.


terraform state push command overrides the remote state with a local state file.
![alt text](image-102.png)

But incase you want to push a random stuff and override the remote state file, terraform can prevent that and save you.

![alt text](image-103.png)


# Lifecycle rules

Assume that we have an AWS Instance already created called ami-061......

![alt text](image-105.png)

and if we want to now create another resource called ami-2158c.... now, it will destroy the existing ami-061... and then create the new one.

![alt text](image-104.png)

But wait a minute! What if we want to ensure that, this new resource should be created first and then the old one should be deleted?

We can do that using create_before_destroy attribute. We need to set the value to true and use terraform apply. Once done, we will have the new ami-215... created first.

![alt text](image-106.png)

And then the old one will be destroyed.

![alt text](image-107.png)

What if we don't want to delete this resource we have created right now?

We can set prevent_destroy to true to lock it

![alt text](image-108.png)

But the resource can still be destroyed.

Also, in some cases we might need to change some attributes of an existing resource. 

![alt text](image-109.png)
For example, here this resource had a tag "Cerverys-Webserver". Later it was changed to 
"Cerverys-Webserver-1". Then we have decided that we don't want the existing resource to apply this change but it should remain only in the .tf file

To do that, we can use ignore_changes

![alt text](image-110.png)


# Terraform taint

Assume that, we have created a resource to print the public ip address of an existing AWS Instance

![alt text](image-111.png)

It might fail due to path issue or any other thing. When this happens, terrafomr taints it. So, once you run the terraform plan command, you can see that.


![alt text](image-112.png)

Later when terraform apply command will be used, it will again try to do the task that's tainted.



# Debugging

To debug any issue, we can check the logs in 5 levels. For example, to set the TRACE level, we can do this.

![alt text](image-113.png)

Then when using the terraform plan command, we can see more  logs than usual to track the issue.

![alt text](image-114.png)

We can also save logs in a specific location (/tmp/terraform.log)
![alt text](image-115.png)


# Terraform import

Sometimes it can happen that, we have created some resources using terraform, some via other IAC tools like Ansible or, console

![alt text](image-116.png)

But then you have decided to import them within terraform to monitor and work from now.

![alt text](image-117.png)

Assume that we have this resource already created in AWS. Let's copy the unique instance id

![alt text](image-118.png)

Then we have to create an empty resource (just to give it a name) and finally import it using the unique instance id we copied

![alt text](image-119.png)

You can now ask what about the empty attributes? We can now manually add the attributes 

![alt text](image-120.png)
![alt text](image-122.png)
and terraform will recognize it  because it already has these information in the terraform state file. So, no actions will be taken meaning it won't be imported or created or anything because it's already done earlier.

![alt text](image-121.png)


# Terraform Workspace

Assume that we have a main.tf and variables.tf file and .tfstate file has all of the tracking of the resources creating using main.tf and variables.tf file

![alt text](image-123.png)

What if we plan to have two different workspace which also have same amount of resources created.

For example, here this main.tf and variable.tf file created an instance which has ami set as ami-24e........., instance_type=t2.micro, region=ca-central-1

Let's create 2 workspaces. By default we have workspace set as default.


![alt text](image-124.png)

Now, assume our manager mentioned to have same ami instance created in two workspaces created in the same region. But we need to have different instance types.

![alt text](image-125.png)

So, to implement that, we just need to make changes to the main.tf file and variables.tf file (to use map)

![alt text](image-126.png)

Remember that, we created the "development" workspace at last. So, by default we are in the "development" workspace.

![alt text](image-127.png)


Now when you use the terraform console, you can see which workspace we are in (surely in the development workspace) and also the instance_type is t2.micro (set using lookup(var.instance_type...........) in the main.tf)

We can move to "production" workspace and check it's instance_type as well


![alt text](image-128.png)

But one thing is still not corrected. Both of the resources have tags (Environment= "Development")

So, we want the tags to be set based on the workspace name (production/development)

![alt text](image-129.png)

To do that, just change the Environment to terraform.workspace


Now when you are in the "development" workspace, if we use terraform apply, this resource will be created

![alt text](image-130.png)

Check the tags is (Environment = "development"), instance_type= "t2.micro"

When we move to production workspace and apply terraform apply, you can see the tags (Environment="production"), instance_type="m5.large"
![alt text](image-131.png)

Note: when we use workspace, the tfstate files are saved within .d file

![alt text](image-132.png)

You can see that, terraform.tfstate.d file contains .tfstate file for both the workspaces



# count , for each variable

We can use count attribute to ensure the number of resources to be created, use a list webservers to set the tag names.

![alt text](image-133.png)

But there are issues. To see this, if we remove web1 from the webservers list, and use terraform apply now


![alt text](image-134.png)


the first resource will have the tag web2, the second one will have tag web3. The thir resource won't have any tags , so it will be destroyed.

To solve this, we can use for_each now

![alt text](image-136.png)

Then if we apply terraform apply, you can see how it created 3 resources based on the number of webservers (var.webservers)

Then we can set the tags.

![alt text](image-137.png)

Now, if we remove the web1 from webservers ( we dont want to have the first resource any longer)

![alt text](image-138.png)

![alt text](image-139.png)

You can see the resource for the web1 is deleted this time.

Note, when we removed web1 using count, we wanted to remove the first resource but the third was removed. But using for_each, only the first was removed. So mission successful!!




# Provisioners


Provisioners are used to execute scripts or commands on a local or remote machine as part of the resource creation or destruction process.

![alt text](image-140.png)

Here we want to execute these inline commands.

But to have proper remote connection and security we need security group and ssh key pair. Let's crteate 2 resources for that

![alt text](image-141.png)

Then we need to set connection


![alt text](image-142.png)

Once done, if we use terraform apply, you can see the inline commands are executed.

This was about remote execution. What about local execution?

![alt text](image-143.png)
For the earlier EC2 instance, it had public IP address. We can store that to a local /tmp/ips.txt file using local execution.


We can also use local-exec to check if a resource is destroyed or not.


![alt text](image-144.png)


Here you can see when that the resource (EC2 instance) was deleted. So, when we wanted to use the content of /tmp/instance_state.txt file, it prints the content.


Note: The output would be "Instance 3.96.136.157 Destroyed!"


Sometimes it can happen is, if we have any wrong path set, it will show error

![alt text](image-145.png)

If we don't want it to stop and execute other resources, we need to set on_failure= continue

![alt text](image-146.png)

Here you can see that, while creating the webserver, it had issues with the path.So, it skipped this one and moved to create another resourc (aws_instance.project). This aws_instance.project code is not shown here.


Note: Terraform encourages not to use provisioners. Instead use cloud specific attributes like user_data, custom_data etc.

For example, earlier we wanted to run inline commands (sudo apt update etc.) using remove exec provisioner.


For AWS, we have user_data which can be used instead. 
![alt text](image-147.png)

This will exactly work like the remote exec provisioner.


# Built in functions

Terraform provides various built-in functions to manipulate strings, numbers, collections, and more. Here are some commonly used functions:

Using the terraform console command, we can use built in functions like file(), length() etc to check the values of the file mentioned.


![alt text](image-148.png)

Here you can see that, once we provided the ("/root/.......main.tf") file location, it mentioned the resource details. You can also see the number of regions (mentioend in the variable region), change the variables to set

There are more built in functions

![alt text](image-149.png)
![alt text](image-150.png)
![alt text](image-151.png)

So, in summary: Use terraform console and use built in functions

You can also use arithmetic operations in the console

![alt text](image-152.png)
![alt text](image-154.png)

# locals

Again when we need to use same tags multiple time, we can use local block to save it.

![alt text](image-155.png)
Here, you can see that we saved the  tags in the locals

![alt text](image-156.png)

Now, when we use terraform apply, you can see the tags are applied

![alt text](image-157.png)

You can also use locals to generate bucket name like this

![alt text](image-158.png)


For this scenario where we have 2 servers with inbound port 8080 and 22, 

![alt text](image-160.png)

We can create them using

![alt text](image-161.png)
![alt text](image-162.png)

or, we could use dynamic block to do so very fast:  
![alt text](image-163.png)


# Modules

Modules are containers for multiple resources that are used together. A module can be used to create reusable components, improve organization, and encapsulate complex logic.

Assume that in the /root/terraform-projects/aws-instance folder we have two .tf files. This is currently the active and Root module.

 ![alt text](image-164.png)

 If we create another folder now and use the .tf files kep in another folder (/root/.../aws-instance), the development folder will now be Root module whereas the used folder will be Child Module.

 ![alt text](image-165.png)


 In the terraform documentation, you can also find submodules (child modules) like this

 ![alt text](image-166.png)

 So, submodules makes it easy to load other files. In this way, we don't need to have all files in the root module.


 For example, assume that this is an architecture we are planning to create

 ![alt text](image-167.png)

Let's create the .tf files within the folder (/root/..../payroll-app)

![alt text](image-168.png)
![alt text](image-169.png)

So, our goal now is to launch this in different regions and use those files

Let's create another folder called us-payroll-app. We can now use the payroll-app folder's .tf files using source. 

![alt text](image-170.png)


Then we can initialize it and apply

![alt text](image-171.png)
![alt text](image-172.png)


We can create another folder named uk-payroll-app which again uses the same .tf files

![alt text](image-173.png)


That's it!
