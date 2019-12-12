<?php
echo("<html><head><title>Sample PHP Script</title></head>\n");

$hostname = 'dbdev.cs.uiowa.edu';
$username = 'cskeers';
$password = '';
$db_name = 'db_cskeers';

//  hostname, username, password
$dbcnx = mysql_connect($hostname, $username, $password);
if (!$dbcnx) {
  echo( "<P>Unable to connect to the " .
        "database server at this time.</P>\n" );
  exit();
}
mysql_select_db($db_name,$dbcnx);
if (! @mysql_select_db($db_name) ) {
  echo( '<P>Unable to locate the sample "$db_name"' .
        'database at this time.</P>' );
  exit();
}
/**
 * Create 3 queries to use with our DB.
 * class example: $sql_query="SELECT ename, salary, dno FROM Emp";
 * Query 1: Who are our top 50% most active customers, and what is there average trip distance, trip price, and tip amount?
 * 
 * Query 2: Do drivers who maintain an average rating above a 3.0 receive greater average tips than those drivers with below a 3.0 average?
 * 
 * Query 3: Which driver made the most money in the last three months, and how much was that?
 * 
 * SELECT c.customer_name, AVG(t.trip_distance), 
 * AVG(p.payment_amount), AVG(p.payment_tip / p.payment_amount)
 * FROM customers c
 * JOIN driver_customer_trips dct
 * ON c.customer_id = dct.customer_id
 * JOIN trips t
 * ON dct.trip_id = t.trip_id
 * JOIN driver_customer_payments dcp
 * ON c.customer_id = dcp.customer_id
 * JOIN payments p
 * ON p.payment_id = dcp.payment_id
 * GROUP BY c.customer_name;
 * 
 * select avg(a.payment_tip), avg(b.payment_tip) from 
 * (SELECT avg(payment_tip)
 * FROM driver_customer_payments, payments, driver_rating
 * ON driver_id
 * WHERE avg(driver_rating.rate) > 3.0)
 * ) a,
 * (SELECT avg(payment_tip)
 * FROM driver_customer_payments, payments, driver_rating
 * ON driver_id
 * WHERE avg(driver_rating.rate) <= 3.0)
 * ) b;
 * 
 * SELECT driver_name, SUM(payment_amount)
 * FROM drivers, payments, driver_customer_payments
 * ON driver_id
 * ORDER BY SUM(payment_amount) DESC
 * LIMIT 1;
 *  
 **/
$sql_queries = array();
$sql_queries[] = "SELECT customer_name, AVG(trip_distance), AVG(payment_amount), AVG(payment_tip / payment_amount) AS avg_tip_percent
	FROM 
		(SELECT customer_id FROM driver_customer_trips
			HAVING COUNT(customer_id) > (SELECT MAX(COUNT(customer_id)) * 0.75 FROM driver_customer_trips)) dct
		INNER JOIN customers c
		ON c.customer_id = dct.customer_id
		INNER JOIN driver_customer_payments dcp
		ON c.customer_id = dcp.customer_id
		INNER JOIN payments p
		ON dcp.payment_id = p.payment_id;";
$sql_queries[] = "SELECT AVG(a.payment_tip) AS ratings_above_3, avg(b.payment_tip) AS ratings_below_3
	FROM (SELECT avg(payment_tip)
		FROM driver_rating dr
		HAVING dr.rate > 3.0
		GROUP BY dr.driver_id
	INNER JOIN driver_customer_payments dcp
		ON dr.driver_id = dcp.driver_id
	INNER JOIN payments p
		ON p.payment_id = dcp.payment_id) a,
		(SELECT avg(payment_tip)
		FROM driver_rating dr
		HAVING dr.rate > 3.0
		GROUP BY dr.driver_id
	INNER JOIN driver_customer_payments dcp
		ON dr.driver_id = dcp.driver_id
	INNER JOIN payments p
		ON p.payment_id = dcp.payment_id) b;";
$sql_queries[] = "SELECT driver_name, SUM(payment_amount) as total_payments
	FROM drivers d INNER JOIN driver_customer_payments dcp
	ON d.driver_id = dcp.driver_id INNER JOIN payments p
	ON dcp.payment_id = p.payment_id
	ORDER BY total_payments DESC
	LIMIT 1;
FROM drivers, payments, driver_customer_payments
ON driver_id
ORDER BY SUM(payment_amount) DESC
LIMIT 1;";
$headings = array();
$headings[] = array('Customer Name','Avg. Trip Distance','Avg. Payment','Avg. Tip %');
$headings[] = array('Avg. Tip Received');
$headings[] = array('Driver Name','Total Payments Received');

$iter = 0;
foreach ($sql_queries as $sql_query) {
     $result_set = mysql_query($sql_query);
     if (!$result_set) {
     echo("<P>Error performing query: " .
          mysql_error() . "</P>");
     exit();
     }

     echo("<h2>" . $sql_query . "</h2>");
     echo("<table><tr>");
     foreach ($headings[$iter++] as $heading) {
          echo("<th>" . $heading . "</th");
     }
     // echo("<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n");
     echo("</tr>\n");
     
     while ( $row = mysql_fetch_array($result_set) ) {
     /*
          echo("<tr><td>" . $row["ename"] . "</td>\n" .
          "     <td>" . $row["salary"] . "</td>\n" .
          "     <td>" . $row["dno"] . "</td>\n" .
          "</tr>\n");
     */
          echo("<tr>");
          foreach ($row as $item) {
               echo("<td>" . $item . "</td>\n") 
          }
          echo("</tr>\n");
     }

     echo ("</table>\n");
}
echo ("</body></html>");
?>
