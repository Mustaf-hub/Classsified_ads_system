<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
$lats = $data['lats'];
$longs = $data['longs'];
$uid = $data['uid'];
if($uid == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{	
$pol = array();
$c = array();
$sel = $sellify->query("select * from tbl_category where status=1");
while($row = $sel->fetch_assoc())
{
   
		$pol['id'] = $row['id'];
		$pol['title'] = $row['title'];
		$pol['img'] = $row['img'];
		$c[] = $pol;	
}

$featurelist = $sellify->query("SELECT 
    *,
    (
        (
            acos(
                sin(({$lats} * pi() / 180)) * sin((`lats` * pi() / 180)) +
                cos(({$lats} * pi() / 180)) * cos((`lats` * pi() / 180)) *
                cos((({$longs} - `longs`) * pi() / 180))
            )
        ) * 180 / pi()
    ) * 60 * 1.1515 * 1.609344 AS distance
FROM 
    tbl_post
WHERE 
    post_status = 1 
    AND is_sold = 0 
    AND is_approve = 1 
    AND is_expire = 0 
	AND is_feature_ad = 1
    AND uid != {$uid}
HAVING 
    distance < 100;
");	
    $sp = array();
	$pp = array();

while($row = $featurelist->fetch_assoc())
	{
		$udata = $sellify->query("select * from tbl_user where id=".$row['uid']."")->fetch_assoc();
		$im = explode('$;',$row['post_img']);
		$sp['post_id'] = $row['id'];
		$sp['cat_id'] = $row['cat_id'];
		$sp['subcat_id'] = $row['subcat_id'];
		$sp['post_owner_id'] = $row['uid'];
		$sp['owner_name'] = $udata['name'];
		$sp['owner_img'] = $udata['profile_pic'];
		$sp['owner_mobile'] = $udata['ccode'].$udata['mobile'];
		$sp['post_image'] = $im[0];
		$sp['post_all_image'] = $im;
		$sp['post_title'] = $row['ad_title'];
		$sp['post_date'] = $row['post_date'];
		$sp['ad_price'] = $row['ad_price'];
		$sp['transmission'] = $row['transmission'];
		$sp['job_salary_from'] = $row['job_salary_from'];
		$sp['job_salary_to'] = $row['job_salary_to'];
		$sp['job_salary_period'] = $row['job_salary_period'];
		$sp['job_position_type'] = $row['job_position_type'];
		$sp['full_address'] = $row['full_address'];
		$sp['lats'] = $row['lats'];
		$sp['longs'] = $row['longs'];
		$sp['ad_description'] = $row['ad_description'];
		$sp['brand_id'] = $row['brand_id'];
		$sp['variant_id'] = $row['variant_id'];
		$sp['variant_type_id'] = $row['variant_type_id'];
		$sp['post_year'] = $row['post_year'];
		$sp['fuel'] = $row['fuel'];
		$sp['km_driven'] = $row['km_driven'];
		$sp['no_owner'] = $row['no_owner'];
		$sp['property_type'] = $row['property_type'];
		$sp['property_bedroom'] = $row['property_bedroom'];
		$sp['property_bathroom'] = $row['property_bathroom'];
		$sp['property_furnishing'] = $row['property_furnishing'];
		$sp['property_construction_status'] = $row['property_construction_status'];
		$sp['property_listed_by'] = $row['property_listed_by'];
		$sp['property_superbuildarea'] = $row['property_superbuildarea'];
		$sp['property_sellifypetarea'] = $row['property_sellifypetarea'];
		$sp['property_maintaince_monthly'] = $row['property_maintaince_monthly'];
		$sp['property_total_floor'] = $row['property_total_floor'];
		$sp['property_floor_no'] = $row['property_floor_no'];
		$sp['property_sellify_parking'] = $row['property_sellify_parking'];
		$sp['property_facing'] = $row['property_facing'];
		$sp['project_name'] = $row['project_name'];
		$sp['property_bachloar'] = $row['property_bachloar'];
		$sp['property_land_type'] = $row['property_land_type'];
		$sp['plot_area'] = $row['plot_area'];
		$sp['plot_length'] = $row['plot_length'];
		$sp['plot_breadth'] = $row['plot_breadth'];
		$sp['pg_subtype'] = $row['pg_subtype'];
		$sp['pg_meals_include'] = $row['pg_meals_include'];
		$sp['mobile_brand'] = $row['mobile_brand'];
		$sp['accessories_type'] = $row['accessories_type'];
		$sp['tablet_type'] = $row['tablet_type'];
		$sp['job_salary_period'] = $row['job_salary_period'];
		$sp['motocycle_brand_id'] = $row['motocycle_brand_id'];
		$sp['motorcycle_model_id'] = $row['motorcycle_model_id'];
		$sp['scooter_brand_id'] = $row['scooter_brand_id'];
		$sp['scooter_model_id'] = $row['scooter_model_id'];
		$sp['bicycles_brand_id'] = $row['bicycles_brand_id'];
		$sp['commercial_brand_id'] = $row['commercial_brand_id'];
		$sp['commercial_model_id'] = $row['commercial_model_id'];
		$sp['sparepart_type_id'] = $row['sparepart_type_id'];
		$sp['service_type_id'] = $row['service_type_id'];
		$sp['is_approve'] = $row['is_approve'];
		$sp['is_sold'] = $row['is_sold'];
		$sp['post_type'] = $row['post_type'];
		$sp['sold_type'] = $row['sold_type'];
		$sp['is_paid'] = $row['is_paid'];
		$sp['is_favourite'] = $sellify->query("select * from tbl_fav where uid=".$uid." and post_id=".$row['id']."")->num_rows;
		$sp['total_favourite'] = $sellify->query("select * from tbl_fav where post_id=".$row['id']."")->num_rows;
		$sp['total_views'] = $sellify->query("select * from tbl_view where post_id=".$row['id']."")->num_rows;
		$pp[] = $sp;
	}	
	
$postlist = $sellify->query("SELECT 
    *,
    (
        (
            acos(
                sin(({$lats} * pi() / 180)) * sin((`lats` * pi() / 180)) +
                cos(({$lats} * pi() / 180)) * cos((`lats` * pi() / 180)) *
                cos((({$longs} - `longs`) * pi() / 180))
            )
        ) * 180 / pi()
    ) * 60 * 1.1515 * 1.609344 AS distance
FROM 
    tbl_post
WHERE 
    post_status = 1 
    AND is_sold = 0 
    AND is_approve = 1 
    AND is_expire = 0 
    AND uid != {$uid}
HAVING 
    distance < 100;
");	
$s = array();
	$p = array();
	while($row = $postlist->fetch_assoc())
	{
		$udata = $sellify->query("select * from tbl_user where id=".$row['uid']."")->fetch_assoc();
		$im = explode('$;',$row['post_img']);
		$s['post_id'] = $row['id'];
		$s['cat_id'] = $row['cat_id'];
		$s['post_owner_id'] = $row['uid'];
		$s['owner_name'] = $udata['name'];
		$s['owner_img'] = $udata['profile_pic'];
		$s['owner_mobile'] = $udata['ccode'].$udata['mobile'];
		$s['subcat_id'] = $row['subcat_id'];
		$s['post_image'] = $im[0];
		$s['post_all_image'] = $im;
		$s['post_title'] = $row['ad_title'];
		$s['post_date'] = $row['post_date'];
		$s['ad_price'] = $row['ad_price'];
		$s['job_salary_from'] = $row['job_salary_from'];
		$s['job_salary_to'] = $row['job_salary_to'];
		$s['job_salary_period'] = $row['job_salary_period'];
		$s['job_position_type'] = $row['job_position_type'];
		$s['full_address'] = $row['full_address'];
		$s['lats'] = $row['lats'];
		$s['longs'] = $row['longs'];
		$s['transmission'] = $row['transmission'];
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
		$s['is_favourite'] = $sellify->query("select * from tbl_fav where uid=".$uid." and post_id=".$row['id']."")->num_rows;
		$s['total_favourite'] = $sellify->query("select * from tbl_fav where post_id=".$row['id']."")->num_rows;
		$s['total_views'] = $sellify->query("select * from tbl_view where post_id=".$row['id']."")->num_rows;
		$p[] = $s;
	}	
$returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Home Data Get Successfully!!!","currency"=>$set['currency'],"categorylist"=>$c,"featurelist"=>$pp,"adlist"=>$p);	
}
echo json_encode($returnArr);