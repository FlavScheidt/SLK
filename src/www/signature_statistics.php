<?php include 'header.php'; 

	$type = $_SESSION['type'];
	
	if ($type == 'operator')
	{
		echo "<h1>Code Signature Energy Ranking</h1>";
			echo "<h2>By Code Signature</h2>";
		
		$sql = "SELECT * FROM return_energy_by_code()";
		$result = pg_query($sql)
			or die('Could not Retrieve points: ' . pg_last_error());
			
		$dir_act = getcwd();
		$dir = $dir_act."/plots/";
		
		if (!is_dir($dir))
			mkdir($dir);
		
		$dir_file = $dir."signature_ranking.dat";
		
		if (file_exists($dir_file))
			shell_exec("rm -rf ".$dir_file);

		$file = fopen($dir_file, 'w');
		
		$nRows = pg_num_rows($result);
				
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_assoc($result,$k);
			
			$line_to_write = $line['signature']."	".$line['mean']."	".$line['stddev']."\n";
			
			fwrite($file, $line_to_write);
		}

		fclose($file);

		shell_exec($dir_act."/bin/generate_bar_plot_signature.sh ".$dir_file);
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/signature_ranking.png' title='Energy Ranking'>";
		echo "<img src='http://localhost/plots/signature_ranking.png' alt=''/></a></center>";
	
		echo "<h2>By Job</h2>";
		
		echo "<p>Select the code sign on the table</p>";
		
		$sql = "SELECT id, sign FROM slk_code_sign";
		$result = pg_query($sql)
			or die('Could not Retrieve code signatures: ' . pg_last_error());
		
		echo "<center>";
		echo "<table>";
			echo "<tr>";
				echo "<td colspan='3'><h1>Query Metrics</h1></td>";
			echo "</tr>";
			echo "<tr>";
				echo "<th><h2>ID</h2></th>";
				echo "<th><h2>Signature</h2></th>";
				echo "<th width='40%'><h2>Jobs</h2></th>";
			echo "</tr>";

		while ($row = pg_fetch_assoc($result))
		{
			
			$sql = "SELECT * FROM return_energy_ranking_job(".$row['id'].")";
			$result2 = pg_query($sql)
				or die('Could not Retrieve information: ' . pg_last_error());
						
			$nRows = pg_num_rows($result2);
			
			$dir_act = getcwd();
			$dir = $dir_act."/plots/";
			
			//First file name
			if (!is_dir($dir))
				mkdir($dir);
			
			$line = pg_fetch_assoc($result2,0);
			$dir_file = $dir."ranking.".$row['id'].".dat";
			$dir_file2 	= $dir."ranking.".$row['id'].".dsz.dat";
						
			if (file_exists($dir_file))
				shell_exec("rm -rf ".$dir_file);
				
			if (file_exists($dir_file2))
				shell_exec("rm -rf ".$dir_file2);

			$file 	= fopen($dir_file, 'w');
			$file2 	= fopen($dir_file2, 'w');
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_assoc($result2,$k);
				
				$line_to_write = $line['query'].".".$line['job']."	".$line['mean']."	".$line['stddev']."\n";
				fwrite($file, $line_to_write);
				
				$line_to_write = $line['query'].".".$line['job']."	".$line['sz']."\n";
				fwrite($file2, $line_to_write);
			}
			fclose($file);
			fclose($file2);

			shell_exec($dir_act."/bin/generate_bar_plot_signature_job.sh ".$dir_file." ".$dir_file2);

			echo "<tr>";
				echo "<td>	".$row['id']."	</td>";
				
				$split_signature = explode(",", $row['sign']);
								
				echo "<td>";
					echo "<a class='fancybox' rel='group' href='http://localhost/plots/signature_ranking_".$row['id'].".png' title='Energy Ranking'>";
					foreach ($split_signature as $sign)
					{
						if (substr($sign, (strrpos($sign, ":")+1)) != "0")
							echo $sign."<b>|</b> ";
					}
					echo "</a>";
				echo "</td>";
				echo "<td>";
					for ($k = 0; $k < $nRows; $k++)
					{
						$line = pg_fetch_assoc($result2,$k);
						echo $line['query'].".".$line['job'].", ";
					}
				echo "</td>";
			echo "</tr>";
		}
		
		echo "</table>";
		echo "</center>";
	}
	else if ($type == 'size')
	{
		echo "<h1>Code Signature Energy Ranking</h1>";
		echo "<h2>By Data Set Size</h2>";
		
		//$sql = "SELECT * FROM return_energy_by_code()";
		//$result = pg_query($sql)
			//or die('Could not Retrieve points: ' . pg_last_error());
			
		$dir_act = getcwd();
		$dir = $dir_act."/plots/";
		
		if (!is_dir($dir))
			mkdir($dir);
		
		//$dir_file = $dir."signature_ranking_size.dat";
		
		//if (file_exists($dir_file))
			//shell_exec("rm -rf ".$dir_file);

		//$file = fopen($dir_file, 'w');
		
		//$nRows = pg_num_rows($result);
				
		//for ($k = 0; $k < $nRows; $k++)
		//{
			//$line = pg_fetch_assoc($result,$k);
			
			//$line_to_write = $line['signature']."	".$line['mean']."	".$line['stddev']."\n";
			
			//fwrite($file, $line_to_write);
		//}

		//fclose($file);

		//shell_exec($dir_act."/bin/generate_bar_plot_signature.sh ".$dir_file);
		
		//echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/signature_ranking.png' title='Energy Ranking'>";
		//echo "<img src='http://localhost/plots/signature_ranking.png' alt=''/></a></center>";
	
		//echo "<h2>By Job</h2>";
		
		//echo "<p>Select the code sign on the table</p>";
		
		$sql = "SELECT DISTINCT sz FROM slk_job_sign ORDER BY sz";
		$result = pg_query($sql)
			or die('Could not Retrieve data set sizes: ' . pg_last_error());
		
		echo "<center>";
		echo "<table>";
			echo "<tr>";
				echo "<td colspan='2'><h1>Sizes</h1></td>";
			echo "</tr>";
			echo "<tr>";
				echo "<th><h2>Size</h2></th>";
				echo "<th width='40%'><h2>Jobs</h2></th>";
			echo "</tr>";

		while ($row = pg_fetch_assoc($result))
		{
			
			$sql = "SELECT * FROM return_energy_ranking_by_size(".$row['sz'].")";
			$result2 = pg_query($sql)
				or die('Could not Retrieve information: ' . pg_last_error());
						
			$nRows = pg_num_rows($result2);
			
			$dir_act = getcwd();
			$dir = $dir_act."/plots/";
			
			//First file name
			if (!is_dir($dir))
				mkdir($dir);
			
			$line = pg_fetch_assoc($result2,0);
			$dir_file = $dir."ranking.".$row['sz'].".dat";
			$dir_file2 	= $dir."ranking.".$row['sz'].".sign.dat";
						
			if (file_exists($dir_file))
				shell_exec("rm -rf ".$dir_file);
				
			if (file_exists($dir_file2))
				shell_exec("rm -rf ".$dir_file2);

			$file 	= fopen($dir_file, 'w');
			$file2 	= fopen($dir_file2, 'w');
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_assoc($result2,$k);
				
				$line_to_write = $line['query'].".".$line['job']."	".$line['mean']."	".$line['stddev']."\n";
				fwrite($file, $line_to_write);
				
				$line_to_write = $line['query'].".".$line['job']."	".$line['sign']."\n";
				fwrite($file2, $line_to_write);
			}
			fclose($file);
			fclose($file2);

			shell_exec($dir_act."/bin/generate_bar_plot_signature_size.sh ".$dir_file." ".$dir_file2);

			echo "<tr>";
				echo "<td>";
					echo "<a class='fancybox' rel='group' href='http://localhost/plots/signature_ranking_".$row['sz'].".png' title='".$row['sz']."'>".$row['sz']."</a>";
				echo "</td>";
				echo "<td>";
					for ($k = 0; $k < $nRows; $k++)
					{
						$line = pg_fetch_assoc($result2,$k);
						echo $line['query'].".".$line['job'].", ";
					}
				echo "</td>";
			echo "</tr>";
		}
		
		echo "</table>";
		echo "</center>";
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
