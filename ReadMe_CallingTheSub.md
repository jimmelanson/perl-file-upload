
There are two different approaches to calling the upload subroutine.

If you have a file field that does NOT have the multiple attribute, then this is the correct way to call the subroutine:

<code>
    my $q = CGI->new;
    my $res1 = &upload($save_to_directory, $q->param('myfield'), '', 100, 1);
</code>
