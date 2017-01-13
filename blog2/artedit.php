<?php
require('./lib/init.php');
$art_id = $_GET['art_id'];
if(empty($_POST)){
	$sql = 'select * from art where art_id='.$art_id;
	$sql2 = 'select * from cat;';
	$old = mGetRow($sql);
	$cat = mGetAll($sql2);
	/*
	echo $art['art_id'];
	echo $art['title'];
	echo $art['content'];
	echo $art['cat_id'];
	foreach ($cat as $c) {
		echo $c['cat_name'];
	}
	*/
	require(ROOT.'/view/admin/artedit.html');
} else {
	$art['title'] = trim($_POST['title']);
	$art['cat_id'] = trim($_POST['cat_id']);
	$art['content'] = trim($_POST['content']);
	$art['arttag'] = trim($_POST['tag']);
	$art['lastup'] = time();
	//user_id
	//nick
	//comm
	if(empty($art['title'])){
		error('標題不能為空');
	}
	if(empty($art['content'])){
		error('內容不能為空');
	}
	if(!mExec('art',$art,'update','art_id='.$art_id)){
		echo mysqli_error(mConn());
	} else {
		$sql = 'delete from tag where art_id='. $art_id;
		mQuery($sql);
		$tag = $art['arttag'];
		if(empty($tag)) {
			header('Location: artlist.php');
		} else {
			$tag = explode(',', $tag);		
			$sql = 'insert into tag(art_id,tag) values ';
			foreach ($tag as $t) {
				$sql .= '('.$art_id.', "'.$t.'"),';
			}
			$sql = rtrim($sql,',');
			if(!mQuery($sql)){
				error('add tag error!');
			} else {
				header('Location: artlist.php');
			}
		}
	}
}

?>