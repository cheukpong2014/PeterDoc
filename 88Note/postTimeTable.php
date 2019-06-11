<?php
$conn = mysqli_connect('localhost','petertan_Plan','petertan_Plan');
mysqli_query($conn,'use petertan_Plan');
if(!empty($_POST)){
	for($x=1;$x<49;$x++){
		$varable = 't'.$x;
		$t = $_POST["$varable"];
		$sql = "update timetable set $varable='$t' where id=1;";
		mysqli_query($conn,$sql);
	}
}
?>