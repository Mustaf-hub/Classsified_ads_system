<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';

header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '' || $data['cat_id'] == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{
$cat_id = $data['cat_id'];
$uid = $data['uid'];

$pol = array();
$c = array();
$sel = $sellify->query("select * from tbl_subcategory where status=1 and cat_id=".$cat_id."");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['title'] = $row['title'];
		$pol['included_subtype'] = $row['type_id'];
		$pol['included_subtype_format_is_pill'] = $row['is_pill'];
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("subcategorylist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"SubCategory Not Founded!");
}
else 
{
$returnArr = array("subcategorylist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"SubCategory List Founded!");
}
}
echo json_encode($returnArr);
?>