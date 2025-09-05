<?php 
require 'inc/Config.php';

if(isset($_POST['subcat_id']))
{
	$subcat_id = $_POST['subcat_id'];
	
	
											$clist = $sellify->query("select * from tbl_brand where subcat_id=".$subcat_id."");
											?>
											<option value="">Select Bike/Scooter Brand</option>
											<?php 
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>"><?php echo $row["title"];?></option>
											<?php } 
}
?>