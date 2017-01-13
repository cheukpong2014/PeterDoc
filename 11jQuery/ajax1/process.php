<?php
header('Content-type: text/html;chartset=utf-8');
if(!empty($_GET)){
	$username = $_GET['username'];
}
if(!empty($_POST)){
	$username = $_POST['username'];
}
if($username=='admin'){
	echo 'false';
}else{
	echo "true";
}