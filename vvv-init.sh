#!/bin/bash
SITE_NAME="Site Name"
DB_NAME="database_name"
SITE_URL="http://local.site-name"


echo "Commencing setup for $SITE_NAME"

# Run Composer
echo "Running Composer to download dependencies"
composer install --prefer-dist

if [ ! -f public_html/wp-config.php ]
	then
	echo "Creating wp-config.php and moving it up into public_html because we like it there"

	wp core config --dbname="$DB_NAME" --dbuser=wp --dbpass=wp --dbhost="localhost" --dbprefix="wp_"  --extra-php <<PHP
	define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/wp-content' );
	define( 'WP_CONTENT_URL', '$SITE_URL/wp-content' );
	define( 'WP_DEBUG', true );
	define( 'WP_DEBUG_LOG', true );
	define('WP_DEBUG_DISPLAY', false);
	define('SAVEQUERIES', true);

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
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO wp@localhost IDENTIFIED BY 'wp';"

if [ -f $DB_NAME.sql ]; then
	echo "Importing DB content from dump file"

	wp db import $DB_NAME.sql

elif ! $(wp core is-installed ); then
	echo "Installing initial WordPress DB tables"
	wp core install --title=$SITE_NAME --admin_user=admin --admin_password=password --admin_email=admin@no.reply
	wp option update siteurl "$SITE_URL\/wp"
fi



# The Vagrant site setup script will restart Nginx for us

echo "$SITE_NAME site now installed";
