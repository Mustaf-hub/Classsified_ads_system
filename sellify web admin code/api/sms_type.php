<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';

		  $returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"type Get Successfully!!","SMS_TYPE"=>$set['sms_type'],"Admob_Enabled"=>$set['admob'],"maintainance_Enabled"=>$set['mode'],"banner_id"=>$set['banner_id'],"in_id"=>$set['in_id'],"otp_auth"=>$set['otp_auth'],"ios_in_id"=>$set['ios_in_id'],"ios_banner_id"=>$set['ios_banner_id'],"native_ad"=>$set['native_ad'],"ios_native_ad"=>$set['ios_native_ad']);

echo json_encode($returnArr);
?>
