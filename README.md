#Roundcube fetchmail plugin

**Roundcube fetchmail plugin** is a **Roundcube** plugin, which allows users to download their mail from external mailboxes.

##Screenshot
![Screenshot](http://pf4public.github.io/fetchmail/images/scrn.PNG)

##Prerequisites
1. **Roundcube**
2. Database (**PostgreSQL** or **MySQL**)
3. **fetchmail** itself
4. **Postfix Admin** provides convenient `fetchmail.pl` script

##Installation
1. First you need to install **fetchmail** itself. For **Debian** you can do so by `sudo apt-get install fetchmail`
2. Next you should extract **Roundcube fetchmail plugin** archive into your **Roundcube** `plugins` folder creating "fetchmail" folder there.
3. After that you need to enable newly installed plugin by adding it to **Roundcube** plugin list. For **Debian** related config file is `/etc/roundcube/main.inc.php` and relevant setting is 
	```php
	
	$rcmail_config ['plugins'] = array();
	
	```
Appending `, 'fetchmail'` to the list of plugins will suffice.
4. You may want to change the limit of external mailboxes per user allowed in `fetchmail/config/config.inc.php`. Default setting is 
	```php
	
	$rcmail_config ['fetchmail_limit'] = 10;
	
	```
5. You need to create additional table in your database using one of the supplied `.sql` files. Another possibility is to use **Postfix Admin** table if you have it installed. If using **PostgreSQL** you may use schemas to share `fetchmail` table between **Roundcube** and **Postfix Admin**. Namely creating it in `public` schema, whereas every other table in it's appropriate schema, like `roundcube` and `postfixadmin`. Please refer to [the documentation](http://www.postgresql.org/docs/current/static/ddl-schemas.html) for more information.
6. You will need `fetchmail.pl` script from **Postfix Admin** distribution. If you don't have **Postfix Admin** installed, you can obtain required `fetchmail.pl` script from their repo  [trunk / ADDITIONS / fetchmail.pl](https://sourceforge.net/p/postfixadmin/code/HEAD/tree/trunk/ADDITIONS/fetchmail.pl). But be sure to get at least revision [[r1766]](https://sourceforge.net/p/postfixadmin/code/1766/), at which proper handling of `active` field introduced. Place it to where apropriate. For example, where your mailboxes are, e.g. `/var/mail`.
7. Next adapt `fetchmail.pl` to your config. Most likely you want to change these settings:
	```perl
	# database backend - uncomment one of these
	our $db_type = 'Pg';
	#my $db_type = 'mysql';
	
	# host name
	our $db_host="127.0.0.1";
	# database name
	our $db_name="postfix";
	# database username
	our $db_username="mail";
	# database password
	our $db_password="CHANGE_ME!";
	```
8. Next step is to configure **cron** for regular mail checking with `sudo crontab -u mail -e`. For example for 5 minute intervals add this: `*/5 * * * * /var/mail/fetchmail.pl >/dev/null`
9. You might also need to install `liblockfile-simple-perl` and `libsys-syslog-perl` or `libunix-syslog-perl` on **Debian**-based systems.
10. Lastly there might be need to do `sudo mkdir /var/run/fetchmail; sudo chown mail:mail /var/run/fetchmail`

##License
This software distributed under the terms of the GNU General Public License as published by the Free Software Foundation

Further details on the GPL license can be found at [http://www.gnu.org/licenses/gpl.html](http://www.gnu.org/licenses/gpl.html)

By contributing to **Roundcube fetchmail plugin**, authors release their contributed work under this license

##Acknowledgements
####Original developer

Arthur Mayer, a.mayer@citex.net

####List of contributors

* puzich, https://github.com/puzich
* PF4Public, https://github.com/PF4Public
