# Rails Generators

If you go down the list on all of the tasks necessary to build out CRUD functionality in an application, it's quite extensive. From creating database tables, configuring views, and drawing individual routes, the feature builds can be time consuming and bug prone. Wouldn't it be nice if there was a more efficient way of integrating standard features instead of having to build them manually each time?

A primary goal of the Rails team was to make it efficient to build core application functionality. The Rails system has a number of generators that will do some of the manual work for us.

As nice as it is to use the generators to save time, they also provide some additional extra benefits:

* They can setup some basic specs for an application's test suite. They won't write our complex logic tests for us, but they will provide some basic examples.

* They are setup to work the same way each time. This helps standardize your code and enables your development to be more efficient since you don't have to worry as much about bugs related to spelling, syntax errors, or anything else that can occur when writing code manually.

* They follow Rails best practices, which includes utilizing RESTful naming patterns, removing duplicate code, using partials and a number of other best of breed design patterns (if you don't know what all of these are, don't worry, we will cover them shortly).


## Abusing Generators

So if generators are so amazing, why wouldn't we always want to use them? I'll answer your question with another question: a chainsaw is a wonderful tool, so why wouldn't you use it for every job you have around the house? The answer to both questions is the same: great tools are only great tools if they are matched with the right task. In the same way that you should only use a chainsaw when you have a job that requires it, generators should only be used when they are needed.

Extending our example from above, why wouldn't you use a chainsaw to build a model airplane?

