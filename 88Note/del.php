<?php
$conn = mysqli_connect('localhost','petertan_Plan','petertan_Plan');
mysqli_query($conn,'use petertan_Plan');
if(!empty($_POST)){
	$del = $_POST['del'];
	$sql = "delete from memo where id=$del";
	mysqli_query($conn,$sql);
	echo $del;
}
?>