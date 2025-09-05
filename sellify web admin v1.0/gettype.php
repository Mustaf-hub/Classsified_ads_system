<?php 
require 'inc/Config.php';

if(isset($_POST['brand_id']))
{
	$brand_id = $_POST['brand_id'];
	
	
											$clist = $sellify->query("select * from car_variation where brand_id=".$brand_id."");
											?>
											<option value="">Select sellify Variation</option>
											<?php 
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>"><?php echo $row["title"];?></option>
											<?php } 
}
?>