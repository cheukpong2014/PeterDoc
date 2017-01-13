<?php
require('./lib/init.php');
$sql2 = 'select * from cat order by cat_id;';
$cat = mGetAll($sql2);
require('./view/front/jQuery.html');
?>