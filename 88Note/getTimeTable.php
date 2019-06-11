<?php
$conn = mysqli_connect('localhost','petertan_Plan','petertan_Plan');
mysqli_query($conn,'use petertan_Plan');
$sql = 'select * from timetable;';
$rs = mysqli_query($conn,$sql);
while($row = mysqli_fetch_array($rs)){
	//$time[] = $row;
	echo json_encode($row);
}


?>