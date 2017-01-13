<?php
if( !isset($_COOKIE['num']) ) {
$num = 1;
setcookie('num' , $num);
} else {
$num = $_COOKIE['num'] + 1;
setcookie('num' , $num);
}
echo $num;
?>