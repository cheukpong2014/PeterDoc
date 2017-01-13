<?php  
$cnt = file_get_contents('a.txt');
$cnt += 1;
file_put_contents('./a.txt', $cnt);
?>