
There are two different approaches to calling the upload subroutine.

If you have a file field that does NOT have the multiple attribute, then this is the correct way to call the subroutine:
<pre>
    my $q = CGI-&gt;new;
    my $res = &upload($save_to_directory, $q-&gt;param('myfield'), '', 100, 1);
</pre>

If you have more than one file upload field on your page, then call each one successively:
<pre>
    my $q = CGI-&gt;new;
    my $res1 = &upload($save_to_directory, $q-&gt;param('myfield1'), '', 100, 1);
    my $res2 = &upload($save_to_directory, $q-&gt;param('myfield2'), '', 100, 1);
    my $res3 = &upload($save_to_directory, $q-&gt;param('myfield3'), '', 100, 1);
    my $results = "File 1: $res1&lt;br /&gt;File 2: $res2&lt;br /&gt;File 3: $res3&lt;br /&gt;
</pre>

If you are using the <code>multiple</code> attribute, then this is the correct way to call the subroutine:
<pre>
    my $q = CGI-&gt;new;
    my @fields;
    my $results;
    if($q->param('myfield') =~ /\,/) {
        @fields = split(/\,/, $q->param('myfield'));
    } else {
        push(@fields, $q->param('myfield'));
    }
    foreach $file (@fields) {
        my $res = &upload($save_to_directory, $file, '', 100, 1);
        $results .= "Upload for $file : $res&lt;br /&gt;";
    }
</pre>

