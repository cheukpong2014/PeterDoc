<?php
require('./lib/init.php');

if(!acc()){
	header('Location: login.php');
}

if(empty($_POST)){
	$sql = 'select * from cat';
	$arr = mGetAll($sql);
	require(ROOT.'/view/admin/artadd.html');
} else {

	$art['title'] = trim($_POST['title']);
	$art['cat_id'] = trim($_POST['cat_id']);
	$art['content'] = trim($_POST['content']);
	$art['arttag'] = trim($_POST['tag']);
	$art['pubtime'] = time();
	$art['lastup'] = time();
	$art['nick'] = 'admin';
	//user_id
	//nick
	//comm
	if(empty($art['title'])){
		error('標題不能為空');
	}
	if(empty($art['content'])){
		error('內容不能為空');
	}
	if($_FILES['pic']['error']==1){
		error('圖片上傳出錯');
	}

	$filename = createDir() . '/' . randStr() . getExt($_FILES['pic']['name']);
	if(move_uploaded_file($_FILES['pic']['tmp_name'], ROOT . $filename)){
		$art['pic'] = makeThumb($filename,600,600);
		$art['thumb'] = makeThumb($filename);
	}

	if(!mExec('art',$art)){
		echo mysqli_error(mConn());
	} else {
		$art_id = mysqli_insert_id(mConn());
		$sql = 'update cat set num=num+1 where cat_id=' . $art['cat_id'];
		mQuery($sql);
		$tag = $art['arttag'];
		
		if(empty($tag)) {
			
			succ('成功發佈文章');
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