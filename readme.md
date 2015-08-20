You may want to [read our overview](https://github.com/cftp/vvv-init/wiki).

# How to use this example bootstrap

## Basic setup

1. Add any required additional known hosts to ssh/known_hosts - these will be appended to the known_hosts file in your vagrant box
2. Run a search and replace for `site-name` to whatever the subdomain for your development site will be
3. Run a search and replace for `search-name` to whatever the subdomain for your production site is. This will be used to replace domains in the database
4. Run a search and replace for `site_name` to whatever the database name for your development site will be
5. Run a search and replace for `Site Name` to whatever the human readable name for your development site will be
6. Amend `vvv-init.sh` defining whether the site is a multisite or standalone
7. Remove these initial instructions, leaving the "Development environment bootstrap" heading and everything below it
8. Amend the "Development environment bootstrap" heading and paragraph below so it reflects your purpose for the particular development environment
9. Amend `composer.json` to reflect your project and project dependencies
10. Test everything works as expected in a [VVV](https://github.com/10up/varying-vagrant-vagrants/) context
11. Copy or `git push` to a new repo or new branch in an existing repo
12. Point people towards the `readme.md` in the repo you pushed to, so they can get going

## Using Composer

See [Composer](https://github.com/cftp/vvv-init/wiki/Introduction#composer) and [Private Repos](https://github.com/cftp/vvv-init/wiki/Introduction#private-repos)

The private and public keys are not included in this publically distributed repo, they are in the Private Repository pie/vvv, which you should be using with this vvv-init repo. You will need to add the public key to any private repos that you wish to include.

You will need to include the Composer autoload, so add this near the top of `wp-config.php` (which is a file you may wish to have under version control, separating out the environment specific portion into a non-version controlled `wp-config-local.php`):

```php
// composer
if ( file_exists( __DIR__ . '/wp-content/vendor/autoload.php' ) ) {
	require __DIR__ . '/wp-content/vendor/autoload.php';
}
```

You've then got the `wrapper-composer.sh` and `build-wpengine.sh` scripts available to you.

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

This script is free software, and is released under the terms of the <abbr title="GNU General Public License">GPL</abbr> version 2 or (at your option) any later version. See license.txt.
