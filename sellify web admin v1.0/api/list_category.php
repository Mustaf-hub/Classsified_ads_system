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
$uid = $data['uid'];
$pol = array();
$c = array();
$sel = $sellify->query("select * from tbl_category where status=1");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['title'] = $row['title'];
		
		$pol['img'] = $row['img'];
		$pol['total_free_post_allow'] = $row['total_post'];
		$pol['subcat_count'] = $sellify->query("select * from tbl_subcategory where cat_id=".$row["id"]."")->num_rows;
		$check_post = $sellify->query("select * from tbl_post where cat_id=".$row['id']." and uid=".$uid."")->num_rows;
        if($row['total_post'] >= $check_post && $pol['total_free_post_allow'] !=0)
		{
			$pol['is_paid'] = 0 ;
		}
        else 
		{
			$pol['is_paid'] = 1;
		}			
		$c[] = $pol;
	
	
}
if(empty($c))
{
	$returnArr = array("categorylist"=>$c,"ResponseCode"=>"200","Result"=>"false","ResponseMsg"=>"Category Not Founded!");
}
else 
{
$returnArr = array("categorylist"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Category List Founded!");
}
}
echo json_encode($returnArr);
?>