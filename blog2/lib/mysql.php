<?php

function mConn(){
	static $conn = null;
	if($conn == null){
		$cfg = require(ROOT . '/lib/config.php');
		$conn = mysqli_connect($cfg['host'],$cfg['user'],$cfg['password']);
		mysqli_query($conn,'use ' . $cfg['db']);
		mysqli_query($conn,'set names '.$cfg['charset']);
	}
	return $conn;
}

function mQuery($sql){
	return mysqli_query(mConn(),$sql);
}

function mGetAll($sql){
	$rs = mQuery($sql);
	$arr = array();
	if(!$rs){
		return mysqli_error(mConn());
	}
	while($row=mysqli_fetch_assoc($rs)){
		$arr[]=$row;
	}
	return $arr;
}

function mGetRow($sql){
	$rs = mQuery($sql);
	if(!$rs){
		return mysqli_error(mConn());
	}
	return mysqli_fetch_assoc($rs);
}

function mGetOne($sql){
	$rs = mQuery($sql);
	if(!$rs){
		return mysqli_error(mConn(),$sql);
	} else {
		$row = mysqli_fetch_row($rs);
		return $row[0];
	}
}

function mExec($table,$data,$act='insert',$where='0'){
	if($act=='insert'){
		$sql = 'insert into ' . $table . '(';
		$sql .= implode(',' , array_keys($data)) . ") values ('";
		$sql .= implode("','" , array_values($data)) . "')";
		return mQuery($sql);
	}  else if ($act == 'update') {
		$sql = "update $table set ";
		foreach($data as $k=>$v) {
			$sql .= $k . "='" . $v . "',";
		}

		$sql = rtrim($sql , ',') . " where ".$where;
		return mQuery($sql);
	}
}

function getLastId(){
	return mysqli_insert_id(mConn());
}

?>