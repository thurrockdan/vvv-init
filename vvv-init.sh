#!/bin/bash
# Just a human readable description of this site
SITE_NAME="Wordpress Dev"
# The name (to be) used by MySQL for the DB
DB_NAME="wordpress-dev"
# Values for searching and replacing
SEARCHDOMAIN="wordpress-dev"
REPLACEDOMAIN="local.wordpress-dev"
# Wordpress multisite network (true/false)
MULTISITE=false
# Append additional config to wp-config.php
EXTRA_CONFIG="
// No extra config, but if there was it would go here.
"

# ----------------------------------------------------------------
# You should not need to edit below this point. Famous last words.

echo "---------------------------"
echo "Commencing $SITE_NAME setup"


mkdir -p ~/.ssh
touch ~/.ssh/known_hosts
IFS=$'\n'
for KNOWN_HOST in $(cat "ssh/known_hosts"); do
	if ! grep -Fxq "$KNOWN_HOST" ~/.ssh/known_hosts; then
	    echo "Adding host to SSH known_hosts for user 'root': $(echo $KNOWN_HOST |cut -d '|' -f1)"
	    echo $KNOWN_HOST >> ~/.ssh/known_hosts
	fi
done


# Run Composer
echo "Running Composer to download dependencies"
composer install --prefer-dist

#Multi site configuration
if $MULTISITE; then
	MULTISITE_CONFIG="
	define('WP_ALLOW_MULTISITE', true);
	//define('MULTISITE', true);
	//define('SUBDOMAIN', true);
	//define('DOMAIN_CURRENT_SITE', '$REPLACEDOMAIN');
	//define('PATH_CURRENT_SITE', '/');
	//define('SITE_ID_CURRENT_SITE', 1);
	//define('BLOG_ID_CURRENT_SITE', 1);
"
	echo "WP Multisite settings saved"
else
	MULTISITE_CONFIG=""
	echo "$SITE_NAME is not a WP multisite..."
fi

# Let's get some config in the house
if [ ! -f public_html/wp-config.php ]; then
	echo "Creating wp-config.php and moving it up into public_html because we like it there"
	wp core config --dbname="$DB_NAME" --dbuser=wp --dbpass=wp --dbhost="localhost" --extra-php <<PHP
	define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/wp-content' );
	define( 'WP_CONTENT_URL', '$SITE_URL/wp-content' );
	define( 'WP_DEBUG', true );
	define( 'WP_DEBUG_LOG', true );
	define('WP_DEBUG_DISPLAY', false);
	define('SAVEQUERIES', true);
$EXTRA_CONFIG
$MULTISITE_CONFIG
PHP
	mv public_html/wp/wp-config.php public_html/wp-config.php
else
	echo "wp-config.php already exists"
fi
# Move index.php and change path to blog-header so that we can run WordPress in a sub-directory
if [ ! -f public_html/index.php ]; then

	echo "Copying index.php and moving it up into public_html because we like it there"

	cp public_html/wp/index.php public_html/index.php
	sed -i -e "s/wp-blog-header.php/wp\/wp-blog-header.php/g" public_html/index.php
else
	echo "index.php already exists"
fi

# Make a database, if we don't already have one
DATA_IN_DB=`mysql -u root --password=root --skip-column-names -e "SHOW TABLES FROM $DB_NAME;"`
if [ "" == "$DATA_IN_DB" ]; then
	echo "Creating database (if it's not already there)"
	mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"
	mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO wp@localhost IDENTIFIED BY 'wp';"

	if [ -f $DB_NAME.sql ]; then
		echo "Importing DB content from dump file"

		wp db import $DB_NAME.sql
		wp search-replace "$SEARCHDOMAIN" "$REPLACEDOMAIN"
	elif ! $(wp core is-installed ); then
		echo "Installing initial WordPress DB tables"
		wp core install --title=$SITE_NAME --admin_user=admin --admin_password=password --admin_email=admin@no.reply
		wp option update siteurl "$SITE_URL\/wp"

	fi
else
	echo "database $DB_NAME already exists and has data"
fi


# The Vagrant site setup script will restart Nginx for us

echo "$SITE_NAME init is complete";
