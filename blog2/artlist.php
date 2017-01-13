<?php
require('./lib/init.php');

if(!acc()){
	header('Location: login.php');
}

$sql = 'select art.*,cat.* from art left join cat on art.cat_id=cat.cat_id order by art.art_id;';
$arr = mGetAll($sql);
require(ROOT.'/view/admin/artlist.html');

?>