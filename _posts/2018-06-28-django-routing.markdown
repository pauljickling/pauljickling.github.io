---
layout: post
title: "Setting up Routes in Django"
date: 2018-06-28
---

As mentioned in my last post, I'm currently developing an admin component using Django. Django is a highly opinionated (in a good way) framework that has an extremely powerful built-in admin component. As the Django tutorial puts it when it introduces the admin component:

> Generating admin sites for your staff or clients to add, change, and delete content is tedious work that doesn’t require much creativity. For that reason, Django entirely automates creation of admin interfaces for models.

So that's great. You create your models, import your initial data, and Django handles the rest. If that were all we were doing we could just call it a day. However our admin component requires interaction with several different types of users, and Django's admin component is designed to be used by site managers only, not site visitors.

The solution to this is to create a url route that site visitors can go to to fill out some form data, which gets passed to the database, which is then also passed onto the admin component.

Coming from Express, setting up a route in Django was a little more confusing than I first expected. Here's what a route would look like in Express:

```
app.get("/", function(req, res) {
  res.render("home");
});
```

This is a nice, succinct expression. It has the HTTP method with parameters containing the name of the route, and an anonymous function with request and response parameters. Then, assuming you are using some sort of view engine, you render the page you have in mind.

Django, on the other hand, is slightly more involved.

In Django you define your routes in the urls.py file, but you are probably going to have several of those files. One in the directory with your project's title (I'll call this the root directory, even though that isn't strictly accurate, since it contains the settings file used to configure your Django application), and then in each separate app that you generate. So the urls.py file in the root directory needs to point to the other urls.py files. That will look like: `path('', include('app.urls'))`. Then, you specify the routes in the urls.py file in the app directory.
`path('foo'), views.foo, name='foo'),`. After you do that you need to write a function in your views.py file that handles the actual HTTP request.

```
def foo(request):
    return render(request, 'foo/index.html')
```

Finally, you need to create a templates directory, create a subfolder with the name foo in that directory, which will contain an index.html file for your foo route.

What's going on here is simply that in Django the actual routing and the HTTP requests and responses are handled separately. This is how most opinionated frameworks are setup. The difference is that when you're using Ember or Ruby on Rails you can generate these routes from the command line, and it configures the 3 or so files that are affected by a new route. With Django you need to handle all of this manually.

The other part that makes Django routing slightly confusing is most of the documentation I've seen about routing makes heavy use of RegEx. Now, RegEx is great, but in my experience it is also difficult for most people to parse.

So which approach is better? Neither. Express apps have their own problems where sometimes the app.js file turns into a monster monolithic structure with 10,000 lines of code that is extremely complicated to reason about. Meanwhile the full fledged frameworks of the world are going to be overkill for a simple, single-page application. This is the challenging part of being a developer. We want to find the right tools for the job. But learning the advantages and limitations of a particular tool is time consuming, and there are so many different tools available to us. Realistically we can't learn every single stack permutation. The best we can do is to keep learning new things, and keep our minds open to new possibilities.
