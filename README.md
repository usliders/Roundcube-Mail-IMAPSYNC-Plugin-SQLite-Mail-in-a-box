#RCFetchmail

RCFetchmail is a Roundcube plugin, which allows users to download their mail from external mailboxes.

##Prerequisites
1. Roundcube
2. Database (PostgreSQL or MySQL)
3. fetchmail

##Installation
1. First you need to install fetchmail. For Debian you can do so by `sudo apt-get install fetchmail`
2. Next you should extract **RCFetchmail** archive into your Roundcube plugins folder creating "fetchmail" folder there.
3. After that you need to enable newly installed plugin by adding it to Roundcube plugin list. For Debian related config file is `/etc/roundcube/main.inc.php` and relevant setting is 
	```php
	
	$rcmail_config['plugins'] = array();
	
	```
Appending `, 'fetchmail'` to the list of plugins will suffice.
4. You may want to change the limit of external mailboxes per user allowed in `fetchmail/config/config.inc.php`. Default setting is 
	```php
	
	$rcmail_config['fetchmail_limit'] = 10;
	
	```
5. You need to create additional table in your database using one of the supplied `.sql` files. Another possibility is to use postfixadmin's table if you have it installed. 
6. Place `script/fetchmail.pl` to where apropriate. For example to where your mailboxes are, e.g. `/var/mail`.
7. Next adapt `fetchmail.pl` to your config. Most likely you want to change these settings:
	```perl
	# database backend - uncomment one of these
	#our $db_type = 'Pg';
	my $db_type = 'mysql';

	# host name
	our $db_host="127.0.0.1";
	# database name
	our $db_name="postfix";
	# database username
	our $db_username="mail";
	# database password
	our $db_password="CHANGE_ME!";
	```
8. Next step is to configure cron for regular mail checking with `sudo crontab -u mail -e`. For example for 5 minute intervals add this: `*/5 * * * * /var/mail/fetchmail.pl >/dev/null`
9. You might also need to install `liblockfile-simple-perl` and `libsys-syslog-perl` or `libunix-syslog-perl`.
10. Lastly there might be need to do `sudo mkdir /var/run/fetchmail; sudo chown mail:mail /var/run/fetchmail`
