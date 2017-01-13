<?php
require('./lib/init.php');
$comment_id = $_GET['comment_id'];

$sql = 'select art_id from comment where comment_id=' . $comment_id;
$art_id = mGetOne($sql);

if($art_id) {
	$sql2 = 'delete from comment where comment_id=' . $comment_id;
	$sql3 = 'update art set comm=comm-1 where art_id=' . $art_id;
	mQuery($sql2);
	mQuery($sql3);
}
$ref = $_SERVER['HTTP_REFERER'];
header("Location: $ref");

?>