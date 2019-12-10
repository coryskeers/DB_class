<?php
echo("<html><head><title>Sample PHP Script</title></head>\n");

//  hostname, username, password
$dbcnx = mysql_connect("dbdev.cs.uiowa.edu:3306","dbdevtest","XiuyD=jP");
if (!$dbcnx) {
  echo( "<P>Unable to connect to the " .
        "database server at this time.</P>\n" );
  exit();
}
mysql_select_db("WorksOn",$dbcnx);
if (! @mysql_select_db("WorksOn") ) {
  echo( "<P>Unable to locate the sample " .
        "database at this time.</P>" );
  exit();
}
# do a simple query and print it out
$sql_query="SELECT ename, salary, dno FROM Emp";

$result_set = mysql_query($sql_query);
if (!$result_set) {
  echo("<P>Error performing query: " .
       mysql_error() . "</P>");
  exit();
}

echo("<h2>" . $sql_query . "</h2>");
echo("<table><tr><th>Name</th><th>Salary</th><th>dno</th></tr>\n");
while ( $row = mysql_fetch_array($result_set) ) {
  echo("<tr><td>" . $row["ename"] . "</td>\n" .
       "     <td>" . $row["salary"] . "</td>\n" .
       "     <td>" . $row["dno"] . "</td>\n" .
       "</tr>\n");
}
echo ("</table>\n");
echo ("</body></html>");
?>
