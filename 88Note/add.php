<?php
$conn = mysqli_connect('localhost','root','');
mysqli_query($conn,'use note');
if(!empty($_POST)){
	$content = $_POST['content'];
	$newContent = addslashes($content);
	$sql = "insert into memo(content) values ('$newContent');";
	mysqli_query($conn,$sql);
}
$id = mysqli_insert_id($conn);
$sql = "select * from memo where id=$id;";
$rs = mysqli_query($conn,$sql);
echo json_encode(mysqli_fetch_assoc($rs));
?>

