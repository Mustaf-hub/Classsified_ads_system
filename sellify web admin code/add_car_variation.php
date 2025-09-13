<?php 
require 'inc/Header.php';

?>
    <!-- Loader ends-->
    <!-- page-wrapper Start-->
    <div class="page-wrapper compact-wrapper" id="pageWrapper">
      <!-- Page Header Start-->
    <?php require 'inc/Navbar.php';?>
      <!-- Page Header Ends-->
      <!-- Page Body Start-->
      <div class="page-body-wrapper">
        <!-- Page Sidebar Start-->
       <?php require 'inc/Sidebar.php';?>
        <!-- Page Sidebar Ends-->
        <div class="page-body">
          <div class="container-fluid">
            <div class="page-title">
              <div class="row">
                <div class="col-sm-6">
                  <h3>Car Variation Management</h3>
                </div>
               
              </div>
            </div>
          </div>
          <!-- Container-fluid starts-->
          <div class="container-fluid dashboard-default">
            <div class="row">
           <div class="col-sm-12">
                <div class="sellifyd">
                 <?php 
				 if(isset($_GET['id']))
				 {
					 $data = $sellify->query("select * from car_variation where id=".$_GET['id']."")->fetch_assoc();
					 ?>
					 <form method="post" enctype="multipart/form-data">
                                    
                                    <div class="sellifyd-body">
                                        
										<div class="form-group mb-3">
                                            <label>Select Car Brand</label>
                                            <select name="brand_id" class="form-control select2-multi-brand" required>
											<option value="">Select Car Brand</option>
											<?php 
											$clist = $sellify->query("select * from car_brand where status=1");
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>" <?php if($row["id"] == $data["brand_id"]){echo 'selected';}?>><?php echo $row["title"];?></option>
											<?php } ?>
											</select>
                                        </div>
										
										<div class="form-group mb-3">
                                            <label>Car Brand Title</label>
                                            <input type="text" class="form-control" name="title" placeholder="Enter Car Variation Title" value="<?php echo $data['title'];?>" required="">
											<input type="hidden" name="type" value="edit_sellify_variation"/>
											
										<input type="hidden" name="id" value="<?php echo $_GET['id'];?>"/>
                                        </div>
										
										
                                        
										
										
										 <div class="form-group mb-3">
                                            <label>Car Brand Status</label>
                                            <select name="status" class="form-control" required>
											<option value="">Select Status</option>
											<option value="1" <?php if($data['status'] == 1){echo 'selected';}?>>Publish</option>
											<option value="0" <?php if($data['status'] == 0){echo 'selected';}?> >UnPublish</option>
											</select>
                                        </div>
                                        
										
                                    </div>
                                    <div class="sellifyd-footer text-left">
                                        <button  type="submit" class="btn btn-primary">Edit  Car Variation</button>
                                    </div>
                                </form>
					 <?php 
				 }
				 else 
				 {
				 ?>
                  <form method="post" enctype="multipart/form-data">
                                    
                                    <div class="sellifyd-body">
                                        
										<div class="form-group mb-3">
                                            <label>Select Car Brand</label>
                                            <select name="brand_id" class="form-control select2-multi-brand" required>
											<option value="">Select Car Brand</option>
											<?php 
											$clist = $sellify->query("select * from sellify_brand where status=1");
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>"><?php echo $row["title"];?></option>
											<?php } ?>
											</select>
                                        </div>
										
										
										<div class="form-group mb-3">
                                            <label>Car Variation Title</label>
                                            <input type="text" class="form-control" placeholder="Enter Car Variation Title" name="title"  required="">
											<input type="hidden" name="type" value="add_sellify_variation"/>
                                        </div>
										
                                       
										
										
										
										 <div class="form-group mb-3">
                                            <label>Car Variation Status</label>
                                            <select name="status" class="form-control" required>
											<option value="">Select Status</option>
											<option value="1">Publish</option>
											<option value="0">UnPublish</option>
											</select>
                                        </div>
                                        
										
                                    </div>
                                    <div class="sellifyd-footer text-left">
                                        <button  type="submit" class="btn btn-primary">Add Car Variation</button>
                                    </div>
                                </form>
				 <?php } ?>
                </div>
              
                
              </div>
            
            </div>
          </div>
          <!-- Container-fluid Ends-->
        </div>
        <!-- footer start-->
       
      </div>
    </div>
    <!-- latest jquery-->
   <?php require 'inc/Footer.php'; ?>
    <!-- login js-->
  </body>


</html>