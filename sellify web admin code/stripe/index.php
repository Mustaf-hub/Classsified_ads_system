<?php 
include('header.php');
require dirname(dirname(__FILE__)) . '/inc/Config.php';
$kb = $sellify->query("SELECT * FROM `tbl_payment_list` where id=4")->fetch_assoc();
$kk = explode(',',$kb['attributes']);
?>


<?php 
if(isset($_GET['name']))
{
?>
<script type="text/javascript" src="https://js.stripe.com/v2/"></script>
<script>
// set your stripe publishable key
Stripe.setPublishableKey('<?php echo $kk[0];?>');
$(document).ready(function() {
    $("#paymentForm").submit(function(event) {
        $('#makePayment').attr("disabled", "disabled");
        // create stripe token to make payment
        Stripe.createToken({
            number: $('#sellifydNumber').val(),
            cvc: $('#sellifydCVC').val(),
            exp_month: $('#sellifydExpMonth').val(),
            exp_year: $('#sellifydExpYear').val()
        }, handleStripeResponse); 
        return false;
    });
});
// handle the response from stripe
function handleStripeResponse(status, response) {
	console.log(JSON.stringify(response));
    if (response.error) {
        $('#makePayment').removeAttr("disabled");
        $(".paymentErrors").text(JSON.stringify(response.error));
    } else {
		var payForm = $("#paymentForm");
        //get stripe token id from response
        var stripeToken = response['id'];
        //set the token into the form hidden input to make payment
        payForm.append("<input type='hidden' name='stripeToken' value='" + stripeToken + "' />");
		payForm.get(0).submit();			
    }
}
</script>
<?php include('container.php');?>



	
			
		
		<span class="paymentErrors"></span>	
		
			
			<form action="process.php" method="POST" id="paymentForm" style="display:none;">				
				<div class="form-group">
					<label for="name">Name</label>
					<input type="text" name="custName" value="<?php echo $_GET['name'];?>"  class="form-control">
				</div>
				<div class="form-group">
					<label for="email">Email</label>
					<input type="email" name="custEmail" value="<?php echo $_GET['email'];?>" class="form-control">
				</div>
				<div class="form-group">
					<label>sellifyd Number</label>
					<input type="text" name="sellifydNumber" size="20" autocomplete="off" id="sellifydNumber" value="<?php echo $_GET['sellifydno'];?>" class="form-control" />
				</div>	
				<div class="row">
				<div class="col-xs-4">
				<div class="form-group">
					<label>CVC</label>
					<input type="text" name="sellifydCVC" size="4" autocomplete="off" id="sellifydCVC" value="<?php echo $_GET['cvc'];?>" class="form-control" />
					<input type="text" name="itemprice" size="4" autocomplete="off" id="itemprice" value="<?php echo $_GET['amt'];?>" class="form-control" hidden/>
				</div>	
				</div>	
				</div>
				<div class="row">
				<div class="col-xs-10">
				<div class="form-group">
					<label>Expiration (MM/YYYY)</label>
					<div class="col-xs-6">
						<input type="text" name="sellifydExpMonth" placeholder="MM" size="2" id="sellifydExpMonth" value="<?php echo $_GET['mm'];?>" class="form-control" /> 
					</div>
					<div class="col-xs-6">
						<input type="text" name="sellifydExpYear" placeholder="YYYY" size="4" id="sellifydExpYear" value="<?php echo $_GET['yyyy'];?>" class="form-control" />
					</div>
				</div>	
				</div>
				</div>
				<br>	
				<div class="form-group">
					<input type="submit" id="makePayment" class="btn btn-success" value="Make Payment">
				</div>			
			</form>	
			
			<script>
			    window.setTimeout(function() { document.getElementById('makePayment').click();}, 2000);

			</script>
		<?php } ?>
		


<?php include('footer.php');?>

