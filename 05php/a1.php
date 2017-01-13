<?php

setcookie('name','lisi');
setcookie('user','admin',time()+120,'/');
print_r($_COOKIE)

?>