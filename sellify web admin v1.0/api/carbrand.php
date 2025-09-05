<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';

header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{


$pol = array();
$c = array();
$sel = $sellify->query("select * from sellify_brand where status=1");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['title'] = $row['title'];
		
		$pol['img'] = $row['img'];
		$pol['variation_count'] = $sellify->query("select * from sellify_variation where brand_id=".$row["id"]."")->num_rows;
		
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("sellifybrandlist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"sellify Brand Not Founded!");
}
else 
{
$returnArr = array("sellifybrandlist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"sellify Brand List Founded!");
}
}
echo json_encode($returnArr);
?>