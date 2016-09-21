<?php include 'header.php'; ?>

<nav id="Hmenu">
	<ul>
		<?php 
			$sql = "SELECT id, name FROM slk_query ORDER BY name";
			$result = pg_query($sql)
				or die('Could not Retrieve query names: ' . pg_last_error());
				
			while ($line = pg_fetch_assoc($result))
			{
				echo "<li><a href='?query=".$line['name']."'>".$line['name']."</a>";
			}
		?>
	</ul>
</nav>

<?php

	$type = $_SESSION['type'];
	$query_name = $_SESSION['query'];
	
	echo "<h1>" . $query_name . "</h1>";
	
	if ($type == "node")
	{
		if ($_SESSION['node'] == "all")
			generate_plot_by_node_all($query_name);
		else
			generate_plot_by_node($query_name);
	}
	else if ($type == "service")
	{
		if ($_SESSION['service'] == "all")
			generate_plot_by_service_all($query_name);
		else
			generate_plot_by_service($query_name);
	}
	else if ($type == "general")
	{
		 generate_general_plot($query_name);
	}
	else
	{
		echo "<h1>ERROR</h1>";
		echo "NOTHING TO SHOW";
		echo "Please, select the type of graph on the menu";
		echo " <================================";
	}
	
?>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".fancybox").fancybox();
		});
	</script>

<?php include 'footer.php'; ?>
