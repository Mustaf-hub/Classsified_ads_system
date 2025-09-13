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
$sel = $sellify->query("select * from tbl_brand where status=1 and subcat_id=".$subcat_id."");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['title'] = $row['title'];
		
		$pol['img'] = $row['img'];
		$pol['model_count'] = $sellify->query("select * from tbl_model where brand_id=".$row["id"]."")->num_rows;
		
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("bikescooterbrandlist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"Bike / Scooter Brand Not Founded!");
}
else 
{
$returnArr = array("bikescooterbrandlist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Bike / Scooter Brand List Founded!");
}
}
echo json_encode($returnArr);
?>