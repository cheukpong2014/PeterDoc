<?php
$conn = mysqli_connect('localhost','root','');
mysqli_query($conn,'use note');
if(!empty($_POST)){
	for($x=1;$x<25;$x++){
		$varable = 't'.$x;
		$t = $_POST["$varable"];
		$sql = "update timetable set $varable='$t' where id=1;";
		mysqli_query($conn,$sql);
	}
}
?>