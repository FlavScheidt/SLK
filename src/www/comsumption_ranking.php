<?php include 'header.php'; 

	$metric = $_GET['metric'];
	
	echo "<h1>".$metric."</h1>";
	
	$sql = "SELECT * FROM return_metrics_comparison('".$metric."')";
	$result = pg_query($sql)
		or die('Could not Retrieve points: ' . pg_last_error());
		
	$dir_act = getcwd();
	$dir = $dir_act."/plots/";
	
	if (!is_dir($dir))
		mkdir($dir);
	
	$dir_file = str_replace(' ', '', $dir.$metric.".query.dat");
	
	if (file_exists($dir_file))
		shell_exec("rm -rf ".$dir_file);

	$file = fopen($dir_file, 'w');
	
	$nRows = pg_num_rows($result);
			
	for ($k = 0; $k < $nRows; $k++)
	{
		$line = pg_fetch_assoc($result,$k);
		
		$line_to_write = $line['query']."	".$line['mean']."	".$line['stddev']."\n";
		
		fwrite($file, $line_to_write);
	}

	fclose($file);

	shell_exec($dir_act."/bin/generate_bar_plot.sh ".$dir_file." ".$line['unit']);
	
	echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/".str_replace(' ', '', $metric.".query.png")."' title='".$metric."'>";
	echo "<img src='http://localhost/plots/".str_replace(' ', '', $metric.".query.png")."' alt=''/></a></center>";

?>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".fancybox").fancybox();
		});
	</script>

<?php include 'footer.php'; ?>
