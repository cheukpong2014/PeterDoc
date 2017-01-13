<h1><a href="05index.html">BACK</a></h1>
<?php
/*
$fh = fopen('./msg.txt', 'a');
fwrite($fh, 'from php into text');
fclose($fh);
echo'OK';
*/
$str = $_POST['title'] . "," . $_POST['content'] . "\n";
echo $str, '<br />';
$fh = fopen('./05msg.txt', 'a');
fwrite($fh, $str);
fclose($fh);

echo 'ok'. '<br />';

?> 