<!--<html>
<div class="g-recaptcha" data-sitekey="6LepgmYUAAAAALf4X2NANRmZEZxURBWVFzU44rqR"></div>
6LepgmYUAAAAAH39490gynp4drIR7mEloXDuOcph
-->
<?php
if(empty($_POST)){
	
}else{
	foreach ($_POST as $key => $value) {
		echo '<p><strong>' . $key.':</strong> '.$value.'</p>';
	}
	require_once "./recaptchalib.php";
	// your secret key
	$secret = "6LepgmYUAAAAAH39490gynp4drIR7mEloXDuOcph";
	 
	// empty response
	$response = null;
	 
	// check secret key
	$reCaptcha = new ReCaptcha($secret);

	// if submitted check response
	if ($_POST["g-recaptcha-response"]) {
		$response = $reCaptcha->verifyResponse(
			$_SERVER["REMOTE_ADDR"],
			$_POST["g-recaptcha-response"]
		);
	}

	  if ($response != null && $response->success) {
		echo "Hi " . $_POST["name"] . " (" . $_POST["email"] . "), thanks for submitting the form!";
	  } else {
		echo "Submit fail." ;
	  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<title>How to Integrate Google “No CAPTCHA reCAPTCHA” on Your Website</title>
</head>
<body>
<form action="" method="post">
	<label for="name">Name:</label>
	<input name="name" required><br />
	<label for="email">Email:</label>
	<input name="email" type="email" required><br />
	<div class="g-recaptcha" data-sitekey="6LepgmYUAAAAALf4X2NANRmZEZxURBWVFzU44rqR"></div>
	<input type="submit" value="Submit" />
</form>
<script src='https://www.google.com/recaptcha/api.js'></script>
</body>
</html>