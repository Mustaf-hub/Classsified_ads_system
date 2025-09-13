<?php
require dirname( dirname(__FILE__) ).'/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);

$post_id = $data['post_id'];
$uid = $data['uid'];
$sold_type = $data['sold_type'];
if ($post_id =='' || $uid =='' || $sold_type == '')
{
$returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went wrong  try again !");
}
else 
{
    
    $post_id = strip_tags(mysqli_real_escape_string($sellify,$post_id));
    $uid = strip_tags(mysqli_real_escape_string($sellify,$uid));
	$sold_type = strip_tags(mysqli_real_escape_string($sellify,$sold_type));
    
    $counter = $sellify->query("select * from tbl_post where uid='".$uid."' and id='".$post_id."' and is_sold=0");
    
   
    
    if($counter->num_rows != 0)
    {
  $table="tbl_post";
  $field = array('is_sold'=>'1','sold_type'=>$sold_type);
  $where = "where id='".$post_id."' and uid='".$uid."'";
$h = new Crud($sellify);
	  $check = $h->sellifyupdateData_Api($field,$table,$where);
	  
     $returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Post Mark As Sold Successfully!!!!!");    
    }
    else
    {
     $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Post Not Found!!!!");  
    }
}

echo json_encode($returnArr);
