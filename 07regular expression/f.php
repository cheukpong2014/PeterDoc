<?php
$str2 = 'a    b              hello             world';
$patt2 = '/\s{1,}/';
echo preg_replace($patt2, ' ', $str2);



$str = 'tommorw is    another day , o2o , you dont bird me i dont bird 
you';
$patt = '/\W{2,}/';
preg_match_all($patt, $str, $scr);
var_dump($scr);
?>