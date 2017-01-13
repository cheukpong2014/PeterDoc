<?php
$conn = mysqli_connect('localhost','root','');
mysqli_query($conn,'use note');
if(!empty($_POST)){
	$del = $_POST['del'];
	$sql = "delete from memo where id=$del";
	mysqli_query($conn,$sql);
	echo $del;
}
?>