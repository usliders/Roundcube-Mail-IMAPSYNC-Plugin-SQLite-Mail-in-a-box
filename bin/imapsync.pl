#!/usr/bin/perl

use strict;
use DBI;
use MIME::Base64;
use Sys::Syslog;
use LockFile::Simple qw(lock trylock unlock);

use vars qw/ %db_conf /;
syslog("info", "Starting imapsync.pl");
syslog("info", "Lock acquired");

my $lock_file = "/tmp/imapsync-all.lock";
my $lockmgr = LockFile::Simple->make(-autoclean => 1);
my $lock = $lockmgr->lock($lock_file) || &log_and_die("can't lock $lock_file");

require "./config.conf" || log_and_die($!);

my $DBH = DBI->connect("DBI:SQLite:dbname=$Conf::db_file", "", "") || &log_and_die("cannot connect to database");

&main();

sub main {
    syslog("info", "imapsync started");

    my $select_stmnt = "SELECT * FROM imapsync WHERE active = 1 AND (strftime('%s', 'now') - strftime('%s', date)) > poll_time * 60 ";
    my $sth = $DBH->prepare($select_stmnt);
    my $rc = $sth->execute() || &log_and_die(DBI->errstr);

    syslog("info", $rc." Accounts gefunden");

        while(my $ref = $sth->fetchrow_hashref()) {
            syslog("info", "Sync: ".$ref->{'src_user'}.'@'.$ref->{'src_server'});

                my @params = ();
                push(@params, '--host1');
                push(@params, $ref->{'src_server'});
                push(@params, '--user1');
                push(@params, $ref->{'src_user'});
                push(@params, '--password1');
                push(@params, decode_base64($ref->{'src_password'}));
                push(@params, '--host2');
                push(@params, 'localhost');
                push(@params, '--user2');
                push(@params, $ref->{'mailbox'});
                push(@params, '--password2');
                push(@params, decode_base64($ref->{'dest_password'}));
                push(@params, '--logfile');
                push(@params, './imapsync.log');
                if($ref->{'keep'} == 0) {
                    push(@params, '--delete');
                }
                if($ref->{'skipempty'}  == 1) {
                    push(@params, '--skipemptyfolders');
                }
                if($ref->{'subscribeall'} == 1) {
                    push(@params, '--subscribeall');
                }
                if($ref->{'maxage'} && $ref->{'maxage'} != 0) {
                    push(@params, '--maxage');
                    push(@params, $ref->{'maxage'});
                }

                system("imapsync", @params) || print($!);

                my $update_stmnt = "UPDATE imapsync SET returned_text = " . $DBH->quote('') . ", date = datetime('now') WHERE id = " . $ref->{'id'};
                $DBH->do($update_stmnt);
        }

}

sub log_and_die {
        my($message) = @_;
  syslog("err", $message);
  die $message;
}

$lock->release if $lock;
syslog("info", "Lock released");

1;
