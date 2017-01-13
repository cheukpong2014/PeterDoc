<?php
require('./lib/init.php');
//1 创建画布
$img = imagecreatetruecolor(60, 40);
//2 创建颜色
$red = imagecolorallocate($img, 255, 0, 0);
$gray = imagecolorallocate($img, 200, 200, 200);
//3 填充颜色
imagefill($img, 0, 0, $gray);
//4 水平的画一行字符串
//参数: 画布,字体(1-5),str的x轴开始处,str的y轴开始处,str,字符串颜色
imagestring ($img , 5 , 10 , 5 , randStr(4) , $red );
//5 保存图片
//通知浏览器 接下来输出的是png图片

header('Content-type:image/png');

//不加第二个参数 浏览器会将图片的二进制信息输出在浏览器上,它会按照文字来理解这个图片

imagepng($img);

// 6 销毁画布
imagedestroy($img);
?>