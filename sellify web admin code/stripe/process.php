<?php
require dirname(dirname(__FILE__)) . '/inc/Config.php';
$kb = $sellify->query("SELECT * FROM `tbl_payment_list` where id=4")->fetch_assoc();
$kk = explode(',',$kb['attributes']);
//check if stripe token exist to proceed with payment
if(!empty($_POST['stripeToken'])){
    // get token and user details
    $stripeToken  = $_POST['stripeToken'];
    $custName = $_POST['custName'];
    $custEmail = $_POST['custEmail'];
    $sellifydNumber = $_POST['sellifydNumber'];
    $sellifydCVC = $_POST['sellifydCVC'];
    $sellifydExpMonth = $_POST['sellifydExpMonth'];
    $sellifydExpYear = $_POST['sellifydExpYear'];    
    //include Stripe PHP library
    require_once('stripe-php/init.php');    
    //set stripe secret key and publishable key
    $stripe = array(
      "secret_key"      => $kk[1],
      "publishable_key" => $kk[0]
    );    
    \Stripe\Stripe::setApiKey($stripe['secret_key']);    
    //add customer to stripe
    if (isset($_POST['stripeToken'])){
        try {
    $customer = \Stripe\Customer::create(array(
        'email' => $custEmail,
        'source'  => $stripeToken,
        'name' => $custName,
        "address" => ["city" => 'xxx', "country" => 'IN', "line1" => 'abc', "line2" => "", "postal_code" => '123456', "state" => 'GJ']
    ));   
    // item details for which payment made
    $itemName = "groheroe_items";
    $itemNumber = md5(uniqid(rand(), true));
    $itemPrice = $_POST['itemprice'];
	
    $currency = "inr";
    $orderID = md5(uniqid(rand(), true));    
    // details for which payment performed
    $payDetails = \Stripe\Charge::create(array(
        'customer' => $customer->id,
        'amount'   => $itemPrice * 100,
        'currency' => $currency,
        'description' => $itemName,
        'metadata' => array(
            'order_id' => $orderID
        )
    ));
     // get payment details
    $paymenyResponse = $payDetails->jsonSerialize();
    
    if($paymenyResponse['amount_refunded'] == 0 && empty($paymenyResponse['failure_code']) && $paymenyResponse['paid'] == 1 && $paymenyResponse['captured'] == 1){
       
        
        $amountPaid = $paymenyResponse['amount'];
        $balanceTransaction = $paymenyResponse['balance_transaction'];
        $paidCurrency = $paymenyResponse['currency'];
        $paymentStatus = $paymenyResponse['status'];
        $tid = $paymenyResponse['balance_transaction'];
        
        $paymentDate = date("Y-m-d H:i:s");        
        
		
       
       if( $paymentStatus == 'succeeded'){
            
        
          ?>
          <script>
              window.location.href="man.php?Transaction_id=<?php echo $tid;?>&status=success&message=The payment was successful!!"
          </script>
          <?php
       } else{
         
          
       
          ?>
          <script>
              window.location.href="man.php?status=failed&message=payment failed!!"
          </script>
          <?php
       }
    } else{
    
     ?>
          <script>
              window.location.href="man.php?status=failed&message=payment failed!!"
          </script>
          <?php
    }
        }
        catch(Stripe_sellifydError $e) {
  $error1 = $e->getMessage();
 
 ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error1; ?>"
          </script>
          <?php
} catch (Stripe_InvalidRequestError $e) {
  
  $error2 = $e->getMessage();
 
  ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error2; ?>"
          </script>
          <?php
} catch (Stripe_AuthenticationError $e) {

  $error3 = $e->getMessage();

  ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error3; ?>"
          </script>
          <?php
} catch (Stripe_ApiConnectionError $e) {
  
  $error4 = $e->getMessage();
  
   ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error4; ?>"
          </script>
          <?php
} catch (Stripe_Error $e) {
  
  $error5 = $e->getMessage();
  
   ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error5; ?>"
          </script>
          <?php
} catch (Exception $e) {
  
  $error6 = $e->getMessage();

  ?>
          <script>
              window.location.href="man.php?status=failed&message=<?php echo $error6; ?>"
          </script>
          <?php
}  
    }
   
   // echo json_encode($returnArr);
} 

?>