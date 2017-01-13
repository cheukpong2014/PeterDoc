<?php

echo "留言的標題和內容:<br />";
//$tid = $_GET['tid'];
//echo "你想看第".$tid."個留言。";
$fh = fopen('./05msg.txt', 'r');

//print_r(fgetcsv($fh));
//$row = fgetcsv($fh);
//print_r($row);echo("<br  />");
//print_r(fgetcsv($fh));echo("<br  />");
//print_r($row);
//*

while( ($row=fgetcsv($fh))!=false ){
	echo($row[0] . "<br  />");
	echo($row[1] . "<br  />" . "<br  />");
	//print_r(fgetcsv($fh));echo("<br  />");
}
//*/
echo '<br  />你現在於第' . $_GET['tid'] . '貼的內容，並在第' . $_GET['page'] . '頁。' . '<br  />';
?>
<h1><a href="05index.html">BACK</a></h1>