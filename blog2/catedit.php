<?php
$cat_id = $_GET['cat_id'];

$conn = mysqli_connect('localhost','root','');
mysqli_query($conn,'use blog2');
mysqli_query($conn,'set names utf8');
$sql = "select * from cat where cat_id=".$cat_id;
$rs = mysqli_query($conn,$sql);
$row = mysqli_fetch_assoc($rs);
$cat_name = $row['cat_name'];
$num = $row['num'];

if(empty($_POST)){
	require('./view/admin/catedit.html');
} else {
	$new_name = trim($_POST['cat_name']);
	if(empty($new_name)){
		echo 'cat name cannot be empty';
	} else {
		$conn = mysqli_connect('localhost','root','');
		mysqli_query($conn,'use blog2');
		mysqli_query($conn,'set names utf8');
		$sql = "update cat set cat_name ='$new_name' where cat_id=$cat_id;";
		mysqli_query($conn,$sql);
		require('./catlist.php');
	}
}

?>