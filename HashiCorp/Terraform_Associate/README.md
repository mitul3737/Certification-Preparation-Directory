Go to this [page](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and install Terraform


![alt text](image-3.png)

A terraform file generally looks like  this

![alt text](image.png)

When we want to create an AWS instance using a terraform file , this may look like this

![alt text](image-1.png)

An S3 object in AWS might be created like this

![alt text](image-2.png)



### But what is a resource?

Resource is an object that terraform manages for us. It can be a local file or, an AWS object or service or many more!!

![alt text](image-4.png)


# The workflow

First we write the configuration file (local.tf)

Then initialize, plan and apply the changes.
![alt text](image-5.png)

Now, let's create a local.tf file to generate a pets.txt. It should have the content "We love cat"
![alt text](image-6.png)

once done, let's write terraform init
![alt text](image-7.png)

Then we will use terraform plan to see what terraform will execute now

![alt text](image-8.png)

You can see that the content is what we wrote, also, the filename should be pets.txt and + icon means these should be added.

We can also see "+create" meaning it will be created.

Let's apply the changes using terraform apply

![alt text](image-9.png)

Once I have written yes, you can now see the pets.txt file generated on left

![alt text](image-10.png)



For better understanding of the commands we can use in a tf file, check out this one

![alt text](image-11.png)

Here we have an example to work with [amazon bedrock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_provisioned_model_throughput) (used to generate AI resources)


You can see the list of commands from "Argument Reference". For example, model_arn , commitment_duration, model_units etc were used in the Example Usage.

Note: Only the required fields are must to be included
![alt text](image-12.png)


# Update resource

Let's add a new line called file_permission which has value 0700

![alt text](image-13.png)

Now let's use terraform plan

![alt text](image-14.png)

This time you can see that the system is intelligent enough to detect that, there is a pets.txt file already there. It then changes the file_permission from 0777 (by default) to 0700.

Once we write terraform apply command and provide yes value, it will destroy the previous file and create one with the new file_permission

![alt text](image-15.png)

# Destroy or delete resource permanently

To delete a resource permanently, use terraform destroy command

Once used the command, it will show which files or content will be removed with (-) icon

![alt text](image-16.png)

If I write yes, now and press enter, the file pets.txt will be gone!!

![alt text](image-17.png)

THere is no pets.txt file now in left
![alt text](image-18.png)


# How many tf files we should create?

Rather than having multiple tf files, we should have one main.tf file 

![alt text](image-19.png)

Else, for each tf file, there will be resources created which might not be our goal.
![alt text](image-20.png)

So, we should have main.tf with all of the content.
![alt text](image-21.png)

The best practice is to split different configuration files (main.tf, variables.tf). 
![alt text](image-22.png)
You may ask that then why did I copy the content of local.tf and cat.tf in main.tf, right?

The answer is easy. As I could keep it in one single file to generate, why should have multiple. But for provider.tf, variables.tf etc, we have to keep them different as there might be too much providers (aws, google , azure) and too much variables. We can't keep all of them in main.tf file


# Terraform providers


Check out the providers from [here](https://registry.terraform.io/browse/providers)


![alt text](image-23.png)

When we used this local_file where "local" is the provider ([hashicorp/local](https://registry.terraform.io/providers/hashicorp/local/latest)) and "file" is the resource . So, once pressed terraform init, hashicorp/local file was downloaded to a secret file called (/root/terraform-local-file/.terraform)

![alt text](image-24.png)

Here in hashicorp/local, hashicorp is the organization name and local is the type
![alt text](image-25.png)


# Using multiple providers

Assuming we have local.tf where we used local_file and installed hashicorp/local via terraform init, now let's add another resource_type called random_pet. It means random is the provider and per it he resource.

![alt text](image-26.png)

Once pressed terraform init, we can see that it uses previously installed hashicorp/local provider and now installing hashicorp/random provider.
![alt text](image-27.png)

Then use terraform plan and terraform apply.
![alt text](image-28.png)
![alt text](image-29.png)

Note: When used random provider, it stores random values. Here Mrs.hen was stored in id.

Another example can be,
![alt text](image-30.png)

Here 2 providers hashicorp/random and hashicorp/aws will be used.

the random_string will create 6 length string which has no uppercase and no special character. Whereas the aws resource will create an instance which is of instance_type m5.large and has a tag. This tag will use the randomly generated string we earlier created.


### Version of a provider

local provider has various versions. By default when used terraform init, it installs the latest version. We may need to change it

![alt text](image-31.png)

For example go to this page and choose the version 1.4.0 from the dropdwon menu

![alt text](image-32.png)

Then press Use Provider, we will then get a code which we can paste alongside the previous content we had.

![alt text](image-34.png)

![alt text](image-33.png)

Here we can see the required providers contain the local provider which can be found in hashicorp/local and the version is 1.4.0

Also to ignore a specific version or, control versions we can use >, < , !=, ~> etc 

![alt text](image-35.png)

Once presseed terraform init, it will then do what we mentioned.
![alt text](image-36.png)


### Aliases

Assume we have to create 2 key pair resource in two region of AWS and we have just set the provider aws in the us-east-1 region
![alt text](image-37.png)

Surely, it won't work like this. If we continue, it will create two key_pair in the us-east-1 region.

So, let's create another provider which has region ca-central-1 mentioned and alias is central here.
![alt text](image-38.png)

To use this region, we need to write provider=provider_name.alias which is aws.central in our main.tf file


![alt text](image-39.png)


Now, once you press terraform show, you can see that once resource was created in us-east-1 and another one in ca-central-1

![alt text](image-40.png)


# Variables

Instead of using values in the main.tf file, 

![alt text](image-26.png)

We can set variables and define them like this

![alt text](image-41.png)

This is another example for an aws instance.
![alt text](image-42.png)

Also,we have another option to manually input the value later. To do that, we need to remove the default varaible now.

![alt text](image-43.png)

Then once pressed terraform apply, we have to input the values.

![alt text](image-44.png)

Or, we can pass the values using -var and then the variable and the value name

![alt text](image-45.png)


or, we can keep the variable values again in another folder named variables.tfvars (keep in mind that, we have already variables.tf and maint.tf)


![alt text](image-47.png)

If we have used multiple ways to store the variable, it has a order which follows to use the value

![alt text](image-48.png)

Keep a note that, we can set various values for our variables

![alt text](image-49.png)


variable type can be of number, boolean, list, dictionary, string etc.

![alt text](image-50.png)

Also, check this out
![alt text](image-51.png)

Various type of variables are used. Specially list(string) means that a list is there which has string values ("fish", "chicken", "turkey")


What if we want to output a particular variable value everytime we write terraform apply?

![alt text](image-52.png)

To do that, we need to set output "variable_name"  and provie value and argument there.

Now once pressed terraform apply, it shows the output variable's value pub ip = 54.214.145.69

which is actually aws_instance.cerberus.public_ip. The public ip of the instance is printed.


OR, We can see that using these commands as well
![alt text](image-53.png)

# Keep sensitive data safe
We can set sensitive=true for variables. Then this value will be sensitively handled.

![alt text](image-54.png)
While doing the terraform plan, you can now see the sensitive value tag used.

![alt text](image-55.png)

If in future you want to print this ami instance value in output, 
![alt text](image-56.png)

It will pass this message and remind you that you have set sensitive = true for this varaiable.

![alt text](image-57.png)

You can set sensitive=true for this as well and then 

![alt text](image-58.png)

The output will display hidden one

![alt text](image-59.png)

Although using terraform apply "variable_name" , we can see the secret value

![alt text](image-60.png)



Earlier we have seen how we can pass resources created from one to another. Here is another example where we pass the kay_name generated from aws_key_pair to aws_instance

![alt text](image-61.png)


Once we apply the changes, key_pair will be created first and then the instance.

Also, we can make sure that once can be created first and another second by using depends_on , on the second resource

![alt text](image-62.png)


This is another example of using resource from one to another.

![alt text](image-63.png)

Here a random id value is set which is used in aws instance.

Now, if we decide that the string should be of length 5, and apply changes, it will create random string with 5 length and rename the tag for the instance with this string. 

![alt text](image-64.png)

If we just want to create 5 length string but don't want to apply this change to the aws instance which depends on this string, we can use this

![alt text](image-65.png)

In this way, random variable of length 5 will be generated but the name tah for the instance won't have any changes to it.

It's called resource targetting which we did only for the resource "random_string" "server-suffix"

Note: in this image the id should be nglmp instead of nglmpo



# Data Source

