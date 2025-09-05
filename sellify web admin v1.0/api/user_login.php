<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
$data = json_decode(file_get_contents('php://input'), true);
header('Content-type: text/json');
if($data['mobile'] == ''  or $data['password'] == '' or $data['ccode'] == '')
{
    $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");
}
else
{
    $mobile = strip_tags(mysqli_real_escape_string($sellify,$data['mobile']));
    $password = strip_tags(mysqli_real_escape_string($sellify,$data['password']));
	$ccode = strip_tags(mysqli_real_escape_string($sellify,$data['ccode']));
    
$chek = $sellify->query("select * from tbl_user where (mobile='".$mobile."' or email='".$mobile."') and status = 1 and password='".$password."' and ccode='".$ccode."'");
$status = $sellify->query("select * from tbl_user where status = 1");
if($chek->num_rows != 0)
{
	if($status->num_rows !=0)
{
    $c = $sellify->query("select * from tbl_user where (mobile='".$mobile."' or email='".$mobile."')  and status = 1 and password='".$password."'");
    $c = $c->fetch_assoc();
	
    $returnArr = array("UserLogin"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Login successfully!");
	}
else  
{
	 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Your profile has been blocked by the administrator, preventing you from using our app as a regular user.");
}
}
else
{
    $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Account Not Found!!!");
}
}

echo json_encode($returnArr);