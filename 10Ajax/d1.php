<?php
if(empty($_FILES)){
	exit('no file');
}
$error = $_FILES['pic']['error']==0? 'succ':'fail';

echo "<script>parent.document.getElementById('progress')[0].innerHTML = '$error'</script>";

?>