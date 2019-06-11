<?php
$conn = mysqli_connect('localhost','petertan_Plan','petertan_Plan');
mysqli_query($conn,'use petertan_Plan');
$sql = 'select * from memo order by id asc;';
$rs = mysqli_query($conn,$sql);
while($row = mysqli_fetch_assoc($rs)){
	$arr[] = $row;
}


/*
foreach ($arr as $a) {
	echo 'id: '.$a['id'].'<br />';
	echo nl2br( $a['content'] );

	echo '<br /><hr>';
}*/

echo json_encode($arr);

?>