#!/usr/bin/perl

#BEGIN {
#    $| = 1;
#    open(STDERR, ">&STDOUT");
#    print "Content-type: text/html\n\n<pre>\n";
#}


#	Requirements:		UNIX Server, Perl5+, CGI.pm
#	Created:		September 22nd, 2000
#	Author: 		Jim Melanson

#Load CGI.pm to be used by upload.lib
require CGI;

require 'upload.lib';

%qs = ();
my @qs_pairs = split(/\&/, $ENV{'QUERY_STRING'});
foreach my $qs_pair (@qs_pairs) {
    my($qs_key, $qs_value) = split(/\=/, $qs_pair);
    $qs{$qs_key} = $qs_value;
}
undef @qs_pairs;
delete $qs{pid};

my $save_to_directory = qq~/home/normywebguy/uploaddemo~;
my $ScriptURL = qq~https://$ENV{'SERVER_NAME'}$ENV{'SCRIPT_NAME'}~;

my $results;

if($qs{upload} == 1) {
    # Because I have three upload fields
    # on the page, I need three separate
    # calls to the sub-routine. See that
    # I have passed the name of each of
    # the upload fields to the subroutine
    # calls
    #
    #The argumens are:
    #upload('path to save to', 'upload file name', 'new file name', 'max size in kb', 'boolean: serialize same name uploads'); 
    my $q = CGI->new;
    my $res1 = &upload($save_to_directory, $q->param('myfield'), '', 100, 1);
    my $res2 = &upload($save_to_directory, $q->param('anotherfile'), '', 100, 1);
    my $res3 = &upload($save_to_directory, $q->param('FILE3'), '', 100, 1);
    $results = "Upload 1: $res1<br />Upload 2: $res2<br />Upload 3: $res3<br /><br />";
}

if( ($qs{delete} eq '1') && $qs{f}) {
    if($qs{f} =~ /^\./) {
        die "User $ENV{'REMOTE_ADDR'}/$ENV{'HTTP_X_REAL_IP'} attempted to access a hidden file or directory: $!\n";
        exit;
    }
    if($qs{f} =~ /^\//) {
        die "User $ENV{'REMOTE_ADDR'}/$ENV{'HTTP_X_REAL_IP'} attempted to access another directory: $!\n";
        exit;
    }
    if(-e "$save_to_directory/$qs{f}") {
        unlink("$save_to_directory/$qs{f}");
    }
}

print "Content-cache: no-cache\nContent-type: text/html\n\n";
print qq~<!DOCTYPE html>
<html>
<head>
  <title>Perl Demo: File Upload</title>
  <link rel="stylesheet" type="text/css" href="https://www.jimmelanson.ca/css/flexbox.css">
  <link rel="stylesheet" type="text/css" href="https://www.jimmelanson.ca/css/programming_blog.css">
</head>
<body>
<div class="main-page">
  <header>
    <div class="header-container">
      <label class="item-title">
        Perl Demo: File Upload
      </label>
      <label class="item-user">
        from Ninja Kitty
      </label>
    </div>
  </header>
  <br /><br />
  <div class="indexpage-container1">
    <div class="indexpage-container1-stuff">
      <div>
~;
if($results) {
    print $results;
}
print qq~
        <!--
            This is the actual upload form.
            Note that you can name the upload
            fields anything you want so long
            as you pass that field name to the
            upload() subroutine. (see above)
        -->
        
     You can upload these file types:
     <br />
     *.gif, *.jpg, *.jpeg, *.png, *.txt, *.pdf
     <br />
     Max size: 100Kb.
     <br /><br />
        
    <form method="post" action="$ScriptURL?upload=1&pid=$$" enctype="multipart/form-data">

    File 1: <input type="file" name="myfield">
    <br /><br />

    File 2: <input type="file" name="anotherfile">
    <br /><br />

    File 3: <input type="file" name="FILE3">
    <br /><br />

    <input type="submit" value="Upload" class="admin-button-normal" />
    </form>
    <br /><br />
~;
#Now I am printing out all the files that were uploaded.

if(opendir(READ, "$save_to_directory")) {
    my @files = readdir(READ);
    closedir READ;
    my @sorted = sort { $a cmp $b } @files;
    foreach my $sorted_file (@sorted) {
        unless(($sorted_file eq '.') || ($sorted_file eq '..')) {
            print qq~<a href="https://www.jimmelanson.ca/cgi-bin/programming/download.cgi?d=uploaddemo&f=$sorted_file&pid=$$">$sorted_file</a> &nbsp;&nbsp;\[<a href="$ScriptURL?f=$sorted_file&delete=1&pid=$$" style="color:#800000;">Delete</a>\]<br />\n~;
        }
    }
    print qq~<br /><br />\n~;
}
print qq~
      </div>
    </div>
  </div>
  <br /><br /><br /><br />
  <div class="footer-container">
      <label class="footer-normal">&copy; 2017 Ninja Kitty</label>
  </div>
</div>
</body>
</html>
~;
exit;


