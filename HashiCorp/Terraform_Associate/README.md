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

