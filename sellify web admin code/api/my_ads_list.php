<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
require dirname( dirname(__FILE__) ).'/inc/Crud.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);

if($data['uid'] == '')
{
    $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");
}
else
{
	$uid = $data['uid'];
	$getad = $sellify->query("select * from tbl_post where uid=".$uid."");
	$s = array();
	$p = array();
	while($row = $getad->fetch_assoc())
	{
		$im = explode('$;',$row['post_img']);
		$s['post_id'] = $row['id'];
		$s['cat_id'] = $row['cat_id'];
		$s['subcat_id'] = $row['subcat_id'];
		$s['post_image'] = $im[0];
		$s['post_all_image'] = $im;
		
		$s['post_title'] = $row['ad_title'];
		$s['post_date'] = $row['post_date'];
$s['post_expire_date'] = $row['post_expire_date'];

$current_date = new DateTime(); // Create a DateTime object for the current date
$post_expire_date = new DateTime($row['post_expire_date']); // Convert post_expire_date to DateTime
$post_date = new DateTime($row['post_date']); 
// Calculate the difference
$interval = $current_date->diff($post_expire_date);
$k = $post_date->diff($post_expire_date);
$td = $k->days;
// Remaining days
$days_remaining = $interval->days;

if ($post_expire_date < $current_date) {
    $s['days_remaining'] = 0; // Post has expired
} else {
    $s['days_remaining'] = $days_remaining; // Days left until expiration
}
		$s['total_day'] = $td;
		$s['transmission'] = $row['transmission'];
		
		$s['ad_price'] = $row['ad_price'];
		$s['job_salary_from'] = $row['job_salary_from'];
		$s['job_salary_to'] = $row['job_salary_to'];
		$s['job_salary_period'] = $row['job_salary_period'];
		$s['job_position_type'] = $row['job_position_type'];
		$s['full_address'] = $row['full_address'];
		$s['lats'] = $row['lats'];
		$s['longs'] = $row['longs'];
		$s['ad_description'] = $row['ad_description'];
		$s['brand_id'] = $row['brand_id'];
		$s['variant_id'] = $row['variant_id'];
		$s['variant_type_id'] = $row['variant_type_id'];
		$s['post_year'] = $row['post_year'];
		$s['fuel'] = $row['fuel'];
		$s['km_driven'] = $row['km_driven'];
		$s['no_owner'] = $row['no_owner'];
		$s['property_type'] = $row['property_type'];
		$s['property_bedroom'] = $row['property_bedroom'];
		$s['property_bathroom'] = $row['property_bathroom'];
		$s['property_furnishing'] = $row['property_furnishing'];
		$s['property_construction_status'] = $row['property_construction_status'];
		$s['property_listed_by'] = $row['property_listed_by'];
		$s['property_superbuildarea'] = $row['property_superbuildarea'];
		$s['property_sellifypetarea'] = $row['property_sellifypetarea'];
		$s['property_maintaince_monthly'] = $row['property_maintaince_monthly'];
		$s['property_total_floor'] = $row['property_total_floor'];
		$s['property_floor_no'] = $row['property_floor_no'];
		$s['property_sellify_parking'] = $row['property_sellify_parking'];
		$s['property_facing'] = $row['property_facing'];
		$s['project_name'] = $row['project_name'];
		$s['property_bachloar'] = $row['property_bachloar'];
		$s['property_land_type'] = $row['property_land_type'];
		$s['plot_area'] = $row['plot_area'];
		$s['plot_length'] = $row['plot_length'];
		$s['plot_breadth'] = $row['plot_breadth'];
		$s['pg_subtype'] = $row['pg_subtype'];
		$s['pg_meals_include'] = $row['pg_meals_include'];
		$s['mobile_brand'] = $row['mobile_brand'];
		$s['accessories_type'] = $row['accessories_type'];
		$s['tablet_type'] = $row['tablet_type'];
		$s['job_salary_period'] = $row['job_salary_period'];
		$s['motocycle_brand_id'] = $row['motocycle_brand_id'];
		$s['motorcycle_model_id'] = $row['motorcycle_model_id'];
		$s['scooter_brand_id'] = $row['scooter_brand_id'];
		$s['scooter_model_id'] = $row['scooter_model_id'];
		$s['bicycles_brand_id'] = $row['bicycles_brand_id'];
		$s['commercial_brand_id'] = $row['commercial_brand_id'];
		$s['commercial_model_id'] = $row['commercial_model_id'];
		$s['sparepart_type_id'] = $row['sparepart_type_id'];
		$s['service_type_id'] = $row['service_type_id'];
		$s['is_approve'] = $row['is_approve'];
		$s['is_sold'] = $row['is_sold'];
		$s['post_type'] = $row['post_type'];
		$s['sold_type'] = $row['sold_type'];
		$s['is_paid'] = $row['is_paid'];
		$s['is_expire'] = $row['is_expire'];
		$s['total_favourite'] = $sellify->query("select * from tbl_fav where post_id=".$row['id']."")->num_rows;
		$s['total_views'] = $sellify->query("select * from tbl_view where post_id=".$row['id']."")->num_rows;
		$p[] = $s;
	}
	$returnArr = array("MyadList"=>$p,"currency"=>$set['currency'],"ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"My Ads Get Successfully!");
}
echo json_encode($returnArr);