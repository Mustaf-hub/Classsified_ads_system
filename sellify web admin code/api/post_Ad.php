<?php
require dirname(dirname(__FILE__)) . '/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
header('Content-type: text/json');
define('BASE_PATH', dirname(dirname(__FILE__)));
define('IMAGE_PATH', '/images/ads/');
function processFileUploads($prefix, $count, $url)
{
    $targetPath = BASE_PATH . $url;
    $uploadedFiles = [];

    for ($i = 0; $i < $count; $i++) {
        $newName = uniqid() . date('YmdHis') . mt_rand() . '.jpg';
        $fileUrl = $url . $newName;

        // Remove leading '/' from each file URL
        $fileUrl = ltrim($fileUrl, '/');

        $uploadedFiles[] = $fileUrl;

        // Move uploaded file and check for errors
        if (!move_uploaded_file($_FILES[$prefix . $i]['tmp_name'], $targetPath . $newName)) {
            // Handle upload error here (e.g., provide feedback to the user)
        }
    }

    return $uploadedFiles;
}
if ($_POST['uid'] == '' || $_POST['ad_type'] == '' || $_POST['ad_title'] == '' || $_POST['ad_description'] == '' || $_POST['full_address'] == '' || $_POST['lats'] == '' || $_POST['longs'] == '') {
    $returnArr = ["ResponseCode" => "401", "Result" => "false", "ResponseMsg" => "Something Went Wrong!"];
} else {
    $uid = $_POST['uid'];
    $cat_id = $_POST['cat_id'];
    $subcat_id = $_POST['subcat_id'];
    $ad_type = $_POST['ad_type'];
    $ad_title = $_POST['ad_title'];
    $ad_description = $_POST['ad_description'];
    $full_address = $_POST['full_address'];
    $lats = $_POST['lats'];
    $longs = $_POST['longs'];
    $ad_price = $_POST['ad_price'];
	$is_paid = $_POST['is_paid'];
	$transaction_id = $_POST['transaction_id'];
	$p_method_id = $_POST['p_method_id'];
	$wall_amt = $_POST['wall_amt'];
	$post_date = date("Y-m-d H:i:s");
	$package_id = $_POST['package_id'];
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
    if ($ad_type == 'sellify_post') {
        $brand_id = $_POST['brand_id'];
        $variant_id = $_POST['variant_id'];
        $variant_type_id = $_POST['variant_type_id'];
        $sellify_year = $_POST['sellify_year'];
        $fuel = $_POST['fuel'];
        $transmission = $_POST['transmission'];
        $km_driven = $_POST['km_driven'];
        $no_owner = $_POST['no_owner'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "brand_id",
            "variant_id",
            "variant_type_id",
            "post_year",
            "fuel",
            "transmission",
            "km_driven",
            "no_owner",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
        ];
        $data_values = [
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$brand_id",
            "$variant_id",
            "$variant_type_id",
            "$sellify_year",
            "$fuel",
            "$transmission",
            "$km_driven",
            "$no_owner",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'sellify_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
	
    } elseif ($ad_type == 'salehouse_post') {
        $property_type = $_POST['property_type'];
        $property_bedroom = $_POST['property_bedroom'];
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_construction_status = $_POST['property_construction_status'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
        $property_maintaince_monthly = $_POST['property_maintaince_monthly'];
        $property_total_floor = $_POST['property_total_floor'];
        $property_floor_no = $_POST['property_floor_no'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $property_facing = $_POST['property_facing'];
        $project_name = $_POST['project_name'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "project_name",
            "property_facing",
            "property_sellify_parking",
            "property_floor_no",
            "property_total_floor",
            "property_maintaince_monthly",
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "property_type",
            "property_bedroom",
            "property_bathroom",
            "property_furnishing",
            "property_construction_status",
            "property_listed_by",
            "property_superbuildarea",
            "property_sellifypetarea",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
			
        ];
        $data_values = [
            "$project_name",
            "$property_facing",
            "$property_sellify_parking",
            "$property_floor_no",
            "$property_total_floor",
            "$property_maintaince_monthly",
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$property_type",
            "$property_bedroom",
            "$property_bathroom",
            "$property_furnishing",
            "$property_construction_status",
            "$property_listed_by",
            "$property_superbuildarea",
            "$property_sellifypetarea",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'salehouse_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'rentoffice_post') {
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
        $property_maintaince_monthly = $_POST['property_maintaince_monthly'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $project_name = $_POST['project_name'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "project_name",
            "property_sellify_parking",
            "property_maintaince_monthly",
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "property_bathroom",
            "property_furnishing",
            "property_listed_by",
            "property_superbuildarea",
            "property_sellifypetarea",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
        ];
        $data_values = [
            "$project_name",
            "$property_sellify_parking",
            "$property_maintaince_monthly",
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$property_bathroom",
            "$property_furnishing",
            "$property_listed_by",
            "$property_superbuildarea",
            "$property_sellifypetarea",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'rentoffice_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'saleoffice_post') {
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
        $property_construction_status = $_POST['property_construction_status'];
        $property_maintaince_monthly = $_POST['property_maintaince_monthly'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $project_name = $_POST['project_name'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "property_construction_status",
            "project_name",
            "property_sellify_parking",
            "property_maintaince_monthly",
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "property_bathroom",
            "property_furnishing",
            "property_listed_by",
            "property_superbuildarea",
            "property_sellifypetarea",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
        ];
        $data_values = [
            "$property_construction_status",
            "$project_name",
            "$property_sellify_parking",
            "$property_maintaince_monthly",
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$property_bathroom",
            "$property_furnishing",
            "$property_listed_by",
            "$property_superbuildarea",
            "$property_sellifypetarea",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'saleoffice_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'renthouse_post') {
        $property_type = $_POST['property_type'];
        $property_bedroom = $_POST['property_bedroom'];
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "property_type",
            "property_bedroom",
            "property_bathroom",
            "property_furnishing",
            "property_listed_by",
            "property_superbuildarea",
            "property_sellifypetarea",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
			
        ];
        $data_values = [
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$property_type",
            "$property_bedroom",
            "$property_bathroom",
            "$property_furnishing",
            "$property_listed_by",
            "$property_superbuildarea",
            "$property_sellifypetarea",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'renthouse_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'pg_post') {
        $pg_subtype = $_POST['pg_subtype'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $pg_meals_include = $_POST['pg_meals_include'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "pg_subtype",
            "property_sellify_parking",
            "pg_meals_include",
            "property_furnishing",
            "property_listed_by",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
        ];
        $data_values = [
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$pg_subtype",
            "$property_sellify_parking",
            "$pg_meals_include",
            "$property_furnishing",
            "$property_listed_by",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'pg_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'land_post') {
        $property_type = $_POST['property_type'];
        $plot_area = $_POST['plot_area'];
        $plot_length = $_POST['plot_length'];
        $plot_breadth = $_POST['plot_breadth'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_facing = $_POST['property_facing'];
        $project_name = $_POST['project_name'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = [
            "uid",
            "cat_id",
            "subcat_id",
            "full_address",
            "lats",
            "longs",
            "property_type",
            "plot_area",
            "plot_length",
            "plot_breadth",
            "property_listed_by",
            "property_facing",
            "project_name",
            "ad_title",
            "ad_description",
            "post_img",
            "ad_price",
			"post_type",
			"post_date",
			"post_expire_date",
			"is_paid",
			"transaction_id",
			"p_method_id",
			"is_feature_ad",
			"feature_expire_date"
        ];
        $data_values = [
            "$uid",
            "$cat_id",
            "$subcat_id",
            "$full_address",
            "$lats",
            "$longs",
            "$property_type",
            "$plot_area",
            "$plot_length",
            "$plot_breadth",
            "$property_listed_by",
            "$property_facing",
            "$project_name",
            "$ad_title",
            "$ad_description",
            "$multifile",
            "$ad_price",
			'land_post',
			"$post_date",
			"$post_expire_date",
			"$is_paid",
			"$transaction_id",
			"$p_method_id",
			"$is_feature_ad",
			"$feature_expire_date"
        ];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'mobile_post') {
        $mobile_brand = $_POST['mobile_brand'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "mobile_brand","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$mobile_brand",'mobile_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'accessories_post') {
        $accessories_type = $_POST['accessories_type'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "accessories_type","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$accessories_type",'accessories_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'job_post') {
        $job_salary_period = $_POST['job_salary_period'];
        $job_position_type = $_POST['job_position_type'];
        $job_salary_from = $_POST['job_salary_from'];
        $job_salary_to = $_POST['job_salary_to'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "job_salary_period", "job_position_type", "job_salary_from", "job_salary_to","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$job_salary_period", "$job_position_type", "$job_salary_from", "$job_salary_to",'job_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'motorcycle_post') {
        $motocycle_brand_id = $_POST['motocycle_brand_id'];
        $motorcycle_model_id = $_POST['motorcycle_model_id'];
        $motorcycle_year = $_POST['motorcycle_year'];
        $km_driven = $_POST['km_driven'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "motocycle_brand_id", "motorcycle_model_id", "km_driven", "post_year","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$motocycle_brand_id", "$motorcycle_model_id", "$km_driven", "$motorcycle_year",'motorcycle_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'commercial_post') {
        $commercial_brand_id = $_POST['commercial_brand_id'];
        $commercial_model_id = $_POST['commercial_model_id'];
        $commercial_year = $_POST['commercial_year'];
        $km_driven = $_POST['km_driven'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "commercial_brand_id", "commercial_model_id", "km_driven", "post_year","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$commercial_brand_id", "$commercial_model_id", "$km_driven", "$commercial_year",'commercial_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'scooter_post') {
        $scooter_brand_id = $_POST['scooter_brand_id'];
        $scooter_model_id = $_POST['scooter_model_id'];
        $scooter_year = $_POST['scooter_year'];
        $km_driven = $_POST['km_driven'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "scooter_brand_id", "scooter_model_id", "km_driven", "post_year","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$scooter_brand_id", "$scooter_model_id", "$km_driven", "$scooter_year",'scooter_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'sparepart_post') {
        $sparepart_type_id = $_POST['sparepart_type_id'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "sparepart_type_id","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$sparepart_type_id",'sparepart_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'service_post') {
        $service_type_id = $_POST['service_type_id'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "service_type_id","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$service_type_id",'service_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'bicycles_post') {
        $bicycles_brand_id = $_POST['bicycles_brand_id'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "bicycles_brand_id","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$bicycles_brand_id",'bicycles_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } elseif ($ad_type == 'tablet_post') {
        $tablet_type = $_POST['tablet_type'];
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price", "tablet_type","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price", "$tablet_type",'tablet_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    } else {
        $size = isset($_POST['size']) ? (int) $_POST['size'] : 0;
        if ($size > 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }

        $table = "tbl_post";
        $field_values = ["uid", "cat_id", "subcat_id", "full_address", "lats", "longs", "ad_title", "ad_description", "post_img", "ad_price","post_type","post_date","post_expire_date","is_paid","transaction_id","p_method_id","is_feature_ad","feature_expire_date"];
        $data_values = ["$uid", "$cat_id", "$subcat_id", "$full_address", "$lats", "$longs", "$ad_title", "$ad_description", "$multifile", "$ad_price",'common_post',"$post_date","$post_expire_date","$is_paid","$transaction_id","$p_method_id","$is_feature_ad","$feature_expire_date"];

        $h = new Crud($sellify);
         $checks = $h->sellifyinsertdata_Api_Id($field_values, $data_values, $table);
        
        if($is_paid == 1)
	{
        $gmat = $sellify->query("SELECT price FROM `tbl_package` where id=".$package_id."")->fetch_assoc();
        $amount = $gmat['price'];
        $table = "purchase_history";
        $field_values = [
            "uid",
            "post_id",
            "amount",
            "p_method_id",
            "transaction_id"
        ];
        $data_values = [
            "$uid",
            "$checks",
            "$amount",
            "$p_method_id",
            "$transaction_id"
        ];
        
        $h = new Crud($sellify);
        $checks = $h->sellifyinsertdata_Api($field_values, $data_values, $table);
	}
    }
	
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
	   
	   
    $returnArr = ["ResponseCode" => "200", "Result" => "true", "ResponseMsg" => "Ad Post Succcessfully Wait For Approval!!"];
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
