---
layout: post
title: "In-Place Resizing for Digitalocean Droplets"
date: 2023-12-05
---

Terraform is great for maintaining inventory, but I haven't always had the best luck with using Terraform to maintain existing state of a VM while upgrading to a more powerful instance. In cases like this, it can be more prudent to work with a cloud provider's CLI tools to perform an in-place resizing, and then update the Terraform config, and run `terraform plan` to confirm that the Terraform config matches existing state. For this example, I'll be using Digitalocean as an example, although the process should be similar regardless of cloud provider.

To use Digitalocean's CLI tools you'll need to download `doctl`, which you can find instructions for [here](https://docs.digitalocean.com/reference/doctl/how-to/install/).

Once you have `doctl` installed, and have an API key with the authorization to perform the operations, the first thing you'll want is an inventory of all the droplets you need to upgrade.

`doctl compute droplet list --format ID,Name --no-header > inventory`

This is going to create a list of every droplet in the account you are working with. It's possible to limit this with the `--region` flag, but otherwise I don't know anyway to filter it, so unless you are planning to resize every single droplet, you need to go through the inventory and delete lines for droplets you aren't planning to resize.

Now that you have the inventory you're working with we'll want to do the following:

1. Power off the droplets
2. Create a snapshot image (in case something goes wrong)
3. Perform the resize operation
4. power on the droplets

In a bash script you can create arrays with your `droplet_ids` and `droplet_names` fields from your inventory.

Then you have two approaches to these operations. You can either perform them all the operations in a loop sequentially by adding the `--wait` flag to each `doctl` operation. This makes a certain amount of sense because these operations do need to happen in a specific order. You want to power off your droplet before creating a snapshot, and you must do that before the resize operation. And you want the snapshot created before you resize in case something goes wrong. And only after all of that is done do you turn the droplet back on. This is probably a good approach if you're just resizing a handful of droplets, but if you are upgrading a whole suite you'll be waiting a really long time for your script to run because, with the exception of powering the droplets back on, all of these operations are time intensive. So it may make more sense to simply comment out the subsequent operations in the loop, and update them once you've confirmed that the previous operations have completed.

```bash
for i in $(seq 0 n) ; do
    doctl compute droplet-action power-off "${droplet_ids[i]}"
    # doctl compute droplet-action snapshot "${droplet_ids[i]}" --snapshot-name "${droplet_names[i]}-$(date +%Y%m%d%H%M%S)"
    # doctl compute droplet-action resize "${droplet_ids[i]}" --size "$slug"
    # doctl compute droplet-action power-on "${droplet_ids[i]}"
done
```

In this example you would replace `n` with the number of droplets in your inventory - 1.

As you can see the first operation is to power everything off. The next time we run the script we comment off the power-off operation, and uncomment the snapshot option. The snapshot operation has a required flag of `--snapshot-name` where we provide the name of the droplet and a basic timestamp.

Snapshots are one of the more time consuming operations here. Expect those to take at least ten minutes to complete, possibly much more depending on the disk size involved.

Next commet out the snapshot operation, and uncomment the resize. Note here we are using a variable for the slug value. You can retrieve a list of valid slug values with the `doctl compute size list` command. Also note that by default in digitalocean resize operations do not increase disk by default. If you did want to resize the disk to the new slug's value you can add the `--resize-disk` flag, but make sure that's something you actually want to do because that will make the resize operation non-reversible.

Finally, once the resize operations are complete, comment out the line, and uncomment the power-on line. After you run that you should have all your droplets working with their existing state, but with more powerful hardware. You can now check to confirm that your droplets are working as intended. If not you have the snapshots which you can reload from.
