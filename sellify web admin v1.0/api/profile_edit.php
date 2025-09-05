<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
if($data['name'] == '' or $data['password'] == '' or $data['uid'] == '')
{
    $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");
}
else
{
    
    $name = strip_tags(mysqli_real_escape_string($sellify,$data['name']));
   
    $email = strip_tags(mysqli_real_escape_string($sellify,$data['email']));
     $password = strip_tags(mysqli_real_escape_string($sellify,$data['password']));
	 
$uid =  strip_tags(mysqli_real_escape_string($sellify,$data['uid']));
$checkimei = $sellify->query("select * from tbl_user where  `id`=".$uid."")->num_rows;

if($checkimei == 0)
    {
		     $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"User Not Exist!!!!");  
	}

else 
{	
	   $table="tbl_user";
  $field = array('name'=>$name,'password'=>$password,'email'=>$email);
  $where = "where id=".$uid."";
$h = new Crud($sellify);
	  $check = $h->sellifyupdateData_Api($field,$table,$where);
	  
            $c = $sellify->query("select * from tbl_user where  `id`=".$uid."")->fetch_assoc();
        $returnArr = array("UserLogin"=>$c,"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Profile Update successfully!");
        
    
	}
    
}

echo json_encode($returnArr);