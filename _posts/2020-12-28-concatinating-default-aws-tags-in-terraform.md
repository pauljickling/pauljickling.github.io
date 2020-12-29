---
layout: post
title: "Concatinating Default AWS Tags in Terraform"
date: 2020-12-28
---

In a large organization that heavily uses AWS for their infrastructure needs managing and tracking costs is an extremely complicated tasks. One tool to help improve observability is with user-defined tags. This allows administrators to create categories of resources that make sense for the organization.

In Terraform, one common pattern is to create a variable resource for default tags that can be applied to other AWS resources. It looks something like this:

```
variable "default_tags" {
  type = map(string)

  default = {
    Environment = "dev"
    Team        = "foo"
    Project     = "bar"
  }
}
```

Then, in the various other resources you create, you will add a line with your tags that will look something like, `tags = merge(var.default_tags), map("Name", "my-vpc"))`.

This is a nice pattern that keeps your configuration DRY. But what if you want a tag that is a concatenation of your default tags? These concatenated values can be useful for tracking costs without having to apply a lot of filters in AWS's Cost Explorer. Terraform requires that the values for default variables be literal. However we can work our way around this limitation by making use of *local values* and *string directives*.

*Local values* are a resource you can create in Terraform that is internal to your module. They essentially work the same as other types of variables, but they cannot be exported to other modules. *String directives* are a technique for looping over collection data objects like maps with string types such that they output the collection of strings in a certain way. By combining local values and string directives together we can create a tag that is a combination of our default tags. It looks like this:

```
locals {
  cat = << EOF
%{~for tag in var.default_tags}
  ${tag}/
%{~endfor}
EOF
}
```

The first thing to note is that you only get one `locals` resource per module, and everything goes in there. With this one we create a local value for `cat` that will be our concatenation of default tags. We assign the value using the string directive, which you will notice resembles the syntax of for loops in bash. Notice the `~` character inside the curly braces for the beginning and end of the for loop. By default, string directives will attach newline characters at the start and end of each iteration of your for loop. The `~` character removes those newline characters.

To apply your local value to tags, we simply add it to the merge/map function in the line where you add tags to your resource, e.g. `tags = merge(var.default_tags, map("Name", "my-vpc", "Cat", local.cat))`. When you run `terraform apply` you will now deploy resources with the `Cat` tag that has a value of `dev/bar/foo`. If you ever need to change any of your default tags, your `Cat` tag will automatically update along with them.

**NOTE** the declaration and assignment quirk that you assign your local value with `local` and not `locals`.

One interesting thing to observe here is that a typical hash map data structure contains an unsorted list of key/value pairs, but Terraform's maps will always loop through map strings in the same order, so underneath the hood these are being sorted alphabetically. This is good because it means that when you run `terraform plan` or `terraform apply` it won't arbitrarily change your `Cat` tag.
