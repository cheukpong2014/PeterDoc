<?php

require('./lib/init.php');
if(empty($_GET)){
	$where = '';
} else {
	$where = ' where art.cat_id='.$_GET['cat_id'];
}
$sql = 'select art.*,cat.* from art left join cat on art.cat_id=cat.cat_id'.$where.' order by lastup desc';
$art = mGetAll($sql);
$sql2 = 'select * from cat order by cat_id;';
$cat = mGetAll($sql2);
require(ROOT.'/view/front/index.html');

?>