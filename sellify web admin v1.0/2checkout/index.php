<div class="payment-frm">
    <h5>Charge $25 USD with 2Checkout</h5>
    
    <!-- credit sellifyd form -->
    <form id="paymentFrm" method="post" action="paymentSubmit.php">
        <div>
            <label>NAME</label>
            <input type="text" name="name" id="name" placeholder="Enter name" required autofocus>
        </div>
        <div>
            <label>EMAIL</label>
            <input type="email" name="email" id="email" placeholder="Enter email" required>
        </div>
        <div>
            <label>sellifyD NUMBER</label>
            <input type="text" name="sellifyd_num" id="sellifyd_num" placeholder="Enter sellifyd number" autocomplete="off" required>
        </div>
        <div>
            <label><span>EXPIRY DATE</span></label>
            <input type="number" name="exp_month" id="exp_month" placeholder="MM" required>
            <input type="number" name="exp_year" id="exp_year" placeholder="YY" required>
        </div>
        <div>
            <label>CVV</label>
            <input type="number" name="cvv" id="cvv" autocomplete="off" required>
        </div>
        
        <!-- hidden token input -->
        <input id="token" name="token" type="hidden" value="">
        
        <!-- submit button -->
        <input type="submit" class="btn btn-success" value="Submit Payment">
    </form>
</div>

<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<!-- 2Checkout JavaScript library -->
<script src="https://www.2checkout.com/checkout/api/2co.min.js"></script>

<script>
// Called when token is created successfully
var successCallback = function(data) {
  console.log("Token created successfully", data);
  var myForm = document.getElementById('paymentFrm');
  myForm.token.value = data.response.token.token; // Set the token value
  myForm.submit(); // Submit the form
};

// Called when token creation fails
var errorCallback = function(data) {
  console.error("Token creation failed", data);
  if (data.errorCode === 200) {
    tokenRequest(); // Retry token request
  } else {
    alert("Error: " + data.errorMsg);
  }
};

var tokenRequest = function() {
  // Validate input fields
  var sellifydNum = $("#sellifyd_num").val();
  var cvv = $("#cvv").val();
  var expMonth = $("#exp_month").val();
  var expYear = $("#exp_year").val();

  if (!sellifydNum || !cvv || !expMonth || !expYear) {
    alert("Please fill in all sellifyd details.");
    return;
  }

  // Setup token request arguments
  var args = {
    sellerId: "253248016872", // Replace with your Seller ID
    publishableKey: "eQM)ID@&vG84u!O*g[p+", // Replace with your valid publishable key
    ccNo: sellifydNum,
    cvv: cvv,
    expMonth: expMonth,
    expYear: expYear
  };

  console.log("Requesting token with args:", args);

  // Make the token request
  TCO.requestToken(successCallback, errorCallback, args);
};

$(function() {
  // Load public encryption key
  TCO.loadPubKey('sandbox'); // Change to 'production' for live environment

  $("#paymentFrm").submit(function(e) {
    e.preventDefault(); // Prevent default form submission
    tokenRequest(); // Initiate token request
    return false; // Ensure form does not submit
  });
});
</script>

