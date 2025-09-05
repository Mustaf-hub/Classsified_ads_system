<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '' || $data['package_type'] == '')
{
    $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");
}
else
{
    $uid = strip_tags(mysqli_real_escape_string($sellify,$data['uid']));
	$package_type = $data['package_type'];
    
   if($package_type == 'Feature')
   {	   
$check = $sellify->query("select * from  tbl_package where status=1 and post_type='Featured_Based'");
   }
   else 
   {
	   $check = $sellify->query("select * from  tbl_package where status=1 and post_type IN('Featured_Based','Both')");
   }
$op = array();
while($row = $check->fetch_assoc())
{
		$op[] = $row;
}
$returnArr = array("PackageData"=>$op,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Package List Get Successfully!!");
}
echo json_encode($returnArr);