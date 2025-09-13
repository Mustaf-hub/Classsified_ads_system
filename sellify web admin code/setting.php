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
                  <h3>Setting  Management</h3>
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
				
						
						<h5 class="h5_set"><i class="fa fa-gear fa-spin"></i>  General  Information</h5>
				<form method="post" enctype="multipart/form-data">
                                       <div class="row">
									    <div class="form-group mb-3 col-3">
                                            <label><span class="text-danger">*</span> Website Name</label>
                                            <input type="text" class="form-control " placeholder="Enter Store Name" value="<?php echo $set['webname'];?>" name="webname" required="">
											<input type="hidden" name="type" value="edit_setting"/>
										<input type="hidden" name="id" value="1"/>
                                        </div>
										
                                      <div class="form-group mb-3 col-3" style="margin-bottom: 48px;">
                                            <label><span class="text-danger">*</span> Website Image</label>
                                            <div class="custom-file">
                                                <input type="file" name="weblogo" class="custom-file-input form-control">
                                                <label class="custom-file-label">Choose Website Image</label>
												<br>
												<img src="<?php echo $set['weblogo'];?>" width="60" height="60"/>
                                            </div>
                                        </div>
										
										<div class="form-group mb-3 col-3">
									<label for="cname">Select Timezone</label>
									<select name="timezone" class="form-control" required>
									<option value="">Select Timezone</option>
									<?php 
								$tzlist = DateTimeZone::listIdentifiers(DateTimeZone::ALL);
								$limit =  count($tzlist);
								?>
									<?php 
									for($k=0;$k<$limit;$k++)
									{
									?>
									<option <?php echo $tzlist[$k];?> <?php if($tzlist[$k] == $set['timezone']) {echo 'selected';}?>><?php echo $tzlist[$k];?></option>
									<?php } ?>
									</select>
								</div>
										
										<div class="form-group mb-3 col-3">
                                            <label><span class="text-danger">*</span> Currency</label>
                                            <input type="text" class="form-control" placeholder="Enter Currency"  value="<?php echo $set['currency'];?>" name="currency" required="">
                                        </div>
										
										
										
										
										
										
										
										
										
										
	
	<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fa fa-signal"></i> Onesignal Information</h5>
										</div>
										<div class="form-group mb-3 col-6">
                                            <label><span class="text-danger">*</span> User App Onesignal App Id</label>
                                            <input type="text" class="form-control " placeholder="Enter User App Onesignal App Id"  value="<?php echo $set['one_key'];?>" name="one_key" required="">
                                        </div>
										
										<div class="form-group mb-3 col-6">
                                            <label><span class="text-danger">*</span> User  App Onesignal Rest Api Key</label>
                                            <input type="text" class="form-control " placeholder="Enter User Boy App Onesignal Rest Api Key"  value="<?php echo $set['one_hash'];?>" name="one_hash" required="">
                                        </div>
	
										
										
										
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fa fa-user-plus" aria-hidden="true"></i> Refer And Earn Information</h5>
										</div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Sign Up Credit</label>
                                            <input type="text" class="form-control numberonly" placeholder="Enter Sign Up Credit"  value="<?php echo $set['scredit'];?>" name="scredit" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Refer Credit</label>
                                            <input type="text" class="form-control numberonly" placeholder="Enter Refer Credit"  value="<?php echo $set['rcredit'];?>" name="rcredit" required="">
                                        </div> 
										
										
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Sms Type</label>
                                           <select class="form-control" name="sms_type">
										   <option value="">select sms type</option>
										   <option value="Msg91" <?php if($set['sms_type'] == 'Msg91'){echo 'selected';}?>>Msg91</option>
										   <option value="Twilio" <?php if($set['sms_type'] == 'Twilio'){echo 'selected';}?>>Twilio</option>
										  
										   </select>
                                        </div>
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fas fa-sms"></i> Msg91 Sms Configurations</h5>
										</div>
	                                    
										<div class="form-group mb-3 col-6">
                                            <label><span class="text-danger">*</span>Msg91 Auth Key</label>
                                            <input type="text" class="form-control " placeholder="Msg91 Auth Key"  value="<?php echo $set['auth_key'];?>" name="auth_key" required="">
                                        </div>
										
										<div class="form-group mb-3 col-6">
                                            <label><span class="text-danger">*</span> Msg91 Otp Template Id</label>
                                            <input type="text" class="form-control " placeholder="Msg91 Otp Template Id"  value="<?php echo $set['otp_id'];?>" name="otp_id" required="">
                                        </div>
										
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fas fa-sms"></i> Twilio Sms Configurations </h5>
										</div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span>Twilio Account SID</label>
                                            <input type="text" class="form-control " placeholder="Twilio Account SID"  value="<?php echo $set['acc_id'];?>" name="acc_id" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Twilio Auth Token</label>
                                            <input type="text" class="form-control " placeholder="Twilio Auth Token"  value="<?php echo $set['auth_token'];?>" name="auth_token" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Twilio Phone Number</label>
                                            <input type="text" class="form-control " placeholder="Twilio Phone Number"  value="<?php echo $set['twilio_number'];?>" name="twilio_number" required="">
                                        </div>
										
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fa fa-phone"></i> Otp Configurations</h5>
										</div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Otp Auth In Sign up ? </label>
                                            <select class="form-control" name="otp_auth">
										   <option value="">Select Option</option>
										   <option value="Yes" <?php if($set['otp_auth'] == 'Yes'){echo 'selected';}?>>Yes</option>
										   <option value="No" <?php if($set['otp_auth'] == 'No'){echo 'selected';}?>>No</option>
										   
										   </select>
                                        </div>
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fa fa-gear fa-spin"></i> Other Setting</h5>
										</div>
										
										<div class="form-group mb-3 col-3">
                                            <label><span class="text-danger">*</span> Admob Enable ?</label>
                                           <select class="form-control" name="admob">
										   <option value="">Select Option</option>
										   <option value="Yes" <?php if($set['admob'] == 'Yes'){echo 'selected';}?>>Yes</option>
										   <option value="No" <?php if($set['admob'] == 'No'){echo 'selected';}?>>No</option>
										   
										   </select>
                                        </div>
										
										
										
										<div class="form-group mb-3 col-3">
                                            <label><span class="text-danger">*</span> Maintenance Mode</label>
                                           <select class="form-control" name="mode">
										   <option value="">Select Option</option>
										   <option value="Yes" <?php if($set['mode'] == 'Yes'){echo 'selected';}?>>Yes</option>
										   <option value="No" <?php if($set['mode'] == 'No'){echo 'selected';}?>>No</option>
										   
										   </select>
                                        </div>
										
										
										
										<div class="form-group mb-3 col-12">
										<h5 class="h5_set"><i class="fa fa-image"></i> Admob Configurations </h5>
										</div>
										
								          <div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Banner Ad Id</label>
                                            <input type="text" class="form-control " placeholder="Enter Banner Ad Id"  value="<?php echo $set['banner_id'];?>" name="banner_id" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Interstitial Ad Id </label>
                                            <input type="text" class="form-control " placeholder="Enter Interstitial Ad Id"  value="<?php echo $set['in_id'];?>" name="in_id" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Ios Banner Ad Id</label>
                                            <input type="text" class="form-control " placeholder="Ios Banner Ad Id"  value="<?php echo $set['ios_banner_id'];?>" name="ios_banner_id" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Ios Interstitial Ad Id</label>
                                            <input type="text" class="form-control " placeholder="Ios Interstitial Ad Id"  value="<?php echo $set['ios_in_id'];?>" name="ios_in_id" required="">
                                        </div>
                                        
                                        	<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Native Ad Id</label>
                                            <input type="text" class="form-control " placeholder="Native Ad Id"  value="<?php echo $set['native_ad'];?>" name="native_ad" required="">
                                        </div>
										
										<div class="form-group mb-3 col-4">
                                            <label><span class="text-danger">*</span> Ios Native Ad Id</label>
                                            <input type="text" class="form-control " placeholder="Ios Native Ad Id"  value="<?php echo $set['ios_native_ad'];?>" name="ios_native_ad" required="">
                                        </div>
										
										
								
								
								
										<div class="col-12">
                                                <button type="submit" name="edit_setting" class="btn btn-primary mb-2">Edit Setting</button>
                                            </div>
											</div>
                                    </form> 
	
								
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