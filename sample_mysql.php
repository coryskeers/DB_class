<?php
echo("<html><head><title>Sample PHP Script</title></head>\n");

$hostname = 'dbdev.cs.uiowa.edu';
$username = 'cskeers';
$password = 'DerOL5qhDx960ZM';
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
 * Query 1: For repeat customers, what is there average trip distance, trip price, and tip amount?
 * 
 * Query 2: Do drivers who maintain an average rating above a 3.0 receive greater average tips than those drivers with below a 3.0 average?
 * 
 * Query 3: Which driver made the most money in the last three months, and how much was that? (sample data doesn't have enough of a timespan for the 3month part of this)
 * 
 **/
$sql_queries = array();
$sql_queries[] = "SELECT customer_name, AVG(trip_distance), AVG(payment_amount), AVG(payment_tip / payment_amount) AS avg_tip_percent
	FROM driver_customer_trips dct, trips t, customers c, driver_customer_payments dcp, payments p
	GROUP BY c.customer_id
	HAVING COUNT(dct.customer_id) > 1";
$sql_queries[] = "SELECT  AVG(rate) AS avg_driver_rating_above_3, AVG(payment_tip) AS avg_tip_above_3
	FROM driver_ratings, driver_customer_payments, payments
	HAVING AVG(rate) > 3.0
	UNION
	SELECT AVG(rate) AS avg_driver_rating_below_3, AVG(payment_tip) AS avg_tip_below_3
	FROM driver_ratings, driver_customer_payments, payments
	HAVING AVG(rate) <= 3.0";
$sql_queries[] = "SELECT driver_name, SUM(payment_amount) as total_payments
	FROM drivers d
	INNER JOIN driver_customer_payments dcp
	ON d.driver_id = dcp.driver_id
	INNER JOIN payments p
	ON dcp.payment_id = p.payment_id
	ORDER BY total_payments DESC
	LIMIT 1";
$headings = array();
$headings[] = array('Customer Name','Avg. Trip Distance','Avg. Payment','Avg. Tip %');
$headings[] = array('Avg. Rating','Avg. Tip Received');
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
          echo("<th>" . $heading . "</th>");
     }
     echo("</tr>");
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
          for ($i = 0; $i < count($row); $i++) {
               echo("<td>" . $row[$i] . "</td>\n");
          }
          echo("</tr>\n");
     }

     echo ("</table>\n");
}
echo ("</body></html>");
?>
