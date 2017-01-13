<?php
class Example{
	public function __isset($name){
		return true;
	}
}
$example=new Example();
var_dump(isset($example->none));//此处得到结果bool(true)

?>
/*********************************************************************************************/
<?php
class Example{
	public function __isset($name){
		return false;
	}
}
$example=new Example();
var_dump(isset($example->none));//此处得到结果bool(false)

?>