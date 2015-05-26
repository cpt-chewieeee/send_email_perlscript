#!/usr/bin/perl
use strict;
use warnings;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS;
use Email::Simple ();
use Email::Simple::Creator ();

my $smtpserver = 'smtp.gmail.com';
my $smtpport = 587;

print "Enter Username: ";
my $smtpuser   = <STDIN>;
chomp $smtpuser;

print "Enter Password: ";
my $smtppassword = <STDIN>;
print "Hello " . $smtpuser . "\n \t" . $smtppassword;

my $transport = Email::Sender::Transport::SMTPS->new({
  host => $smtpserver,
  ssl  => 'starttls',
  port => $smtpport,
  sasl_username => $smtpuser,
  sasl_password => $smtppassword,
  debug => 1,
});
print "Send to: ";
my $frm = <STDIN>;
chomp $frm;

print "Subject: ";
my $sub = <STDIN>;
chomp $sub;

print "Message: ";
my $msg = <STDIN>;
chomp $msg;

my $email = Email::Simple->create(
  header => [
    To      => $frm,
    From    => $smtpuser,
    Subject => $sub,
  ],
  body => $msg,
);

sendmail($email, { transport => $transport });

print "Do you want to remember your actions?\n";
my $opt = <STDIN>;
chomp $opt;
if($opt eq "yes"){
  open(my $fg, ">temp.txt") or die "Couldn't open file \n";
  print $fg $smtpuser . "\n";
  print $fg $smtppassword;
  print $fg $frm . "\n";
  print $fg $sub . "\n";
  print $fg $msg . "\n";
  print $fg "no\n";
  close $fg;
  print "DONE!\n";
}

