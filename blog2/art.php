<?php
require('./lib/init.php');
$art_id = $_GET['art_id'];

$sql = 'select art.*,cat.* from art left join cat on art.cat_id=cat.cat_id where art_id=' . $art_id .';';
$a = mGetRow($sql);
$sql2 = 'select * from cat order by cat_id;';
$cat = mGetAll($sql2);

if($_POST){
	$comm['art_id'] = $art_id;
	//user_id
	$comm['nick'] = trim($_POST['name']);
	$comm['content'] = trim($_POST['comment']);
	//ip
	$comm['pubtime'] = time();
	$comm['email'] = trim($_POST['email']);
	mExec('comment',$comm);
	$sql = 'update art set comm=comm+1 where art_id='.$art_id;
	mQuery($sql);
}

$sql3 = 'select * from comment where art_id=' . $art_id . ' order by pubtime desc;';
$com = mGetAll($sql3);

require(ROOT.'/view/front/art.html');

?>