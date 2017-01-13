<?php
//sleep(2);
if(rand(1,10)<4){
	echo 'Response from php: 0';
} else {
	$cnt = file_get_contents('a.txt');
	$cnt += 1;
	file_put_contents('./a.txt', $cnt);
	echo "Response from php: 1";
}
?>