![Chainsaw Example](https://s3.amazonaws.com/flatiron-bucket/readme-lessons/chainsaw_example.jpg)

In the same manner as our chainsaw example, certain generators create quite a bit of code. If that code is not going to be used, it will needlessly clutter the application code and cause confusion for future developers. One of our instructors recounts the following all-too-familiar anecdote:
>A few years ago I took over as the lead developer for a large legacy Rails application. The previous developer had relied on generators, even when they shouldn't have been used, and the end result was that it took months to simply figure out what code was being used and what was 'garbage' code that simply came from the generators.

So when is the right time to use a generator? After we've gone over the actions of each of the generators, the answer to this query should become readily apparent. In addition, we'll walk through some case studies to help understand when each type of generator is beneficial.


## Rails Generate

All of the Rails generators are entered as commands into the terminal and will follow this syntax:

```
rails generate <name of generator> <options> --no-test-framework
```

`--no-test-framework` is a flag that tells the generator not to create any tests for the newly-generated models, controllers, etc. When you're working on your own Rails applications, you don't need the flag — it's quite helpful for quickly stubbing out a test suite. However, it's necessary for Learn.co labs because we don't want Rails adding additional tests on top of the test suite that already comes with the lesson.

For efficiency's sake, Rails aliased the `generate` method to `g`, so the CLI command above could be shortened to:

```
rails g <name of generator> <options> --no-test-framework
```

## Different types of generators

Below are the main generators that Rails offers. We'll go through examples of each:

* Migrations
* Models
* Controllers
* Resources


## Migration Generators

Up to this point, we've been creating our migrations by hand. This has been beneficial because it's important to understand how migrations work. However, Rails has a great set of migration generators with conventions that can help make managing the database schema very efficient.

Let's start using database migrations in our case study application and update the `posts` table. To add a new column called `published_status`, we can use the following command:

```
rails g migration add_published_status_to_posts published_status:string --no-test-framework
```

In the terminal you will see it creates a migration file for us: `db/migrate/20151127174031_add_published_status_to_posts.rb`. Since migration file names need to be unique, the generator prepends a timestamp before the file name. In the case of the migration I just ran, it added `20151127174031`. You can break this timestamp down as follows: `year: 2015, month: 11, date: 27, and then the time itself`.

Ready to see something pretty cool? Open up the file it created, which you can find in the `db/migrate` directory. It should look something like this:

```ruby
class AddPublishedStatusToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_status, :string
  end
end
```

Notice what the generator did? It automatically knew that we wanted to add a new column and built out the `add_column` method call. How did this happen? It turns out that the way that you name the migration file is very important. By prepending the `add_` text to the name it gave a signal to the migration generator that the purpose of this schema change will be to add a column(s) to the table. How did it know the table we wanted to add to? By appending the `_posts` text to the end of the migration name it tells Rails that the table we want to change is the `posts` table. Lastly, by adding the `published_status:string` text at the end of the command tells the generator that the new column name will be `published_status` and the data type will be of type `string`.

To update the database schema you can run `rake db:migrate` and the schema will reflect the change.

Oh no, we made a mistake, let's get rid of that column name with another migration:

```
rails g migration remove_published_status_from_posts published_status:string --no-test-framework
```

If you open up this migration file, you will see the following code:

```ruby
class RemovePublishedStatusFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :published_status, :string
  end
end
```

So we can add and remove columns automatically by running migration generators. What else can we do? Let's walk through a real world scenario:

```
rails g migration add_post_status_to_posts post_status:boolean --no-test-framework
```

With this migration we'll add the column `post_status` with the data type of boolean. While adding this new attribute to one of the forms we discover that the column really needs to be of type `string` instead of being a `boolean`. Let's see if we can use the same syntax for the generator:

```
rails g migration change_post_status_data_type_to_posts post_status:string --no-test-framework
```

This won't automatically create the `change_column` method; the file will look something like this:

```ruby
class ChangePostStatusDataTypeToPosts < ActiveRecord::Migration
  def change
  end
end
```

We can simply add in the `change_column` method like this: `change_column :posts, :post_status, :string` and after running `rake db:migrate` our schema will be updated.

[Full migration documentation](http://api.rubyonrails.org/classes/ActiveRecord/Migration.html)


# Model Generators

This is a generator type that gets used regularly. It does a great job of creating the core code needed to create a model and associated database table without adding a lot of bloat to the application. Let's add a new model to the app called `Author` with columns `name` and `genre`, we can use the model generator with the following CLI command:

```
rails g model Author name:string genre:string bio:text --no-test-framework
```

Running this generator will create the following files for us:

```
invoke  active_record
create    db/migrate/20190618010724_create_authors.rb
create    app/models/application_record.rb
create    app/models/author.rb
```

At a high level, this has created:
* A database migration that will add a table and add the columns `name`, `genre`, and `bio`.
* A model file that will inherit from `ApplicationRecord` (as of Rails 5)

**Note:** Up to Rails 4.2, all models inherited from `ActiveRecord::Base`. Since Rails 5, all models inherit from `ApplicationRecord`. If you've have used an older version of Rails in the past, you may be wondering what happened to `ActiveRecord::Base`? Well, not a lot has changed, actually. This file is automatically added to models in Rails 5 applications:

```ruby
# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
```

It allow more flexibility if you want to add some extra functionality to Active Record.

To continue with the code-along, after running `rake db:migrate` it will add the table to the database schema. Let's test this out in the console:

```
Author.all
=> #<ActiveRecord::Relation []>

Author.create!(name: "Stephen King", genre: "Horror", bio: "Bio details go here")
=> #<Author id: 1, name: "Stephen King", genre: "Horror", bio: "Bio details go here", created_at: "2015-11-27 22:59:14", updated_at: "2015-11-27 22:59:14">
```

So it looks like our model has been created properly. As you can see, this particular generator created a few different pieces of functionality with a single command, and it did it with creating minimal code bloat.


## Controller Generators

Controller generators are great if you are creating static views or non-CRUD related features (we'll walk through why this is the case shortly). Let's create an `admin` controller that will manage the data flow and view rendering for our admin dashboard pages:

```
rails g controller admin dashboard stats financials settings --no-test-framework
```

This will create a ton of code! Below is the full list:

```
create  app/controllers/admin_controller.rb
 route  get 'admin/settings'
 route  get 'admin/financials'
 route  get 'admin/stats'
 route  get 'admin/dashboard'
invoke  erb
create    app/views/admin
create    app/views/admin/dashboard.html.erb
create    app/views/admin/stats.html.erb
create    app/views/admin/financials.html.erb
create    app/views/admin/settings.html.erb
invoke  helper
create    app/helpers/admin_helper.rb
invoke  assets
invoke    coffee
create      app/assets/javascripts/admin.js.coffee
invoke    scss
create      app/assets/stylesheets/admin.css.scss
```

So what got added here? Below is a list that is a little more high level:

* A controller file that will inherit from `ApplicationController`

* A set of routes to each of the generator arguments: `dashboard`, `stats`, `financials`, and `settings`

* A new directory for all of the view templates along with a view template file for each of the controller actions that we declared in the generator command

* A view helper method file

* A Coffeescript file for specific JavaScripts for that controller

* A `scss` file for the styles for the controller

As you can see, this one generator created a large number of files and code. This is a generator to be careful with – it can create a number of files that are never used and can cause wasted files in an application.

So why are controller generators not the best for creating CRUD based features? What would have happened if we wanted to create a controller that managed the CRUD flow for managing accounts? Here would be one implementation:

```
rails g controller accounts new create edit update destroy index show --no-test-framework
```

Immediately you may notice that this would create wasted code since it would create view templates for `create`, `update`, and `destroy` actions, so they would need to be removed immediately. They would also be setup with `get` HTTP requests, which would not work at all. In the next section we're going to cover a better option for creating CRUD functionality.


## Resource Generators

If you are building an API, using a front end MVC framework, or simply want to manually create your views, the `resource` generator is a great option for creating the code. Since we didn't create the `Account` controller we mentioned before, let's build it here:

```
rails g resource Account name:string payment_status:string --no-test-framework
```

This creates quite a bit of code for us. Below is the full list:

```
invoke  active_record
create    db/migrate/20170712011124_create_accounts.rb
create    app/models/account.rb
invoke  controller
create    app/controllers/accounts_controller.rb
invoke    erb
create      app/views/accounts
invoke    helper
create      app/helpers/accounts_helper.rb
invoke    assets
invoke      coffee
create        app/assets/javascripts/accounts.js.coffee
invoke      scss
create        app/assets/stylesheets/accounts.css.scss
invoke  resource_route
 route    resources :accounts
```

So what does our app have now due to the generator? Below is a summary:

* A migration file that will create a new database table for the attributes passed to it in the generator

* A model file that inherits from `ActiveRecord::Base`

* A controller file that inherits from `ApplicationController`

* A view directory, but no view template files

* A view helper file

* A Coffeescript file for specific JavaScripts for that controller

* A `scss` file for the styles for the controller

* A full `resources` call in the `routes.rb` file

The `resource` generator is a smart generator that creates some of the core functionality needed for a full featured resource without much code bloat. Looking over the files I can't find one file that I need to remove, so that's a good sign.

The last item that was added may not look familiar to you. `resources :accounts` is considered a 'magic' route that entails the full set of RESTful routes needed to perform CRUD in an application. So what does `resources :accounts` translate into?

There's an easy way to find out. Let's run `rake routes` with a filter so it only shows us the routes for accounts:

```
rake routes | grep account
```

This `rake` command will produce the following output in the console:

```
accounts      GET    /accounts(.:format)          accounts#index
              POST   /accounts(.:format)          accounts#create
new_account   GET    /accounts/new(.:format)      accounts#new
edit_account  GET    /accounts/:id/edit(.:format) accounts#edit
account       GET    /accounts/:id(.:format)      accounts#show
              PATCH  /accounts/:id(.:format)      accounts#update
              PUT    /accounts/:id(.:format)      accounts#update
              DELETE /accounts/:id(.:format)      accounts#destroy
```

`resources` automatically creates each of these routes and makes them available to the controller. If you open up the `accounts_controller.rb` file you may notice something interesting: none of the actions shown in the route list are even there! However, I actually like this because it creates the minimal amount of code possible and then lets me add only the features that the app needs. We'll get into a full review of each of the options available with the `resources` method in a later lesson. For right now just know that by default it creates the full suite of CRUD routes.

## Video Review

* [Intro to Rails](https://www.youtube.com/watch?v=KKQ8lpEyw2g)

## Resources

[Rails Generators](http://api.rubyonrails.org/classes/Rails/Generators.html)

<p class='util--hide'>View <a href='https://learn.co/lessons/rails-generators-readme'>Rails Generators</a> on Learn.co and start learning to code for free.</p>
