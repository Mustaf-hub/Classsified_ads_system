<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['uid'] == '' || $data['post_id'] == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{
 $uid = $data['uid'];  
   $table = "tbl_post";

            

            $where = "where id=" . $post_id . " and uid=".$uid."";

            $h = new Crud($sellify);
           
            $check = $h->sellifyDeleteData_Api($where,$table);
 $returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Post Delete Successfully!!");

}
echo  json_encode($returnArr);
?>