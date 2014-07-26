# How to use this example bootstrap

1. Run a search and replace for `site-name` to whatever the domain for your site will be
2. Run a search and replace for `database_name` to whatever the database name for your development site will be
3. Run a search and replace for `Site Name` to whatever the human readable name for your development site will be
4. Remove these initial instructions, leaving the "Development environment bootstrap" heading and everything below it
5. Amend the "Development environment bootstrap" heading and paragraph below so it reflects your purpose for the particular development environment
6. Amend `composer.json` to reflect your project and project dependencies
7. Test everything works as expected in a [VVV](https://github.com/10up/varying-vagrant-vagrants/) context
8. Copy or `git push` to a new repo or new branch in an existing repo
9. Point people towards the `readme.md` in the repo you pushed to, so they can get going

# Development environment bootstrap

This site bootstrap is designed to be used with [Varying Vagrants Vagrant](https://github.com/10up/varying-vagrant-vagrants/) and a WordPress single site, running in a `wp` sub-directory.

To get started:

1. If you don't already have it, clone the [Vagrant repo](https://github.com/10up/varying-vagrant-vagrants/) (perhaps into your `~/Vagrants/` directory, you may need to create it if it doesn't already exist)
2. Install the Vagrant hosts updater: `vagrant plugin install vagrant-hostsupdater`
3. Clone this branch of this repo into the `www` directory of your Vagrant as `site-name`
4. If your Vagrant is running, from the Vagrant directory run `vagrant halt`
5. Followed by `vagrant up --provision`.  Perhaps a cup of tea now? The initial provisioning may take a while.


Then you can visit:
* [http://local.site-name/](http://local.site-name/)

