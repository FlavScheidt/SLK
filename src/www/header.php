<?php 
	session_start();
	
	include 'connect.php' ;
	include 'session.php' ;
	include 'functions.php';
	
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<title>SLK</title>
	
	<link rel="stylesheet" type="text/css" media="screen" href="style.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="menu.css" />
	
	<!-- Add mousewheel plugin (this is optional) -->
<!--
	<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
-->
	<script type="text/javascript" src="./jquery-latest.min.js"></script>
	<script type="text/javascript">
		var $= jQuery.noConflict();
	</script>
	
	<script type="text/javascript" src="./fancybox/lib/jquery.mousewheel-3.0.6.pack.js"></script>

	<!-- Add fancyBox -->
	<link rel="stylesheet" href="./fancybox/source/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen" />
	<script type="text/javascript" src="./fancybox/source/jquery.fancybox.pack.js?v=2.1.5"></script>

	<!-- Optionally add helpers - button, thumbnail and/or media -->
	<link rel="stylesheet" href="./fancybox/source/helpers/jquery.fancybox-buttons.css?v=1.0.5" type="text/css" media="screen" />
	<script type="text/javascript" src="./fancybox/source/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
	<script type="text/javascript" src="./fancybox/source/helpers/jquery.fancybox-media.js?v=1.0.6"></script>

	<link rel="stylesheet" href="./fancybox/source/helpers/jquery.fancybox-thumbs.css?v=1.0.7" type="text/css" media="screen" />
	<script type="text/javascript" src="./fancybox/source/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

   <script src="script.js"></script>	
   
</head>
<body>
	
	<div id="container">
	
		<div id="header">
		
		</div> <!-- div header-->
		
		<div id="sidebar">
			<div id='cssmenu'>
				<ul>
				   <li><a href='index.php'>Home</a></li>
<!--
				   <li class='has-sub'><a href='#'>Control Panel</a>
					  <ul>
							<li><a href='#'>Config</a>
							</li>
							<li><a href='#'>Execution</a>
							</li>
					  </ul>
				   </li>
-->
				   <li class='has-sub'><a href='#'>Energy Plots</a>
						<ul>
							<li><a href=<?php echo "energy_plot.php?type=general" ?>>General</a></a></li>
							<li class='has-sub'><a href='#'>By Node</a>
								<ul>
									<li><a href='energy_plot.php?type=node&node=all'>All</a></li>
									<?php 
										$sql = "SELECT id, name FROM slk_node";
										$result = pg_query($sql)
											or die('Could not Retrieve nodes names: ' . pg_last_error());
											
										while ($line = pg_fetch_assoc($result))
										{
											echo "<li><a href='energy_plot.php?type=node&node=",$line['name'],"'>",$line['name'],"</a>";
										}
									?>
								</ul>
							</li>
							<li class='has-sub'><a href="#">By Service</a>
								<ul>
									<li><a href='energy_plot.php?type=service&service=all'>All</a></li>
									<?php 
										$sql = "SELECT id, name FROM slk_service";
										$result = pg_query($sql)
											or die('Could not Retrieve service names: ' . pg_last_error());
											
										while ($line = pg_fetch_assoc($result))
										{
											echo "<li><a href='energy_plot.php?type=service&service=",$line['name'],"'>",$line['name'],"</a>";
										}
									?>
								</ul>
							</li>
						</ul>
					</li>
				   <li class='has-sub'><a href='#'>Comsumption Ranking</a>
						<ul>
							<?php 
								$sql = "SELECT id, name FROM slk_metric";
								$result = pg_query($sql)
									or die('Could not Retrieve metric names: ' . pg_last_error());
									
								while ($line = pg_fetch_assoc($result))
								{
									echo "<li><a href='comsumption_ranking.php?metric=",$line['name'],"'>",$line['name'],"</a>";
								}
							?>
						</ul>
				   </li>
<!--
				   <li class='has-sub'><a href='#'>Code Signature Statistics</a>
						<ul>
							<li><a href='signature_statistics.php?type=operator'>By Operator Set</a></li>
							<li><a href='signature_statistics.php?type=size'>By Data Set Size</a></li>
						</ul>
				   </li>
-->
				</ul>
				</div>
		</div><!-- div menu -->
		
		<div id="content">
			
