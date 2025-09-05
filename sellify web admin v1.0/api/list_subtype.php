<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';

header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '' || $data['subcat_id'] == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{


$pol = array();
$c = array();
$subcat_id = $data['subcat_id'];
$sel = $sellify->query("select * from tbl_type where status=1 and subcat_id=".$subcat_id."");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['subcat_id'] = $row['subcat_id'];
		$pol['title'] = $row['title'];
		
		
		
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("subtypelist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"Subcategory Type Not Founded!");
}
else 
{
$returnArr = array("subtypelist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Subcategory Type List Founded!");
}
}
echo json_encode($returnArr);
?>