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
                  <h3>Bike / Scooter /Commercial Vehicle Brand Management</h3>
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
					 $data = $sellify->query("select * from car_brand where id=".$_GET['id']."")->fetch_assoc();
					 ?>
					 <form method="post" enctype="multipart/form-data">
                                    
                                    <div class="sellifyd-body">
                                        
										<div class="form-group mb-3">
                                            <label>Select Subcategory</label>
                                            <select name="subcat_id" class="form-control select2-multi-subcategory" required>
											<option value="">Select Subcategory</option>
											<?php 
											$clist = $sellify->query("select * from tbl_subcategory where is_brand=1");
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>" <?php if($data["subcat_id"] == $row["id"]){echo 'selected';}?>><?php echo $row["title"];?></option>
											<?php } ?>
											</select>
                                        </div>
										
										<div class="form-group mb-3">
                                            <label> Brand Image</label>
                                            <input type="text" class="form-control" name="title" placeholder="Enter  Brand Title" value="<?php echo $data['title'];?>" required="">
											
                                        </div>
										
										
                                        <div class="form-group mb-3">
                                            <label> Brand Image</label>
                                            <input type="file" class="form-control" name="cat_img" >
											<br>
											<img src="<?php echo $data['img']?>" width="100px"/>
											<input type="hidden" name="type" value="edit_brand"/>
											
										<input type="hidden" name="id" value="<?php echo $_GET['id'];?>"/>
                                        </div>
										
										
										
										 <div class="form-group mb-3">
                                            <label> Brand Status</label>
                                            <select name="status" class="form-control" required>
											<option value="">Select Status</option>
											<option value="1" <?php if($data['status'] == 1){echo 'selected';}?>>Publish</option>
											<option value="0" <?php if($data['status'] == 0){echo 'selected';}?> >UnPublish</option>
											</select>
                                        </div>
                                        
										
                                    </div>
                                    <div class="sellifyd-footer text-left">
                                        <button  type="submit" class="btn btn-primary">Edit Brand</button>
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
                                            <label>Select Subcategory</label>
                                            <select name="subcat_id" class="form-control select2-multi-subcategory" required>
											<option value="">Select Subcategory</option>
											<?php 
											$clist = $sellify->query("select * from tbl_subcategory where is_brand=1");
											while($row = $clist->fetch_assoc())
											{
											?>
											<option value="<?php echo $row["id"];?>"><?php echo $row["title"];?></option>
											<?php } ?>
											</select>
                                        </div>
										
										<div class="form-group mb-3">
                                            <label>Brand Title</label>
                                            <input type="text" class="form-control" placeholder="Enter  Brand Title" name="title"  required="">
											
                                        </div>
										
                                        <div class="form-group mb-3">
                                            <label>Brand Image</label>
                                            <input type="file" class="form-control" name="cat_img"  required="">
											<input type="hidden" name="type" value="add_brand"/>
                                        </div>
										
										
										
										 <div class="form-group mb-3">
                                            <label>Brand Status</label>
                                            <select name="status" class="form-control" required>
											<option value="">Select Status</option>
											<option value="1">Publish</option>
											<option value="0">UnPublish</option>
											</select>
                                        </div>
                                        
										
                                    </div>
                                    <div class="sellifyd-footer text-left">
                                        <button  type="submit" class="btn btn-primary">Add Brand</button>
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