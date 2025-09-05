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
                  <h3>Package Management</h3>
                </div>
               
              </div>
            </div>
          </div>
          <!-- Container-fluid starts-->
          <div class="container-fluid dashboard-default">
            <div class="row">
           <div class="col-sm-12">
                 <div class="sellifyd">
				<div class="sellifyd-body">
                 <?php 
				 if(isset($_GET['id']))
				 {
					 $data = $sellify->query("select * from tbl_faq where id=".$_GET['id']."")->fetch_assoc();
					 ?>
					 <form method="POST"  enctype="multipart/form-data">
								
								<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Package Title</label>
                                    
                                  <input type="text" class="form-control" placeholder="Enter Package Title" value="<?php echo $data['title'];?>" name="title">
                               
								</div>
								
								<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Package Days</label>
                                    
                                  <input type="number" class="form-control" placeholder="Enter Package days" value="<?php echo $data['days'];?>" name="days">
                                <input type="hidden" name="type" value="edit_package"/>
										<input type="hidden" name="id" value="<?php echo $_GET['id'];?>"/>
								</div>
								
                                    
									<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Enter Package Price</label>
                                    
                                  <input type="number" class="form-control" step="0.01" placeholder="Enter Package Price" value="<?php echo $data['price'];?>" name="price">
                               
								</div>
								
								<div class="form-group mb-3">
                                    
                                        <label  for="inputGroupSelect01">Select Post Type</label>
                                    
                                    <select  class="form-control" name="post_type" id="inputGroupSelect01" required>
                                        <option value="">Choose...</option>
                                        <option value="Featured_Based" <?php if($data['post_type'] == 'Featured_Based'){echo 'selected';}?>>Featured Based</option>
                                        <option value="Post_Based" <?php if($data['post_type'] == 'Post_Based'){echo 'selected';}?>>Post Based</option>
										<option value="Both" <?php if($data['post_type'] == 'Both'){echo 'selected';}?>>Both</option>
                                       
                                    </select>
                                </div>
								
                                   <div class="form-group mb-3">
                                    
                                        <label  for="inputGroupSelect01">Select Status</label>
                                    
                                    <select  class="form-control" name="status" id="inputGroupSelect01" required>
                                        <option value="">Choose...</option>
                                        <option value="1" <?php if($data['status'] == 1){echo 'selected';}?>>Publish</option>
                                        <option value="0" <?php if($data['status'] == 0){echo 'selected';}?>>Unpublish</option>
                                       
                                    </select>
                                </div>
                                    <button type="submit" class="btn btn-primary">Edit Package</button>
                                </form>
					 <?php 
				 }
				 else 
				 {
				 ?>
                  <form method="POST"  enctype="multipart/form-data">
								
								<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Enter Package Title</label>
                                    
                                  <input type="text" class="form-control" placeholder="Enter Package Title"  name="title">
                            
								</div>
								
								<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Package Days</label>
                                    
                                  <input type="number" class="form-control" placeholder="Enter Package days"  name="days">
                                <input type="hidden" name="type" value="add_package"/>	
								</div>
								
                                    
									<div class="form-group mb-3">
                                   
                                        <label  id="basic-addon1">Enter Package Price</label>
                                    
                                  <input type="number" class="form-control" step="0.01" placeholder="Enter Package Price"  name="price">
                               
								</div>
								
								<div class="form-group mb-3">
                                    
                                        <label  for="inputGroupSelect01">Select Post Type</label>
                                    
                                    <select  class="form-control" name="post_type" id="inputGroupSelect01" required>
                                        <option value="">Choose...</option>
                                        <option value="Featured_Based">Featured Based</option>
                                        <option value="Post_Based">Post Based</option>
										<option value="Both">Both</option>
                                       
                                    </select>
                                </div>
								
                                   <div class="form-group mb-3">
                                   
                                        <label  for="inputGroupSelect01">Select Status</label>
                                    
                                    <select class="form-control" name="status" id="inputGroupSelect01" required>
                                        <option value="">Choose...</option>
                                        <option value="1">Publish</option>
                                        <option value="0">Unpublish</option>
                                       
                                    </select>
                                </div>
                                    <button type="submit" class="btn btn-primary">Add Package</button>
                                </form>
				 <?php } ?>
                </div>
              
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