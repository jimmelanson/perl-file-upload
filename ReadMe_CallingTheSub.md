
There are two different approaches to calling the upload subroutine.

If you have a file field that does NOT have the multiple attribute, then this is the correct way to call the subroutine:
<pre>
    my $q = CGI->new;
    my $res1 = &upload($save_to_directory, $q->param('myfield'), '', 100, 1);
</pre>

If you have more than one file upload field on your page, then call each one successively:
<pre>
    my $q = CGI->new;
    my $res1 = &upload($save_to_directory, $q->param('myfield1'), '', 100, 1);
    my $res2 = &upload($save_to_directory, $q->param('myfield2'), '', 100, 1);
    my $res3 = &upload($save_to_directory, $q->param('myfield3'), '', 100, 1);
</pre>
