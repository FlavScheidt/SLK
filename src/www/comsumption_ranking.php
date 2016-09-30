<?php include 'header.php'; 

	$metric = $_GET['metric'];
	
	echo "<h1>".$metric."</h1>";
	
	if ($metric = "Energy PKG")
	{
		echo "<h2>Average</h2>";
	}
	
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

	if ($metric = "Energy PKG")
	{

		echo "<h2>Sum</h2>";
		
		$sql2 = "SELECT * FROM return_energy_ranking_sum()";
		$result2 = pg_query($sql2)
			or die('Could not Retrieve points: ' . pg_last_error());
		
		$dir_file2 = str_replace(' ', '', $dir.$metric.".sum.dat");

		$file2 = fopen($dir_file2, 'w');
		
		$nRows2 = pg_num_rows($result2);

		for ($k = 0; $k < $nRows2; $k++)
		{
			$line2 = pg_fetch_assoc($result2,$k);
			
			$line_to_write2 = $line2['query']."	".$line2['sm']."\n";
			
			fwrite($file2, $line_to_write2);
		}

		fclose($file2);

		shell_exec($dir_act."/bin/generate_plot_sum_energy.sh ".$dir_file2." [W]");
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/".str_replace(' ', '', $metric.".sum.png")."' title='".$metric."'>";
		echo "<img src='http://localhost/plots/".str_replace(' ', '', $metric.".sum.png")."' alt=''/></a></center>";
	}

?>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".fancybox").fancybox();
		});
	</script>

<?php include 'footer.php'; ?>
