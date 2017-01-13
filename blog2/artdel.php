<?php
require('./lib/init.php');
$art_id = $_GET['art_id'];
$cat_id = $_GET['cat_id'];
$sql = 'delete from art where art_id='.$art_id;
if(!mQuery($sql)){
	error('刪除失敗');
} else {
	$sql = 'update cat set num=num-1 where cat_id=' . $cat_id;
	mQuery($sql);
	$sql = 'delete from tag where art_id='. $art_id;
	mQuery($sql);
	header('Location: artlist.php');
}
?>