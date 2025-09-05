<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
header('Content-type: text/json');
$sel = $sellify->query("select * from tbl_payment_list where status =1 ");
$myarray = array();
while($row = $sel->fetch_assoc())
{
	$myarray[] = $row;
}
$returnArr = array("paymentdata"=>$myarray,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Payment Gateway List Founded!");
echo json_encode($returnArr);
?> 