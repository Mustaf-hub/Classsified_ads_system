<?php
require dirname(dirname(__FILE__)) . '/inc/Config.php';
require dirname(dirname(__FILE__)) . '/inc/Crud.php';
$data = json_decode(file_get_contents('php://input'), true);
header('Content-type: text/json');
$uid = $data['uid'];
$post_id = $data['post_id'];
if($uid == '' or $post_id == '')
{
	$returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went wrong  try again !");
}
else 
{
 $check = $sellify->query("select * from tbl_view where uid=".$uid." and post_id=".$post_id."")->num_rows;
 if($check != 0)
 {

      $returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Post Viewed!!");  
 }
 else 
 {
     
	 $table="tbl_view";
  $field_values=array("uid","post_id");
  $data_values=array("$uid","$post_id");
  $h = new Crud($sellify);
  $check = $h->sellifyinsertdata_Api($field_values,$data_values,$table);
   $returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Post Viewed!!!");   
 }
}
echo json_encode($returnArr);
?>