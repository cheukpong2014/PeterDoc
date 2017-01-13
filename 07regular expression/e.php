<?php  
$str = 'baidu o2o b2b c2c heol xiling shuai chou bage';
$patt = '/\b[a-zA-Z]+\b/';
//$patt = '/\b[a-zA-Z]{5,}\b/';
preg_match_all($patt, $str, $scr);
var_dump($scr);
?>