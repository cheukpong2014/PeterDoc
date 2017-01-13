<?php
$arr = array('13800138000','13426060134','170235','18289881234568782');
//$patt = '/^[01235689]{11}$/';
$patt = '/^[^47]{11}$/';
foreach ($arr as $k => $v) {
	preg_match_all($patt, $v, $src);
	var_dump($src);
}

?>