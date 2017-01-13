<?php
require('./lib/init.php');

if(!acc()){
	header('Location: login.php');
}

$sql = 'select * from comment order by comment_id desc';
$comm = mGetAll($sql);
require(ROOT.'/view/admin/commlist.html');
?>