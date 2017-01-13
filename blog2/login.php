<?php
require('./lib/init.php');
if(empty($_POST)){
	require('./view/front/login.html');
} else {
	$user['name'] = trim($_POST['name']);
	if(empty($user['name'])){
		header('Location: login.php');
	}
	$user['password'] = trim($_POST['password']);
	if(empty($user['password'])){
		header('Location: login.php');
	}
	$sql = 'select * from user where name="'.$user['name'].'"and password="'.$user['password'].'";';
	if(!mGetRow($sql)){
		header('Location: login.php');
	} else {
		setcookie('name' , $user['name']);
		header('Location: artlist.php');
	}
}

?>