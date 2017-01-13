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

if($num>0){
	echo $cat_name,' has ',$num,' articles so it cannot be deleted';
} else {
	$conn=mysqli_connect('localhost','root','');
	mysqli_query($conn,'use blog2');
	mysqli_query($conn,'set names utf8;');

	$sql = 'delete from cat where cat_id='.$cat_id;
	if(!mysqli_query($conn,$sql)){
		echo mysqli_error($conn);
	} else {
		require('./catlist.php');
	}
}
?>