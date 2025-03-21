
# RCimapSync for MIAB with Roundcube and SQLite 🚀

This fork of the RCimapSync plugin allows you to synchronize mail from external mailboxes in the **Mail-in-a-Box (MIAB)** system using **Roundcube** and the **SQLite** database. Follow these steps to install and configure the plugin. 🎉

---

## 📋 Table of Contents

Before you begin

Backup: Regularly create backups of the SQLite database:
  ```bash
  cp /home/user-data/mail/roundcube/roundcube.sqlite ~/Backup/
  ```

1. [Environment Preparation](#1-environment-preparation-🛠️)
2. [Dependency Installation](#2-dependency-installation-📦)
3. [Installation of imapsync Utility](#3-installation-of-imapsync-utility-📨)
4. [Plugin Download and Installation](#4-plugin-download-and-installation-🔌)
5. [SQLite Configuration](#5-plugin-configuration-for-sqlite-🔧)
6. [Creating a Table in SQLite](#6-creating-a-table-in-sqlite-🗃️)
7. [Configuring imapsync.pl Script](#7-configuring-imapsyncpl-script-⚙️)
8. [Setting Permissions](#8-setting-permissions-🔐)
9. [Testing Synchronization](#9-testing-synchronization-🧪)
10. [Automating Synchronization](#10-automating-synchronization-🤖)
11. [Publishing the Fork](#11-publishing-the-fork-🚢)

---

## 1. Environment Preparation 🛠️

**Goal**: Ensure the MIAB system is ready for plugin installation.

- Update the system:
  ```bash
  sudo apt-get update
  sudo apt-get upgrade -y
  ```
  **Verification**:
  ```bash
  echo $?  # Should output 0
  ```
  Ensure Roundcube is running: open `https://your-domain.com/mail` in your browser.

---

## 2. Dependency Installation 📦

**Goal**: Install necessary packages and modules.

1. Install packages via apt:
   ```bash
   sudo apt-get install -y cpanminus git makepasswd rcs perl-doc    libio-tee-perl libmail-imapclient-perl libdigest-md5-file-perl 
   libterm-readkey-perl libfile-copy-recursive-perl build-essential 
   make automake libunicode-string-perl libauthen-ntlm-perl 
   libcrypt-ssleay-perl libdigest-hmac-perl libio-compress-perl 
   libio-socket-inet6-perl libio-socket-ssl-perl libmodule-scandeps-perl 
   libnet-ssleay-perl libpar-packer-perl libreadonly-perl 
   libtest-pod-perl libtest-simple-perl liburi-perl 
   libencode-imaputf7-perl libfile-tail-perl libproc-processtable-perl 
   libregexp-common-perl libsys-meminfo-perl libtest-deep-perl libdbd-sqlite3-perl
   ```

   **Verification**:
   ```bash
   dpkg -l | grep libencode-imaputf7-perl
   ```

2. Install Perl modules via cpanm:
   ```bash
   sudo cpanm -i JSON::WebToken Test::MockObject Unicode::String Data::Uniqid
   ```

   **Verification**:
   ```bash
   perl -MJSON::WebToken -e 'print "OK
"'
   ```

---

## 3. Installation of imapsync Utility 📨

**Goal**: Install imapsync for mail synchronization.

```bash
cd /tmp
git clone https://github.com/imapsync/imapsync.git
cd imapsync
mkdir dist
make install
```

**Verification**:
```bash
which imapsync  # Should output /usr/local/bin/imapsync
```

---

## 4. Plugin Download and Installation 🔌

**Goal**: Install the RCimapSync plugin fork.

```bash
cd /usr/local/lib/roundcubemail/plugins
git clone https://github.com/usliders/Roundcube-Mail-IMAPSYNC-Plugin-SQLite-Mail-in-a-box.git imapsync
```

**Verification**:
```bash
ls -l /usr/local/lib/roundcubemail/plugins/imapsync
```

---

## 5. Plugin Configuration for SQLite 🔧

**Goal**: Adapt the plugin to work with SQLite.

1. Open the configuration file:
   ```bash
   mcedit /usr/local/lib/roundcubemail/plugins/imapsync/bin/config.conf
   ```

2. Specify the database path:
   ```php
   $db_file = "/home/user-data/mail/roundcube/roundcube.sqlite";
   ```

**Path Verification**:
```bash
ls -l /home/user-data/mail/roundcube/roundcube.sqlite
```

---

## 6. Creating a Table in SQLite 🗃️

**Goal**: Create a table to store settings.

  6.1. Connect to the database:
   ```bash
   sqlite3 /home/user-data/mail/roundcube/roundcube.sqlite
   ```

  6.2. Execute the SQL query:
   ```sql
   CREATE TABLE IF NOT EXISTS imapsync (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       mailbox TEXT NOT NULL,
       active INTEGER NOT NULL DEFAULT 1,
       src_server TEXT NOT NULL,
       src_auth TEXT NOT NULL DEFAULT 'password',
       src_user TEXT NOT NULL,
       src_password TEXT NOT NULL,
       src_folder TEXT NOT NULL,
       dest_password TEXT NOT NULL,
       poll_time INTEGER NOT NULL DEFAULT 10,
       fetchall INTEGER NOT NULL DEFAULT 0,
       keep INTEGER NOT NULL DEFAULT 1,
       protocol TEXT NOT NULL DEFAULT 'IMAP',
       subscribeall INTEGER NOT NULL DEFAULT 1,
       skipempty INTEGER NOT NULL DEFAULT 1,
       maxage INTEGER NOT NULL DEFAULT 365,
       usessl INTEGER NOT NULL DEFAULT 1,
       sslcertck INTEGER NOT NULL DEFAULT 0,
       sslcertpath TEXT,
       sslfingerprint TEXT,
       extra_options TEXT,
       returned_text TEXT,
       mda TEXT NOT NULL DEFAULT '',
       date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
   );
   ```

**Verification**:
```bash
sqlite3 /home/user-data/mail/roundcube/roundcube.sqlite ".tables"
```

---

## 7. Configuring imapsync.pl Script ⚙️ - Optional

**Goal**: Adapt the script for SQLite.

1. Open the script file:
   ```bash
   mcedit /usr/local/lib/roundcubemail/plugins/imapsync/bin/imapsync.pl
   ```

2. Ensure correct database connection:
   ```perl
   my $DBH = DBI->connect("DBI:SQLite:dbname=$Conf::db_file", "", "") || &log_and_die("cannot connect to database");
   ```

---

## 8. Setting Permissions 🔐

**Goal**: Set the correct permissions.

```bash
sudo chown www-data:www-data /home/user-data/mail/roundcube/roundcube.sqlite
sudo chmod 660 /home/user-data/mail/roundcube/roundcube.sqlite
sudo chown -R www-data:www-data /usr/local/lib/roundcubemail/plugins/imapsync
```

**Verification**:
```bash
ls -l /home/user-data/mail/roundcube/roundcube.sqlite
```

---

## 9. Testing Synchronization 🧪

**Goal**: Verify synchronization functionality.

```bash
sudo -u www-data /usr/bin/perl /usr/local/lib/roundcubemail/plugins/imapsync/bin/imapsync.pl
```

or simply

```bash
cd /usr/local/lib/roundcubemail/plugins/imapsync/bin
perl ./imapsync.pl
```

**Log Verification**:
```bash
sudo tail -f /var/log/syslog | grep imapsync
sudo cat /usr/local/lib/roundcubemail/plugins/imapsync/bin/LOG_imapsync/imapsync.log
```

---

## 10. Automating Synchronization 🤖

**Goal**: Set up automatic execution.

1. Add a cron job:
   ```bash
   sudo crontab -e -u www-data
   ```

2. Insert the line:
   ```cron
   */30 * * * * /usr/bin/perl /usr/local/lib/roundcubemail/plugins/imapsync/bin/imapsync.pl
   ```

**Verification**:
```bash
sudo crontab -l -u www-data
```

---

## 🎉 Conclusion

If you have any questions, create **Issues** in the repository. Happy synchronizing! ✨

```

## Useful Commands

```sqlite
Database Access
* sqlite3 /home/user-data/mail/roundcube/roundcube.sqlite
Check Records
* sqlite> SELECT * FROM imapsync WHERE mailbox = 'test@example.com';
Manual Database Insertion
* INSERT INTO imapsync (mailbox, active, keep, protocol, src_server, src_auth, src_user, src_password, src_folder, dest_password, poll_time, fetchall, usessl, subscribeall, skipempty, maxage, date) VALUES ('test@example.com', 1, 1, 'IMAP', 'imap.example.com', 'password', 'test@example.com', 'YmFzZTY0X3Bhc3N3b3Jk', 'INBOX', 'YmFzZTY0X2Rlc3RfcGFzc3dvcmQ=', 10, 0, 1, 1, 1, 365, datetime('now', '-1 hour'));
Check Active Records
* SELECT * FROM imapsync WHERE active = 1;
```

Get Encoded Password
```bash
echo -n "your_password" | base64
```

Adjust Design
/usr/local/lib/roundcubemail/plugins/imapsync/skins/elastic/templates/imapsync.html

```
