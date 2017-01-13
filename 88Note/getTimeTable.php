<?php
$conn = mysqli_connect('localhost','root','');
mysqli_query($conn,'use note');
$sql = 'select * from timetable;';
$rs = mysqli_query($conn,$sql);
while($row = mysqli_fetch_array($rs)){
	//$time[] = $row;
	echo json_encode($row);
}


?>