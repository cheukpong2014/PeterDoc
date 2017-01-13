<?php
$str = 'gd god gooood gooooood gooooooooooood';
$patt = '/go+d/';
echo(preg_replace($patt, 'god', $str));
$patt = '/\b\w{6}\b/';
$patt = '/\b\w{6,}\b/';
$patt = '/\b\w{6,10}\b/';
//preg_match_all($patt, $str, $scr);
//var_dump($scr);
?>