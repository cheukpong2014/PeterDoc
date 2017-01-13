<?php  
$ass = array("aa","bb","cc");
$asslength = count($ass);
for ($i=0; $i < $asslength; $i++) { 
	# code...
	echo $ass[$i];
	echo "<br>";
}
foreach ($ass as $value) {
	echo $value;
	echo "<br>";
}

?>