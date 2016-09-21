<?php

	function generate_general_table($query_name)
	{
		$sql = "SELECT * FROM return_metrics_avg_general('".$query_name."')";
		$result = pg_query($sql)
			or die('Could not Retrieve data: ' . pg_last_error());
		
		echo "<center>";
		echo "<table>";
			echo "<tr>";
				echo "<td colspan='6'><h1>Query Metrics</h1></td>";
			echo "</tr>";
			echo "<tr>";
				echo "<th><h2>Metric</h2></th>";
				echo "<th><h2>Unit</h2></th>";
				echo "<th><h2>Mean</h2></th>";
				echo "<th><h2>Max</h2></th>";
				echo "<th><h2>Min</h2></th>";
				echo "<th><h2>StdDev</h2></th>";
			echo "</tr>";

		while ($row = pg_fetch_assoc($result))
		{
			echo "<tr>";
				echo "<td>".$row['metric']."</td>";
				echo "<td>".$row['unit']."</td>";
				echo "<td>".$row['mean']."</td>";
				echo "<td>".$row['max']."</td>";
				echo "<td>".$row['min']."</td>";
				echo "<td>".$row['stddev']."</td>";
			echo "</tr>";
		}
		
		echo "</table>";
		echo "</center>";
	}
	
	function generate_job_table($query_name)
	{
		$sql = "SELECT * FROM return_code_sign_by_query('".$query_name."')";
		$result = pg_query($sql)
			or die('Could not Retrieve data: ' . pg_last_error());
		
		echo "<center>";
		echo "<table>";
			echo "<tr>";
				echo "<td colspan='6'><h1>Jobs Code Signatures</h1></td>";
			echo "</tr>";
			echo "<tr>";
				echo "<th><h2>Job</h2></th>";
				echo "<th><h2>Code Signature</h2></th>";
				echo "<th><h2>Data Size</h2></th>";
			echo "</tr>";

		while ($row = pg_fetch_assoc($result))
		{
			echo "<tr>";
				echo "<td>".$row['job']."</td>";
				echo "<td>";
					$split_signature = explode(",", $row['sign']);
					foreach ($split_signature as $sign)
					{
						if (substr($sign, (strrpos($sign, ":")+1)) != "0")
							echo $sign."<b>|</b> ";
					}
				echo "</td>";
				echo "<td>".$row['sz']." bytes </td>";
			echo "</tr>";
		}
		
		echo "</table>";
		echo "</center>";
	}
	
	function generate_table($query_name, $node, $service)
	{
		$sql = "SELECT * FROM return_metrics_avg('".$query_name."', '".$service."', '".$node."')";
		$result = pg_query($sql)
			or die('Could not Retrieve data: ' . pg_last_error());
		
		echo "<center>";
		echo "<table>";
			echo "<tr>";
				echo "<td colspan='6'><h1>Query Metrics</h1></td>";
			echo "</tr>";
			echo "<tr>";
				echo "<th><h2>Metric</h2></th>";
				echo "<th><h2>Unit</h2></th>";
				echo "<th><h2>Mean</h2></th>";
				echo "<th><h2>Max</h2></th>";
				echo "<th><h2>Min</h2></th>";
				echo "<th><h2>StdDev</h2></th>";
			echo "</tr>";

		while ($row = pg_fetch_assoc($result))
		{
			echo "<tr>";
				echo "<td>".$row['metric']."</td>";
				echo "<td>".$row['unit']."</td>";
				echo "<td>".$row['mean']."</td>";
				echo "<td>".$row['max']."</td>";
				echo "<td>".$row['min']."</td>";
				echo "<td>".$row['stddev']."</td>";
			echo "</tr>";
		}
		
		echo "</table>";
		echo "</center>";
	}

	function generate_energy_bar($query_name)
	{
		$sql = "SELECT * FROM return_energy_by_job('".$query_name."')";
		$result = pg_query($sql)
			or die('Could not Retrieve information: ' . pg_last_error());
					
		$nRows = pg_num_rows($result);
		
		$dir_act = getcwd();
		$dir = $dir_act."/plots/";
		
		//First file name
		if (!is_dir($dir))
			mkdir($dir);
		
		$line = pg_fetch_assoc($result,0);
		$dir_file = $dir."bar.".$query_name.".".$line['job'].".".$line['node'].".".$line['service'].".dat";
		$file_bash = $dir_file;
					
		if (file_exists($dir_file))
			shell_exec("rm -rf ".$dir_file);

		$file = fopen($dir_file, 'w');
		
		$service_ant = "";
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_assoc($result,$k);
			
			$line_to_write = $line['job']."	".$line['node']."	".$line['service']."	".$line['mean']."	".$line['stddev']."\n";
			
			if ($k != 0 && $line['service'] != $service_ant)
			{
				fclose($file);
				$dir_file = $dir."bar.".$query_name.".".$line['job'].".".$line['node'].".".$line['service'].".dat";
				$file_bash = $file_bash." ".$dir_file;
				
				if (file_exists($dir_file))
					shell_exec("rm -rf ".$dir_file);
			
				$file = fopen($dir_file, 'w');
			}

			fwrite($file, $line_to_write);
			
			$service_ant = $line['service'];
			
		}
		
		fclose($file);

		shell_exec($dir_act."/bin/generate_bar_plot_energy.sh ".$file_bash);
	
	}

	function generate_general_plot($query_name)
	{
		
		$nPlots=0;
		
		//Nodes
		$sql = "SELECT name FROM slk_node";
		$result1 = pg_query($sql)
			or die('Could not Retrieve nodes names: ' . pg_last_error());
			
		$max_node = pg_num_rows($result1);
			
		for ($i=0; $i < $max_node; $i++)
		{
			$node = pg_fetch_result($result1, $i, 0);
			
			//Services
			$sql = "SELECT name FROM slk_service";
			$result2 = pg_query($sql)
				or die('Could not Retrieve service names: ' . pg_last_error());
				
			$max_service = pg_num_rows($result2);	
				
			for ($j=0; $j < $max_service; $j++)
			{
				$service = pg_fetch_result($result2, $j, 0);
				
				$dir_act = getcwd();
				$dir = $dir_act."/plots/";
				
				if (!is_dir($dir))
					mkdir($dir);
		
				$dir_file = $dir.$node.".".$service.".".$query_name.".dat";
					
				if (file_exists($dir_file))
					shell_exec("rm -rf ".$dir_file);

				$file = fopen($dir_file, 'w');
					
				//Points
				$sql = "SELECT * FROM return_plots_avg('".$query_name."','".$service."','".$node."')";
				$result3 = pg_query($sql)
					or die('Could not Retrieve points: ' . pg_last_error());
								
				
				$nRows = pg_num_rows($result3);
				
				for ($k = 0; $k < $nRows; $k++)
				{
					$line = pg_fetch_row($result3,$k);
					
					$line_to_write = $line[0]."	".$line[1]."\n";
					
					fwrite($file, $line_to_write);
				}
				
				fclose($file);
				
				//Jobs
				$sql = "SELECT * FROM return_job_avg_time('".$query_name."')";
				$result4 = pg_query($sql)
					or die('Could not Retrieve points: ' . pg_last_error());
				
				$filename_job = $dir.$node.".".$service.".".$query_name.".job.dat";
				
				if (file_exists($filename_job))
					shell_exec("rm -rf ".$filename_job);
				
				$file_job = fopen($filename_job, 'w');
				
				$nRows = pg_num_rows($result4);
				
				for ($k = 0; $k < $nRows; $k++)
				{
					$line = pg_fetch_row($result4,$k);
					
					$line_to_write = $line[0]."	".$line[1]."\n";
					
					fwrite($file_job, $line_to_write);
				}
				
				fclose($file_job);
				
				shell_exec($dir_act."/bin/generate_plot.sh ".$dir_file);
				
				$images[] = $node.".".$service.".".$query_name;
				
				$nPlots++;
			}
		}
		
		$last = "";
		
		foreach ($images as $image) 
			$last = $last." ".$dir.$image.".dat";
		
		$r=shell_exec($dir_act."/bin/generate_plot.sh ".$last);
		
		echo "<h2>All</h2>";
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/energy_plot_".$query_name.".png' title='".$query_name."'>";
		echo "<img src='http://localhost/plots/energy_plot_".$query_name.".png' alt='' class='energy_plot_general'/></a>";
		
		echo "<a class='fancybox' rel='group' href='http://localhost/plots/bar.".$query_name.".png' title='".$query_name."'>";
		echo "<img src='http://localhost/plots/bar.".$query_name.".png' alt='' class='energy_plot_general'/></a></center>";
		
		generate_energy_bar($query_name);

		//generate_job_table($query_name);
		generate_general_table($query_name);
		
		foreach ($images as $image) 
		{
			$tam = strlen($image);
			
			$pos1 = strpos($image, "."); //backwards
			$pos2 = strrpos($image, ".");
			
			$title_node = substr($image, 0, $pos1);
			$title_service = substr($image, $pos1 + 1, $pos2 - $pos1 - 1);
			
			echo "<h2>".$title_node." ".$title_service."</h2>";
			
			echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/".$image.".png' title='".$query_name." ".$title_node." ".$title_service."'>";
			echo "<img src='http://localhost/plots/".$image.".png' alt='".$title_node." ".$title_service."' class='energy_plot'/></a></center>";
			
			generate_table($query_name, $node, $service);
		}
	}
	
	
	
	function generate_plot_by_node($query_name)
	{
		$nPlots=0;
		
		$node = $_SESSION['node'];
					
		//Points
		$sql = "SELECT * FROM return_plot_by_node('".$query_name."','".$node."')";
		$result3 = pg_query($sql)
			or die('Could not Retrieve points: ' . pg_last_error());
						
						
		$dir_act = getcwd();
		$dir = $dir_act."/plots/";
		
		if (!is_dir($dir))
			mkdir($dir);
		
		$dir_file = $dir.$node.".".$query_name.".dat";
					
		if (file_exists($dir_file))
			shell_exec("rm -rf ".$dir_file);

		$file = fopen($dir_file, 'w');
		
		$nRows = pg_num_rows($result3);
		
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_row($result3,$k);
			
			$line_to_write = $line[0]."	".$line[1]."\n";
			
			fwrite($file, $line_to_write);
		}
		
		fclose($file);
		
		//Jobs
		$sql = "SELECT * FROM return_job_avg_time('".$query_name."')";
		$result4 = pg_query($sql)
			or die('Could not Retrieve points: ' . pg_last_error());
		
		$filename_job = $dir.$node.".".$query_name.".job.dat";
		
		if (file_exists($filename_job))
			shell_exec("rm -rf ".$filename_job);
		
		$file_job = fopen($filename_job, 'w');
		
		$nRows = pg_num_rows($result4);
		
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_row($result4,$k);
			
			$line_to_write = $line[0]."	".$line[1]."\n";
			
			fwrite($file_job, $line_to_write);
		}
		
		fclose($file_job);
				
		shell_exec($dir_act."/bin/generate_plot.sh ".$dir_file);
		
		
		echo "<h2>".$node."</h2>";
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/".$node.".".$query_name.".png' title='".$query_name." ".$node."'>";
		echo "<img src='http://localhost/plots/".$node.".".$query_name.".png' alt='".$query_name." ".$node."' class='energy_plot'/></a></center>";
		
		//generate_general_table($query_name, $node, $service);

	}
	
	function generate_plot_by_node_all($query_name)
	{
				$nPlots=0;
		
		//Nodes
		$sql = "SELECT name FROM slk_node";
		$result1 = pg_query($sql)
			or die('Could not Retrieve nodes names: ' . pg_last_error());
			
		$max_node = pg_num_rows($result1);
			
		for ($i=0; $i < $max_node; $i++)
		{
			$node = pg_fetch_result($result1, $i, 0);
				
			$dir_act = getcwd();
			$dir = $dir_act."/plots/";
			
			if (!is_dir($dir))
				mkdir($dir);
		
			$dir_file = $dir.$node.".all.".$query_name.".dat";
				
			if (file_exists($dir_file))
				shell_exec("rm -rf ".$dir_file);

			$file = fopen($dir_file, 'w');
					
			//Points
			$sql = "SELECT * FROM return_plot_by_node('".$query_name."','".$node."')";
			$result3 = pg_query($sql)
				or die('Could not Retrieve points: ' . pg_last_error());
							
			
			$nRows = pg_num_rows($result3);
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_row($result3,$k);
				
				$line_to_write = $line[0]."	".$line[1]."\n";
				
				fwrite($file, $line_to_write);
			}
			
			fclose($file);
			
			//Jobs
			$sql = "SELECT * FROM return_job_avg_time('".$query_name."')";
			$result4 = pg_query($sql)
				or die('Could not Retrieve points: ' . pg_last_error());
			
			$filename_job = $dir.$node.".all.".$query_name.".job.dat";
			
			if (file_exists($filename_job))
				shell_exec("rm -rf ".$filename_job);
				
			$file_job = fopen($filename_job, 'w');
			
			$nRows = pg_num_rows($result4);
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_row($result4,$k);
				
				$line_to_write = $line[0]."	".$line[1]."\n";
				
				fwrite($file_job, $line_to_write);
			}
			
			fclose($file_job);
			
			shell_exec($dir_act."/bin/generate_plot.sh ".$dir_file);
			
			$images[] = $node.".all.".$query_name;
			
			$nPlots++;
		}
	
		$last = "";
		
		foreach ($images as $image) 
			$last = $last." ".$dir.$image.".dat";
			
		$r=shell_exec($dir_act."/bin/generate_plot.sh ".$last);
		
		echo "<h2>All</h2>";
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/energy_plot_".$query_name.".png'>";
		echo "<img src='http://localhost/plots/energy_plot_".$query_name.".png' alt='".$query_name."' class='energy_plot'/></a></center>";

	}
	
	function generate_plot_by_service($query_name)
	{
		$nPlots=0;
		
		$service = $_SESSION['service'];
					
		//Points
		$sql = "SELECT * FROM return_plot_by_service('".$query_name."','".$service."')";
		$result3 = pg_query($sql)
			or die('Could not Retrieve points: ' . pg_last_error());
						
						
		$dir_act = getcwd();
		$dir = $dir_act."/plots/";
		
		if (!is_dir($dir))
			mkdir($dir);
		
		$dir_file = $dir.$service.".".$query_name.".dat";
					
		if (file_exists($dir_file))
			shell_exec("rm -rf ".$dir_file);

		$file = fopen($dir_file, 'w');
		
		$nRows = pg_num_rows($result3);
		
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_row($result3,$k);
			
			$line_to_write = $line[0]."	".$line[1]."\n";
			
			fwrite($file, $line_to_write);
		}
		
		fclose($file);
		
		//Jobs
		$sql = "SELECT * FROM return_job_avg_time('".$query_name."')";
		$result4 = pg_query($sql)
			or die('Could not Retrieve points: ' . pg_last_error());
		
		$filename_job = $dir.$service.".".$query_name.".job.dat";
		
		if (file_exists($filename_job))
			shell_exec("rm -rf ".$filename_job);
		
		$file_job = fopen($filename_job, 'w');
		
		$nRows = pg_num_rows($result4);
		
		for ($k = 0; $k < $nRows; $k++)
		{
			$line = pg_fetch_row($result4,$k);
			
			$line_to_write = $line[0]."	".$line[1]."\n";
			
			fwrite($file_job, $line_to_write);
		}
		
		fclose($file_job);
				
		shell_exec($dir_act."/bin/generate_plot.sh ".$dir_file);
		
		
		echo "<h2>".$service."</h2>";
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/".$service.".".$query_name.".png' title='".$query_name." ".$service."'>";
		echo "<img src='http://localhost/plots/".$service.".".$query_name.".png' alt='".$query_name." ".$service."' class='energy_plot'/></a></center>";
		
		//generate_general_table($query_name, $node, $service);

	}

	function generate_plot_by_service_all($query_name)
	{
				$nPlots=0;
		
		//services
		$sql = "SELECT name FROM slk_service";
		$result1 = pg_query($sql)
			or die('Could not Retrieve services names: ' . pg_last_error());
			
		$max_service = pg_num_rows($result1);
			
		for ($i=0; $i < $max_service; $i++)
		{
			$service = pg_fetch_result($result1, $i, 0);
				
			$dir_act = getcwd();
			$dir = $dir_act."/plots/";
			
			if (!is_dir($dir))
				mkdir($dir);
		
			$dir_file = $dir."all.".$service.".".$query_name.".dat";
				
			if (file_exists($dir_file))
				shell_exec("rm -rf ".$dir_file);

			$file = fopen($dir_file, 'w');
					
			//Points
			$sql = "SELECT * FROM return_plot_by_service('".$query_name."','".$service."')";
			$result3 = pg_query($sql)
				or die('Could not Retrieve points: ' . pg_last_error());
							
			
			$nRows = pg_num_rows($result3);
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_row($result3,$k);
				
				$line_to_write = $line[0]."	".$line[1]."\n";
				
				fwrite($file, $line_to_write);
			}
			
			fclose($file);
			
			//Jobs
			$sql = "SELECT * FROM return_job_avg_time('".$query_name."')";
			$result4 = pg_query($sql)
				or die('Could not Retrieve points: ' . pg_last_error());
			
			$filename_job = $dir."all.".$service.".".$query_name.".job.dat";
			
			if (file_exists($filename_job))
				shell_exec("rm -rf ".$filename_job);
				
			$file_job = fopen($filename_job, 'w');
			
			$nRows = pg_num_rows($result4);
			
			for ($k = 0; $k < $nRows; $k++)
			{
				$line = pg_fetch_row($result4,$k);
				
				$line_to_write = $line[0]."	".$line[1]."\n";
				
				fwrite($file_job, $line_to_write);
			}
			
			fclose($file_job);
			
			shell_exec($dir_act."/bin/generate_plot.sh ".$dir_file);
			
			$images[] = "all.".$service.".".$query_name;
			
			$nPlots++;
		}
	
		$last = "";
		
		foreach ($images as $image) 
			$last = $last." ".$dir.$image.".dat";
			
		$r=shell_exec($dir_act."/bin/generate_plot.sh ".$last);
		
		echo "<h2>All</h2>";
		
		echo "<center><a class='fancybox' rel='group' href='http://localhost/plots/energy_plot_".$query_name.".png' title='".$query_name."'>";
		echo "<img src='http://localhost/plots/energy_plot_".$query_name.".png' alt='".$query_name."' class='energy_plot'/></a></center>";
	}

?>
