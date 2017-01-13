<?php
require('./lib/init.php');
if(!acc()){
	header('Location: login.php');
}

$conn=mysqli_connect('localhost','root','');
mysqli_query($conn,'use blog2');
mysqli_query($conn,'set names utf8');
$sql = 'select * from cat order by cat_id';
$rs = mysqli_query($conn,$sql);
while($row=mysqli_fetch_assoc($rs)){
	$arr[] = $row;
}
require('./view/admin/catlist.html');
?>