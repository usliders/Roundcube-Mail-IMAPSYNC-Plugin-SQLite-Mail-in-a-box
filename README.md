Ein Roundcube-Plugin um externe Mailkonten (GMX und Co.) abrufen zu können, per User bzw. per Mailbox natürlich.

Installationsanleitung:
-----------------------
fetchmail installieren:

Debian / Ubuntu : 
apt-get install fetchmail


Plugin installieren:

Das Verzeichnis "fetchmail" in das Plugin-Verzeichnis von Roundcube kopieren

Die Config Datei von Roundcube ( config/main.inc.php ) um Zeile 240 findet ihr etwas in dieser Art:

$rcmail_config['plugins'] = array(''managesieve', 'sieverules');

das neue Fetchmail-Plugin aktivieren wir, in dem wir es folgender massen in diese Zeile eintragen:

$rcmail_config['plugins'] = array('managesieve', 'sieverules', 'fetchmail');

und die Anzahl der erlaubten Konten die abgerufen werden sollen (pro lokale Mailbox) anpassen:
vi /var/www/ispcp/gui/tools/roundcube/plugins/ispcp_fetchmail/config/config.inc.php

$rcmail_config['fetchmail_limit'] = 10;


das Perl script benötigt Zugangsdaten zu der MySQL Datenbank

vi /var/mail/fetchmail.pl
$db_host="127.0.0.1";
$db_database="roundcube";
$db_username="dbuser";
$db_password="dbpass";

natürlich wollen wir, dass Fetchmail regelmäßig die mails abholt (z.B. alle 5 Minuten):

crontab -e
*/5 * * * * sudo -u vmail <Pfad zu Roundcube>/scripts/fetchmail.pl > /dev/null 2&>1

dann noch die Log-Ausgabedatei erstellen und rechte geben:

zur Funktionsweise: das Roundcube-Plugin speichert die Konten die abgerufen werden sollen in die Datenbank, das Perl-Script wird regelmäßig per Cron aufgerufen, ließt die Datenbank aus und erstellt eine temporäre fetchmailrc, ruft fetchmail damit auf und die User kriegen ihre mails von GMX und Co. in Ihr schönes IMAP-Postfach 
Bei jedem Aufruf werden immer die aktuellen Einträge aus der Datenbank geholt und die alte fetchmailrc überschrieben bzw. nach jedem Durchlauf wird die fetchmailrc gelöscht.
