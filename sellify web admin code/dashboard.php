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
                  <h3>Report Data</h3>
                </div>
               
              </div>
            </div>
          </div>
          <!-- Container-fluid starts-->
          <div class="container-fluid dashboard-default">
		 
            <div class="row">
             
           <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Banner<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_banner")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/banner.png" style="width: 60px;">


                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
			  
			 
			  
			  
			  
			  
			 
			  
			  
			  
			  <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">FAQ<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_faq")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/faq.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
			  
			  <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Payment Gateway<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_payment_list")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/paymentgateway.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
			  
			  
			  
			  <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Dynamic Pages<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_page")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/dynamicpages.png" style="width: 60px;">
                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
			  
			  
			  
			  <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Users<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_user")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/user.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Category<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_category")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/category.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Subcategory<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_subcategory")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/sub-category.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
              
              <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Package<i class="fa fa-circle"> </i></p>
                        <h4><?php echo $sellify->query("select * from tbl_package")->num_rows;?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/package.png" style="width: 60px;">

                      </div>
                    </div>
                  </div>
                  
                </div>
              </div>
              
              
               <div class="col-sm-6 col-lg-3">
                <div class="sellifyd o-hidden">
                  <div class="sellifyd-header pb-0">
                    <div class="d-flex"> 
                      <div class="flex-grow-1"> 
                        <p class="square-after f-w-600 header-text-primary">Total Earning<i class="fa fa-circle"> </i></p>
                        <h4><?php $earn = $sellify->query("select sum(`amount`) as total_earn from purchase_history")->fetch_assoc(); echo $earn['total_earn'].$set['currency'];?></h4>
                      </div>
                      <div class="d-flex static-widget">
                        <img src="images/dashboard/earning.png" style="width: 60px;">

                      </div>
                    </div>
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