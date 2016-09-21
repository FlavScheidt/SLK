<?php include 'header.php'; ?>

				
			<h1>SLK</h1>
			
			<p><b>SLK</b> is a tool to collect, store and analyze data about energy comsumption on MapReduce clusters.</p>
			
			<h2>Instructions</h2>
			
			<ul>
				<li>Configure and install Salaak on you Hadoop Cluster</li>
				<li>Execute salaak on your Hadoop Cluster</li>
				<li>Analyze the graphs on the web interface</li>
			</ul>
			
			<h2>About the Graphs</h2>
			
			<h3>Energy Plots</h3>
			
			<p>Energy plots shows the power consumed by a query on a timeline. <b>General</b> information gives a general view
			of all the nodes and all the services, the first graphs uts all together, the second one compares the average comsumprion by job.
			The rest details the consumption by service and node, followed by a table with the average, min and max values for each metric</p>
			<p>Energy plot <b>By Node</b> cluster the information of the average consumption of a node during the execution of the query. 
			Which means that we have the average power consumed by every service on that node. Energy plots <b>By Service</b> shows the information
			by service, which means the average power consumed by a service on every node.</p>
			
			<h3>Consumption Ranking</h3>
			<p><b>Comsumption Ranking</b> provides bar graphs with rankings of comsumption of every query to a choosen metric.
			
<!--
			<h3>Code Signature Statistics</h3>
			
			<p><b>Code Signature Statistics</b> shows rankings of comsumption clustered by the code signature of the jobs and a table that 
			connects the code signature to the jobs, with grahs comparing all the jobs that has the same code signature.</p>
-->
			
<?php include 'footer.php'; ?>
