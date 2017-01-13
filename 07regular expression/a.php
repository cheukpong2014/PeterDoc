<?php 
$str = 'hi,his is this sthi';
$patt = '/hi/';

preg_match_all($patt, $str, $src);
var_dump($src);
?>