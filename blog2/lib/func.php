<?php

function acc() {
	return isset($_COOKIE['name']);
}

function succ($msg='成功'){
	$res='succ';
	require(ROOT.'/view/admin/info.html');
	exit;
}

function error($msg='失敗'){
	$res='error';
	require(ROOT.'/view/admin/info.html');
	exit;
}

function randStr($num=6){
	$str = str_shuffle('abcdefghjkmopqrstuvwxyzABCDEFGHJKMOPQRSTUVWXYZ23456789');
	return substr($str, 0 , $num);

}

function createDir(){
	$path = './upload/'.date('Ymd');
	if(is_dir($path) || mkdir($path, 0777, true)){
		return $path;
	} else {
		return false;
	}
}

function getExt($name){
	return strrchr($name, '.');
}



function makeThumb($ori , $sw=200 , $sh=200) {
$path = dirname($ori) . '/' . randStr() . '.png';
$opic = ROOT . $ori; //大图的绝对路径
$opath = ROOT . $path;//小图的绝对路径
//原始大图片
if(!list($bw,$bh,$type) = getimagesize($opic)) {
return false;
}
/*1 = GIF，2 = JPG，3 = PNG，4 = SWF，5 = PSD，6 = BMP，7 = TIFF(intel byte order)，8 = TIFF(motorola byte order)，9 = JPC，10 = JP2，11 = */
$map = array(
1=>'imagecreatefromgif',
2=>'imagecreatefromjpeg',
3=>'imagecreatefrompng',
6=>'imagecreatefromwbmp',
15=>'imagecreatefromwbmp'
);
//如果传来的图片类型不再map里 无法处理 则return false
if( !isset($map[$type]) ) {
return false;
}
//原始大图
$func = $map[$type];
$big = $func($opic);
//创建小画布
$small = imagecreatetruecolor($sw, $sh);
$white = imagecolorallocate($small, 255, 255, 255);
imagefill($small, 0, 0, $white);
//计算缩略比
$rate = min( $sw/$bw , $sh/$bh );
/*imagecopyresampled ( $small , $big , int $dst_x , int $dst_y , 0 , 0 , int $dst_w , int $dst_h , $bw , $bh )*/
//真正粘到小图上的宽高
$rw = $bw*$rate;
$rh = $bh*$rate;
imagecopyresampled ( $small , $big , ($sw-$rw)/2 , ($sh-$rh)/2 , 0 , 0 , $rw , $rh , $bw , $bh );
//保存缩略图
imagepng($small , $opath);
//销毁画布
imagedestroy($big);
imagedestroy($small);
return $path;
}



?>