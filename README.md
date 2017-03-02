#Roundcube imapsync plugin

**Roundcube imapsync plugin** is a **Roundcube** plugin, which allows users to sync their mail from external mailboxes incl. IMAP-Folder.

##Prerequisites
1. **Roundcube**
2. Database (**MySQL**)
3. **imapsync** itself

##Installation
1. First you need to install **imapsync** itself. For **Debian** you can do so by `sudo apt-get install imapsync`
2. Next you should extract **Roundcube imapsync plugin** archive into your **Roundcube** `plugins` folder creating "imapsync" folder there.
  * You can do so either by using `composer` for which there is `composer.json`, still you need to follow further installation steps since those could not be accomplished with `composer`
  * Alternatively you can clone this github repo -- `git clone https://github.com/server-gurus/RCimapSync.git`
3. After that you need to enable newly installed plugin by adding it to **Roundcube** plugin list. For **Debian** related config file is `/etc/roundcube/main.inc.php` (for Plesk it is `config.inc.php`) and relevant setting is 
	```php
	
	$config['plugins'] = array('plugin1','plugin2',[...],'imapsync');
	
	```
Appending `, 'imapsync'` to the list of plugins will suffice.
4. Unless default settings are suitable for you, you need to configure the plugin. See the [settings section](#settings) for more information.
5. You need to create additional table in your roundcube database using one of the supplied `.sql` files. 
6. You will need `imapsync.pl` script from /bin/ folder -- coming soon. Place it to where apropriate or let it in his place - your security, your choice.
7. Next adapt `imapsync.pl` to your config. Most likely you want to change these settings:
	```perl
	my $db_host="127.0.0.1";
	my $db_name="postfix";
	my $db_username="mail";
	my $db_password="CHANGE_ME!";
	```
8. Next step is to configure **cron** for regular mail checking with `sudo crontab -u mail -e`. For example for 5 minute intervals add this: `*/5 * * * * /var/mail/imapsync.pl >/dev/null`. Worth noting that even if you configure cron for a 5 minutes interval, imapsync will still abide user configured checking interval. As a result setting bigger intervals here manifests them as intervals available to fetchmail, that is setting `0 * * * *` here overrides any user setting wich is less then hour
9. You might also need to install `liblockfile-simple-perl` and ( `libsys-syslog-perl` or `libunix-syslog-perl` ) on **Debian**-based systems.

##Settings
In case you need to edit default-set settings, you may copy `config.inc.php.dist` to `config.inc.php` and edit setings as desired in the latter file, which will override defaults.
* `$rcmail_config ['imapsync_limit']` limits the number of external mailboxes per user allowed. Default is `10`.
* `$rcmail_config ['imapsync_folder']` whether to allow users to specify IMAP folder they wish to download mail from. Default is `false`.

##License
This software distributed under the terms of the GNU General Public License as published by the Free Software Foundation

Further details on the GPL license can be found at http://www.gnu.org/licenses/gpl.html

By contributing to **Roundcube imapsync plugin**, authors release their contributed work under this license

##Acknowledgements
###Original author

Arthur Mayer, https://github.com/flames (fork)
Christian Nowak, https://github.com/chr1sn0
Christian Bischoff, https://github.com/DaCHRIS

###List of contributors

For a complete list of contributors, refer to [Github project contributors page](https://github.com/server-gurus/RCimapSync/graphs/contributors)

####Currently maintained by
* [servergurus](https://github.com/server-gurus)
