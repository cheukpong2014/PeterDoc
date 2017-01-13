<?php
require('./lib/init.php');

if(!acc()){
	header('Location: login.php');
}

if(empty($_POST)){
	require('./view/admin/catadd.html');
} else {
	$cat['cat_name'] = trim($_POST['cat_name']);
	if(empty($cat['cat_name'])){
		exit('欄目名稱不能為空');
	}

	/*
	if(!mExec('cat',$cat)){
		echo mysqli_error($conn);
	} else {
		header('Location: catlist.php');
	}
	*/
	$conn = mysqli_connect('localhost','root','');
	mysqli_query($conn, 'use blog2');
	mysqli_query($conn, 'set names utf8');
	$sql = "insert into cat(cat_name) values('" . $cat['cat_name'] . "')";
	
	if(!mysqli_query($conn, $sql)){
		echo mysqli_error($conn);
	}else{
		require('./view/admin/catadd.html');
	}

}



?>