<?php
require dirname(dirname(__FILE__)) . '/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
$data = json_decode(file_get_contents('php://input'), true);
header('Content-type: text/json');
if ($data['uid'] == '' || $data['post_id'] == '' || $data['transaction_id'] == '' || $data['p_method_id'] == '') {
    $returnArr = ["ResponseCode" => "401", "Result" => "false", "ResponseMsg" => "Something Went Wrong!"];
} else {
    $uid = $data['uid'];
    $post_id = $data['post_id'];
    $transaction_id = $data['transaction_id'];
    $p_method_id = $data['p_method_id'];
    $wall_amt = $data['wall_amt'];
    $is_paid = $data['is_paid'];
    $post_date = date("Y-m-d H:i:s");
	$package_id = $data['package_id'];
	
	$vp = $sellify->query("select * from tbl_user where id=".$uid."")->fetch_assoc();
	if ($vp["wallet"] >= $wall_amt) {
	    
	    if ($wall_amt != 0) {
	        $timestamp = date("Y-m-d H:i:s");
                $mt = intval($vp["wallet"]) - intval($wall_amt);
                $table = "tbl_user";
                $field = ["wallet" => "$mt"];
                $where = "WHERE id='" . $uid . "'";
                $crud = new Crud($sellify);
                $check = $crud->sellifyupdateData_Api($field, $table, $where);

                $table = "wallet_report";
                $field_values = ["uid", "message", "status", "amt", "tdate"];
                $data_values = [
                    "$uid",
                    "Wallet Used in Ad POST",
                    "Debit",
                    "$wall_amt",
                    "$timestamp",
                ];

                $h = new Crud($sellify);
                $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
            }
            
	if($is_paid == 1)
	{
		
		$pdata = $sellify->query("select * from tbl_package where id=".$package_id."")->fetch_assoc();
		if($post_type == 'Post_Based')
		{
		$days_to_add = $pdata['days'];
		$is_feature_ad = 0;
		$feature_expire_date = NULL;
		}
		else 
		{
		$days_to_add = $pdata['days'];
		$is_feature_ad = 1;
		$feature_expire_date = date("Y-m-d H:i:s", strtotime($post_date . " + $days_to_add days"));
		}	
	}
	else 
	{
		$getda = $sellify->query("select * from tbl_category where id=".$cat_id."")->fetch_assoc();
	    $days_to_add = $getda['total_days'];
		$is_feature_ad = 0;
		$feature_expire_date = NULL;
	}
	$post_expire_date = date("Y-m-d H:i:s", strtotime($post_date . " + $days_to_add days"));
	
	$table = "tbl_post";
        $fields = [
            'transaction_id' => $transaction_id,
            'p_method_id' => $p_method_id,
            'wall_amt' => $wall_amt,
            'post_date' => $post_date,
            'post_expire_date' => $post_expire_date,
            'feature_expire_date' => $feature_expire_date,
            'is_expire' => '0',
            'post_status' => '0',
            'is_approve' => '0',
            'is_paid' => '1'
        ];

        

        $where = "WHERE id='" . $post_id . "' and uid=".$uid."";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
        $returnArr = ["ResponseCode" => "200", "Result" => "true", "ResponseMsg" => "Ad Post Succcessfully Wait For Approval!!"];
        
        $udata = $sellify->query("select name from tbl_user where id=" . $uid . "")->fetch_assoc();
         $name = $udata['name'];

         $content = [
             "en" => $name . ', Your Ad Has Been Under Review.',
         ];
         $heading = [
             "en" => "Ad Under Review!!",
         ];

         $fields = [
             'app_id' => $set['one_key'],
             'included_segments' => ["All"],
             'filters' => [['field' => 'tag', 'key' => 'user_id', 'relation' => '=', 'value' => $uid]],
             'contents' => $content,
             'headings' => $heading
         ];
         $fields = json_encode($fields);

         $ch = curl_init();
         curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
         curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json; charset=utf-8', 'Authorization: Basic ' . $set['one_hash']]);
         curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
         curl_setopt($ch, CURLOPT_HEADER, false);
         curl_setopt($ch, CURLOPT_POST, true);
         curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
         curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

         $response = curl_exec($ch);
         curl_close($ch);
         
		 
		 $timestamp = date("Y-m-d H:i:s");

$title_mains = "Ad Under Review!!";
$descriptions = 'Your Ad Has Been Under Review.';

	   $table="tbl_notification";
  $field_values=array("uid","datetime","title","description");
  $data_values=array("$uid","$timestamp","$title_mains","$descriptions");
  
       $h = new Crud($sellify);
	   $h->sellifyinsertdata_Api($field_values,$data_values,$table);
	   
	}
	
else 
	{
	    $tbwallet = $sellify->query("select * from tbl_user where id=".$uid."")->fetch_assoc();
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "false",
                "ResponseMsg" =>
                    "Wallet Balance Not There As Per Booking Refresh One Time Screen!!!",
                "wallet" => $tbwallet["wallet"],
            ];
	}
}
echo json_encode($returnArr);
?>