---
layout: post
title: "Verify DNS Ownership with TXT Records"
date: 2022-05-27
---

The transfer of domain name ownership from one registrar can potentially be quite complicated depending on the nature of the transfer, and there are a lot of things to keep an eye out for. Then once you initiate a transfer, it can take a few days to complete.

An easy way to verify that you have ownership of a transferred domain without wanting to disrupt any web traffic is to create a TXT record to act as a basic proof that you have the ability to create, alter, and destroy DNS records.

When I want to get some basic DNS information about a domain, nslookup is a common tool I go to. A typical query will be something like `nslookup example.com`. However you can also just type `nslookup` and go into interactive mode. In interactive mode you can type `set q={DNS Record Type}` and then query a domain name to get information about that specific record type. 

So if you create a TXT record in the foo subdomain with a value of "bar" you can do the following:

```
nslookup
$ set q=TXT
foo.example.com
```

And if you do in fact own the domain, it will return the value of "bar". This is a handy sanity check when you want to confirm that a transfer happened correctly.
