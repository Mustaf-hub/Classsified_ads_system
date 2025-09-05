<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';

header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '' || $data['brand_id'] == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{


$pol = array();
$c = array();
$brand_id = $data['brand_id'];
$sel = $sellify->query("select * from sellify_variation where status=1 and brand_id=".$brand_id."");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['brand_id'] = $row['brand_id'];
		$pol['title'] = $row['title'];
		
		$pol['variation_type_count'] = $sellify->query("select * from sellify_variation_type where brand_id=".$row["brand_id"]." and variation_id=".$row["id"]."")->num_rows;
		
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("sellifyvariationlist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"sellify Variation Not Founded!");
}
else 
{
$returnArr = array("sellifyvariationlist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"sellify Variation List Founded!");
}
}
echo json_encode($returnArr);
?>