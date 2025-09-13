<?php
require dirname(dirname(__FILE__)) . '/inc/Config.php';
require dirname(dirname(__FILE__)) . '/inc/Crud.php';
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

if ($_POST['uid'] == '' || $_POST['ad_type'] == '' || $_POST['ad_title'] == '' || $_POST['ad_description'] == '' || $_POST['full_address'] == '' || $_POST['lats'] == '' || $_POST['longs'] == '' || $_POST['record_id'] == '') {
    $returnArr = ["ResponseCode" => "401", "Result" => "false", "ResponseMsg" => "Something Went Wrong!"];
} else {
    $uid = $_POST['uid'];
    $cat_id = $_POST['cat_id'];
    $subcat_id = $_POST['subcat_id'];
    $ad_type = $_POST['ad_type'];
    $ad_title = strip_tags(mysqli_real_escape_string($sellify,$_POST['ad_title']));
    $ad_description = strip_tags(mysqli_real_escape_string($sellify,$_POST['ad_description']));
    $full_address = strip_tags(mysqli_real_escape_string($sellify,$_POST['full_address']));
    $lats = $_POST['lats'];
    $longs = $_POST['longs'];
    $ad_price = $_POST['ad_price'];
    $record_id = $_POST['record_id'];
	$is_paid = $_POST['is_paid'];
	$transaction_id = $_POST['transaction_id'];
	$p_method_id = $_POST['p_method_id'];
	$oldfile = $_POST['oldfileurl'];
	$size = isset($_POST['size']) ? (int) $_POST['size'] : 0;

        $multifile = '';
        if ($size > 0 and $oldfile == 0) {
            // Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = implode('$;', $uploadedFiles);
        }
		elseif($size > 0 and $oldfile != 0)
		{
			// Process single file uploads
            $uploadedFiles = processFileUploads('photo', $size, IMAGE_PATH);
            $multifile = $oldfile.'$;'.implode('$;', $uploadedFiles);
		}
		else 
		{
			$multifile = $oldfile;
		}
    if ($ad_type == 'sellify_post') {
        $brand_id = $_POST['brand_id'];
        $variant_id = $_POST['variant_id'];
        $variant_type_id = $_POST['variant_type_id'];
        $sellify_year = $_POST['sellify_year'];
        $fuel = $_POST['fuel'];
        $transmission = $_POST['transmission'];
        $km_driven = $_POST['km_driven'];
        $no_owner = $_POST['no_owner'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'brand_id' => $brand_id,
            'variant_id' => $variant_id,
            'variant_type_id' => $variant_type_id,
            'post_year' => $sellify_year,
            'fuel' => $fuel,
            'transmission' => $transmission,
            'km_driven' => $km_driven,
            'no_owner' => $no_owner,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
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
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'project_name' => $project_name,
            'property_facing' => $property_facing,
            'property_sellify_parking' => $property_sellify_parking,
            'property_floor_no' => $property_floor_no,
            'property_total_floor' => $property_total_floor,
            'property_maintaince_monthly' => $property_maintaince_monthly,
            'property_type' => $property_type,
            'property_bedroom' => $property_bedroom,
            'property_bathroom' => $property_bathroom,
            'property_furnishing' => $property_furnishing,
            'property_construction_status' => $property_construction_status,
            'property_listed_by' => $property_listed_by,
            'property_superbuildarea' => $property_superbuildarea,
            'property_sellifypetarea' => $property_sellifypetarea,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

       

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'rentoffice_post') {
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
        $property_maintaince_monthly = $_POST['property_maintaince_monthly'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $project_name = $_POST['project_name'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'project_name' => $project_name,
            'property_sellify_parking' => $property_sellify_parking,
            'property_maintaince_monthly' => $property_maintaince_monthly,
            'property_bathroom' => $property_bathroom,
            'property_furnishing' => $property_furnishing,
            'property_listed_by' => $property_listed_by,
            'property_superbuildarea' => $property_superbuildarea,
            'property_sellifypetarea' => $property_sellifypetarea,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

       

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
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
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'project_name' => $project_name,
            'property_sellify_parking' => $property_sellify_parking,
            'property_maintaince_monthly' => $property_maintaince_monthly,
            'property_bathroom' => $property_bathroom,
            'property_furnishing' => $property_furnishing,
            'property_construction_status' => $property_construction_status,
            'property_listed_by' => $property_listed_by,
            'property_superbuildarea' => $property_superbuildarea,
            'property_sellifypetarea' => $property_sellifypetarea,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'renthouse_post') {
        $property_type = $_POST['property_type'];
        $property_bedroom = $_POST['property_bedroom'];
        $property_bathroom = $_POST['property_bathroom'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_superbuildarea = $_POST['property_superbuildarea'];
        $property_sellifypetarea = $_POST['property_sellifypetarea'];
       

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'property_type' => $property_type,
            'property_bedroom' => $property_bedroom,
            'property_bathroom' => $property_bathroom,
            'property_furnishing' => $property_furnishing,
            'property_listed_by' => $property_listed_by,
            'property_superbuildarea' => $property_superbuildarea,
            'property_sellifypetarea' => $property_sellifypetarea,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'pg_post') {
        $pg_subtype = $_POST['pg_subtype'];
        $property_sellify_parking = $_POST['property_sellify_parking'];
        $property_furnishing = $_POST['property_furnishing'];
        $property_listed_by = $_POST['property_listed_by'];
        $pg_meals_include = $_POST['pg_meals_include'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'pg_subtype' => $pg_subtype,
            'property_sellify_parking' => $property_sellify_parking,
            'pg_meals_include' => $pg_meals_include,
            'property_furnishing' => $property_furnishing,
            'property_listed_by' => $property_listed_by,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'land_post') {
        $property_type = $_POST['property_type'];
        $plot_area = $_POST['plot_area'];
        $plot_length = $_POST['plot_length'];
        $plot_breadth = $_POST['plot_breadth'];
        $property_listed_by = $_POST['property_listed_by'];
        $property_facing = $_POST['property_facing'];
        $project_name = $_POST['project_name'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'property_type' => $property_type,
            'plot_area' => $plot_area,
            'plot_length' => $plot_length,
            'plot_breadth' => $plot_breadth,
            'property_listed_by' => $property_listed_by,
            'property_facing' => $property_facing,
            'project_name' => $project_name,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        
        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'mobile_post') {
        $mobile_brand = $_POST['mobile_brand'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'mobile_brand' => $mobile_brand,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'accessories_post') {
        $accessories_type = $_POST['accessories_type'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'accessories_type' => $accessories_type,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

       

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'job_post') {
        $job_salary_period = $_POST['job_salary_period'];
        $job_position_type = $_POST['job_position_type'];
        $job_salary_from = $_POST['job_salary_from'];
        $job_salary_to = $_POST['job_salary_to'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'job_salary_period' => $job_salary_period,
            'job_position_type' => $job_position_type,
            'job_salary_from' => $job_salary_from,
            'job_salary_to' => $job_salary_to,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'motorcycle_post') {
        $motocycle_brand_id = $_POST['motocycle_brand_id'];
        $motorcycle_model_id = $_POST['motorcycle_model_id'];
        $motorcycle_year = $_POST['motorcycle_year'];
        $km_driven = $_POST['km_driven'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'motocycle_brand_id' => $motocycle_brand_id,
            'motorcycle_model_id' => $motorcycle_model_id,
            'post_year' => $motorcycle_year,
            'km_driven' => $km_driven,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'commercial_post') {
        $commercial_brand_id = $_POST['commercial_brand_id'];
        $commercial_model_id = $_POST['commercial_model_id'];
        $commercial_year = $_POST['commercial_year'];
        $km_driven = $_POST['km_driven'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'commercial_brand_id' => $commercial_brand_id,
            'commercial_model_id' => $commercial_model_id,
            'post_year' => $commercial_year,
            'km_driven' => $km_driven,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'scooter_post') {
        $scooter_brand_id = $_POST['scooter_brand_id'];
        $scooter_model_id = $_POST['scooter_model_id'];
        $scooter_year = $_POST['scooter_year'];
        $km_driven = $_POST['km_driven'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'scooter_brand_id' => $scooter_brand_id,
            'scooter_model_id' => $scooter_model_id,
            'post_year' => $scooter_year,
            'km_driven' => $km_driven,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'sparepart_post') {
        $sparepart_type_id = $_POST['sparepart_type_id'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'sparepart_type_id' => $sparepart_type_id,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'service_post') {
        $service_type_id = $_POST['service_type_id'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'service_type_id' => $service_type_id,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        if ($size > 0) {
            $fields['post_img'] = $multifile;
        }

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'bicycles_post') {
        $bicycles_brand_id = $_POST['bicycles_brand_id'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'bicycles_brand_id' => $bicycles_brand_id,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

       

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } elseif ($ad_type == 'tablet_post') {
        $tablet_type = $_POST['tablet_type'];
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'tablet_type' => $tablet_type,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

        

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    } else {
        

        $table = "tbl_post";
        $fields = [
            'uid' => $uid,
            'cat_id' => $cat_id,
            'subcat_id' => $subcat_id,
            'full_address' => $full_address,
            'lats' => $lats,
            'longs' => $longs,
            'ad_title' => $ad_title,
            'ad_description' => $ad_description,
            'ad_price' => $ad_price,
            'is_approve' => '0',
			'is_paid'=>$is_paid,
			'transaction_id'=>$transaction_id,
			'p_method_id'=>$p_method_id,
			'post_img'=>$multifile
        ];

       

        $where = "WHERE id='" . $record_id . "'";
        $crud = new Crud($sellify);
        $check = $crud->sellifyupdateData_Api($fields, $table, $where);
    }

    $returnArr = ["ResponseCode" => "200", "Result" => "true", "ResponseMsg" => "Ad Update Succcessfully Wait For Approval!!"];
}
echo json_encode($returnArr);
?>
