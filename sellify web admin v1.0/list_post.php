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
                  <h3>Ad List Management</h3>
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
				<div class="table-responsive">
                <table class="display" id="basic-1">
                        <thead>
                          <tr>
                            <th>Sr No.</th>
							
											<th>Ad Images</th>
											<th>Ad Title</th>
												<th>Ad Description</th>
												<th>Ad Price</th>
												<th>Ad Status</th>
												
												<th>Action</th>
                          </tr>
                        </thead>
                        <tbody>
                           <?php 
										$city = $sellify->query("select * from tbl_post where is_approve=0");
										$i=0;
										while($row = $city->fetch_assoc())
										{
											$i = $i + 1;
											?>
											<tr>
                                                <td>
                                                    <?php echo $i; ?>
                                                </td>
                                                
												
												
                                                <td class="align-middle">
                                                    <?php 
                                                    $pimg = explode('$;',$row['post_img']);
                                                    foreach($pimg as $img)
                                                    {
                                                        
                                                    ?>
                                                   <img src="<?php echo $img; ?>" width="70" height="80"/>
                                                   <?php } ?>
                                                </td>
<td>
                                                    <?php echo $row['ad_title']; ?>
                                                </td>
                                                
                                                <td>
                                                    <?php echo $row['ad_description']; ?>
                                                </td>
                                                
                                                <td>
                                                    <?php echo $row['ad_price'].$set['currency']; ?>
                                                </td>
                                               
												<?php if($row['post_status'] == 1) { ?>
												
                                                <td><span class="badge badge-success">Publish</span></td>
												<?php } else { ?>
												
												<td>
												<span class="badge badge-danger">Unpublish</span></td>
												<?php } ?>
                                                <td style="white-space: nowrap; width: 15%;"><div class="tabledit-toolbar btn-toolbar" style="text-align: left;">
                                           <div class="btn-group btn-group-sm" style="float: none;">
                                               <?php 
                                               if($row['is_approve']==1)
                                               {
                                                   ?>
                                                   <span class="text text-success">Approved</span>
                                                   <?php 
                                               }
                                               else 
                                               {
                                               ?>
                                               
										   <span data-id="<?php echo $row['id'];?>" data-status="1" data-type="update_status" coll-type="poststatus" class="badge drop  badge-success">Make Approve</span>
										   <?php } ?>
										   </div>
                                           
                                       </div></td>
                                                </tr>
											<?php 
										}
										?>
                          
                        </tbody>
                      </table>
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