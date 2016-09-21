<?php

	error_reporting(-1);
	ini_set('display_errors', '1');

	$connection_string = "host=localhost dbname=salaak user=salaak password=salaak";
	$connection = pg_connect($connection_string)  
		or die('Could not connect: ' . pg_last_error());

?>
