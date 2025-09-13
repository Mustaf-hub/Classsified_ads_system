<?php 
require dirname( dirname(__FILE__) ).'/inc/Config.php';
header('Content-type: text/json');
$data = json_decode(file_get_contents('php://input'), true);
$lats = $data['lats'];
$longs = $data['longs'];
$uid = $data['uid'];
$post_type = $data['post_type'];
$sort = $data['sort'];
$budget_start = $data['budget_start'];
$budget_end = $data['budget_end'];
$buildarea_start = $data['buildarea_start'];
$buildarea_end = $data['buildarea_end'];
$plotdarea_start = $data['plotdarea_start'];
$plotdarea_end = $data['plotdarea_end'];
$property_type = $data['property_type'];
$property_bedroom = $data['property_bedroom'];
$property_bathroom = $data['property_bathroom'];
$property_furnishing = $data['property_furnishing'];
$property_construction_status = $data['property_construction_status'];
$property_listed_by = $data['property_listed_by'];
$property_bachloar = $data['property_bachloar'];
$subcat_id = $data['subcat_id'];
$pg_subtype = $data['pg_subtype'];
$pg_meals_include = $data['pg_meals_include'];
if($uid == '')
{
 $returnArr = array("ResponseCode"=>"401","Result"=>"false","ResponseMsg"=>"Something Went Wrong!");    
}
else
{		
$query = "
    SELECT 
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
		AND subcat_id={$subcat_id}
        AND post_type = '{$post_type}'
";

if($subcat_id == 1)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}


if ($buildarea_start != 0 && $buildarea_end != 0) {
    $query .= " AND property_superbuildarea BETWEEN {$buildarea_start} AND {$buildarea_end}";
}

if($property_type !=0)
{
	$query .= " AND property_type IN('".$property_type."')";
}

if($property_bedroom !=0)
{
	$query .= " AND property_bedroom IN('".$property_bedroom."')";
}

if($property_bathroom !=0)
{
	$query .= " AND property_bathroom IN('".$property_bathroom."')";
}

if($property_furnishing !=0)
{
	$query .= " AND property_furnishing IN('".$property_furnishing."')";
}

if($property_construction_status !=0)
{
	$query .= " AND property_construction_status IN('".$property_construction_status."')";
}

if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}



}

if($subcat_id == 2)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}


if ($buildarea_start != 0 && $buildarea_end != 0) {
    $query .= " AND property_superbuildarea BETWEEN {$buildarea_start} AND {$buildarea_end}";
}

if($property_type !=0)
{
	$query .= " AND property_type IN(".$property_type.")";
}

if($property_bedroom !=0)
{
	$query .= " AND property_bedroom IN('".$property_bedroom."')";
}

if($property_bathroom !=0)
{
	$query .= " AND property_bathroom IN('".$property_bathroom."')";
}

if($property_furnishing !=0)
{
	$query .= " AND property_furnishing IN('".$property_furnishing."')";
}


if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}

if($bachloar !=0)
{ 
    if($bachloar == 'yes')
	{
	$query .= " AND property_bachloar=1";
	}
	else 
	{
		$query .= " AND property_bachloar=0";
	}

}

}

if($subcat_id == 3)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}

	if($property_type !=0)
{
	$query .= " AND property_type IN(".$property_type.")";
}

if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}


if ($plotdarea_start != 0 && $plotdarea_end != 0) {
    $query .= " AND plot_area BETWEEN {$plotdarea_start} AND {$plotdarea_end}";
}
}

if($subcat_id == 4)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}

	

if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}


if ($buildarea_start != 0 && $buildarea_end != 0) {
    $query .= " AND property_superbuildarea BETWEEN {$buildarea_start} AND {$buildarea_end}";
}

if($property_furnishing !=0)
{
	$query .= " AND property_furnishing IN('".$property_furnishing."')";
}


}

if($subcat_id == 5)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}

	if($property_furnishing !=0)
{
	$query .= " AND property_furnishing IN('".$property_furnishing."')";
}

if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}


if ($buildarea_start != 0 && $buildarea_end != 0) {
    $query .= " AND property_superbuildarea BETWEEN {$buildarea_start} AND {$buildarea_end}";
}

if($property_construction_status !=0)
{
	$query .= " AND property_construction_status IN('".$property_construction_status."')";
}


}

if($subcat_id == 6)
{
	if ($budget_start != 0 && $budget_end != 0) {
    $query .= " AND ad_price BETWEEN {$budget_start} AND {$budget_end}";
}

	if($property_furnishing !=0)
{
	$query .= " AND property_furnishing IN('".$property_furnishing."')";
}

if($property_listed_by !=0)
{
	$query .= " AND property_listed_by IN('".$property_listed_by."')";
}

if($pg_subtype !=0)
{
	$query .= " AND pg_subtype IN('".$pg_subtype."')";
}

if($pg_meals_include !=0)
{ 
    if($pg_meals_include == 'yes')
	{
	$query .= " AND pg_meals_include=1";
	}
	else 
	{
		$query .= " AND pg_meals_include=0";
	}

}

}

$query .= " HAVING distance < 50";

if ($sort == 1) {
    $query .= " ORDER BY post_date DESC";
} elseif ($sort == 2) {
    $query .= " ORDER BY ad_price ASC";  
} elseif ($sort == 3) {
    $query .= " ORDER BY ad_price DESC";
} elseif ($sort == 4) {
    $query .= " ORDER BY distance ASC";
}

	$postlist = $sellify->query($query);
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
$returnArr = array("ResponseCode"=>"200","Result"=>"true","ResponseMsg"=>"Property Filter Get Successfully!!!","filter"=>$p);	
}
echo json_encode($returnArr);