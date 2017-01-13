<?php
$z=1.3;
if(isset($z)){
  echo gettype($z);
}
else{
  echo 'not exit';
}
echo "<br  />";

$a = true;
echo $a;
echo "<br  />";

$b = array(1,2,'3');
print_r ($b);
echo "<br  />";

var_dump($b);
echo "<br  />";

$c = "world12.6hello";
$d = $c + 3;
var_dump($d);
echo "<br  />";

$e = 123;
$f = $e . 'hello';
var_dump($f);
echo "<br  />";

$e = 123;
$f = $e . 'hello';
var_dump($f);
echo "<br  />";

/*变量赋值*/
        $li=15;
        $wang=35;
        $li=$wang;
        var_dump($li,$wang); //35,35
        echo "<br  />";
        $li='w';
        var_dump($li,$wang);//w,35
        echo "<br  />";

        /*变量引用赋值*/
        $li=15;
        $wang=35;
        $li=&$wang;
        var_dump($li,$wang);//35,35
        echo "<br  />";
        $wang='ws';
        var_dump($li,$wang);//ws,ws
        echo "<br  />";


    
    for($i = 100000,$cnt = 0;$i >= 5000; ){
        if($i > 50000){
            $i *= 0.95;
            echo '0.95 ';
        }else{
            $i -= 5000;
            echo '5000 ';        
        }
        
        $cnt += 1;
        echo "第",$cnt,"过桥，剩下",$i,"元<br />";
    }


    $i = 100000;
    $cnt = 0;

    while($i >= 5000){
        if($i>50000){
            $i *= 0.95;
            echo '0.95 ';
        }else{
            $i -= 5000;
            echo '5000 '; 
        }

        $cnt++;
        echo "第 $cnt 次过桥，还剩下 $i 元<br />";
    }


?>