<?php 
	if(isset($_SESSION))
	{
		//Session for the activ query
		if(!isset($_SESSION['query']))
		{
			$sql = "SELECT name FROM slk_query ORDER BY id DESC LIMIT 1";
			$result = pg_query($sql)
				or die('Could not Retrieve query names: ' . pg_last_error());
			
			$line = pg_fetch_assoc($result);
			
			$_SESSION['query'] = $line['name'];
		}

		if(isset($_GET['query']))
		{
			$_SESSION['query']=$_GET['query'];
		}
		
		//Session for the type
		if(isset($_GET['type']))
		{
			$_SESSION['type']=$_GET['type'];
		}
		
		//Session for the node
		if(isset($_GET['node']))
		{
			$_SESSION['node']=$_GET['node'];
		}
		
		//Session for the ervice
		if(isset($_GET['service']))
		{
			$_SESSION['service']=$_GET['service'];
		}
		
		//Session for the metric		
		if(isset($_GET['metric']))
		{
			$_SESSION['metric']=$_GET['metric'];
		}
	}
	else
	{
        echo "No session variable has been created.";
    }
?>
