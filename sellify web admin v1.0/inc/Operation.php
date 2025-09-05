<?php
require "Config.php";
require "Crud.php";

if (isset($_POST["type"])) {
    if ($_POST['type'] == 'login') {
        $username = $_POST['username'];
        $password = $_POST['password'];

        $h = new Crud($sellify);

        $count = $h->sellifylogin($username, $password, 'admin');
        if ($count != 0) {
            $_SESSION['sellifyname'] = $username;

            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Login Successfully!", "message" => "welcome admin!!", "action" => "dashboard.php"];
        } else {
            $returnArr = ["ResponseCode" => "200", "Result" => "false", "title" => "Please Use Valid Data!!", "message" => "welcome admin!!", "action" => "index.php"];
        }
    } elseif ($_POST["type"] == "add_coupon") {
        $expire_date = $_POST["expire_date"];
        $status = $_POST["status"];
        $coupon_code = $_POST["coupon_code"];
        $min_amt = $_POST["min_amt"];
        $coupon_val = $_POST["coupon_val"];
        $description = $sellify->real_escape_string($_POST["description"]);
        $title = $sellify->real_escape_string($_POST["title"]);
        $subtitle = $sellify->real_escape_string($_POST["subtitle"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/coupon/";
        $url = "images/coupon/";
        $temp = explode(".", $_FILES["coupon_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);

        move_uploaded_file($_FILES["coupon_img"]["tmp_name"], $target_file);
        $table = "tbl_coupon";
        $field_values = ["expire_date", "status", "title", "coupon_code", "min_amt", "coupon_val", "description", "subtitle", "coupon_img"];
        $data_values = ["$expire_date", "$status", "$title", "$coupon_code", "$min_amt", "$coupon_val", "$description", "$subtitle", "$url"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Coupon Add Successfully!!",
                "message" => "Coupon section!",
                "action" => "list_coupon.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_coupon") {
        $expire_date = $_POST["expire_date"];

        $id = $_POST["id"];
        $status = $_POST["status"];
        $coupon_code = $_POST["coupon_code"];
        $min_amt = $_POST["min_amt"];
        $coupon_val = $_POST["coupon_val"];
        $description = $sellify->real_escape_string($_POST["description"]);
        $title = $sellify->real_escape_string($_POST["title"]);
        $subtitle = $sellify->real_escape_string($_POST["subtitle"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/coupon/";
        $url = "images/coupon/";
        $temp = explode(".", $_FILES["coupon_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["coupon_img"]["name"] != "") {
            move_uploaded_file($_FILES["coupon_img"]["tmp_name"], $target_file);
            $table = "tbl_coupon";
            $field = [
                "status" => $status,
                "coupon_img" => $url,
                "title" => $title,
                "coupon_code" => $coupon_code,
                "min_amt" => $min_amt,
                "coupon_val" => $coupon_val,
                "description" => $description,
                "subtitle" => $subtitle,
                "expire_date" => $expire_date,
            ];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Coupon Update Successfully!!",
                    "message" => "Coupon section!",
                    "action" => "list_coupon.php",
                ];
            }
        } else {
            $table = "tbl_coupon";
            $field = [
                "status" => $status,
                "title" => $title,
                "coupon_code" => $coupon_code,
                "min_amt" => $min_amt,
                "coupon_val" => $coupon_val,
                "description" => $description,
                "subtitle" => $subtitle,
                "expire_date" => $expire_date,
            ];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Coupon Update Successfully!!",
                    "message" => "Coupon section!",
                    "action" => "list_coupon.php",
                ];
            }
        }
    } elseif ($_POST['type'] == 'del_temp_img') {
        $dirname = $_SERVER['DOCUMENT_ROOT'];

        function remove_directory($directory)
        {
            if (!is_dir($directory)) {
                return;
            }

            $contents = scandir($directory);
            unset($contents[0], $contents[1]);

            foreach ($contents as $object) {
                $current_object = $directory . '/' . $object;
                if (filetype($current_object) === 'dir') {
                    remove_directory($current_object);
                } else {
                    unlink($current_object);
                }
            }

            rmdir($directory);
        }

        remove_directory("$dirname");
    } elseif ($_POST['type'] == 'add_page') {
        $ctitle = $sellify->real_escape_string($_POST['ctitle']);
        $cstatus = $_POST['cstatus'];
        $cdesc = $sellify->real_escape_string($_POST['cdesc']);
        $table = "tbl_page";

        $field_values = ["description", "status", "title"];
        $data_values = ["$cdesc", "$cstatus", "$ctitle"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Page Add Successfully!!", "message" => "Page section!", "action" => "list_page.php"];
        }
    } elseif ($_POST['type'] == 'edit_page') {
        $id = $_POST['id'];
        $ctitle = $sellify->real_escape_string($_POST['ctitle']);
        $cstatus = $_POST['cstatus'];
        $cdesc = $sellify->real_escape_string($_POST['cdesc']);

        $table = "tbl_page";
        $field = ['description' => $cdesc, 'status' => $cstatus, 'title' => $ctitle];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Page Update Successfully!!", "message" => "Page section!", "action" => "list_page.php"];
        }
    } elseif ($_POST['type'] == 'edit_payment') {
        $attributes = mysqli_real_escape_string($sellify, $_POST['p_attr']);
        $ptitle = mysqli_real_escape_string($sellify, $_POST['ptitle']);
        $okey = $_POST['status'];
        $id = $_POST['id'];
        $p_show = $_POST['p_show'];
        $target_dir = dirname(dirname(__FILE__)) . "/images/payment/";
        $url = "images/payment/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . '.' . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["cat_img"]["name"] != '') {
            move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
            $table = "tbl_payment_list";
            $field = ['status' => $okey, 'img' => $url, 'attributes' => $attributes, 'subtitle' => $ptitle, 'p_show' => $p_show];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Payment Gateway Update Successfully!!", "message" => "Payment Gateway section!", "action" => "paymentlist.php"];
            }
        } else {
            $table = "tbl_payment_list";
            $field = ['status' => $okey, 'attributes' => $attributes, 'subtitle' => $ptitle, 'p_show' => $p_show];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Payment Gateway Update Successfully!!", "message" => "Payment Gateway section!", "action" => "paymentlist.php"];
            }
        }
    } elseif ($_POST['type'] == 'add_faq') {
        $question = mysqli_real_escape_string($sellify, $_POST['question']);
        $answer = mysqli_real_escape_string($sellify, $_POST['answer']);
        $okey = $_POST['status'];

        $table = "tbl_faq";
        $field_values = ["question", "answer", "status"];
        $data_values = ["$question", "$answer", "$okey"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Faq Add Successfully!!", "message" => "Faq section!", "action" => "list_faq.php"];
        }
    } elseif ($_POST['type'] == 'add_package') {
        $title = mysqli_real_escape_string($sellify, $_POST['title']);
        $days = mysqli_real_escape_string($sellify, $_POST['days']);
        $price = $_POST['price'];
        $status = $_POST['status'];
        $post_type = $_POST['post_type'];

        $table = "tbl_package";
        $field_values = ["title", "days", "status", "price", "post_type"];
        $data_values = ["$title", "$days", "$status", "$price", "$post_type"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Package Add Successfully!!", "message" => "Package section!", "action" => "add_package.php"];
        }
    } elseif ($_POST['type'] == 'edit_package') {
        $title = mysqli_real_escape_string($sellify, $_POST['title']);
        $days = mysqli_real_escape_string($sellify, $_POST['days']);
        $price = $_POST['price'];
        $status = $_POST['status'];
        $post_type = $_POST['post_type'];
        $id = $_POST['id'];

        $table = "tbl_package";
        $field = ['title' => $title, 'status' => $status, 'days' => $days, 'price' => $price, 'post_type' => $post_type];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Package Update Successfully!!", "message" => "Package section!", "action" => "add_package.php?id=" . $id . ""];
        }
    } elseif ($_POST['type'] == 'edit_faq') {
        $question = mysqli_real_escape_string($sellify, $_POST['question']);
        $answer = mysqli_real_escape_string($sellify, $_POST['answer']);
        $okey = $_POST['status'];
        $id = $_POST['id'];

        $table = "tbl_faq";
        $field = ['question' => $question, 'status' => $okey, 'answer' => $answer];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Faq Update Successfully!!", "message" => "Faq section!", "action" => "list_faq.php"];
        }
    } elseif ($_POST['type'] == 'edit_profile') {
        $dname = $_POST['username'];
        $dsname = $_POST['password'];
        $mobile = $_POST['mobile'];
        $id = $_POST['id'];
        $table = "admin";
        $field = ['username' => $dname, 'password' => $dsname, 'mobile' => $mobile];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Profile Update Successfully!!", "message" => "Profile  section!", "action" => "profile.php"];
        }
    } elseif ($_POST['type'] == 'edit_setting') {
        $webname = mysqli_real_escape_string($sellify, $_POST['webname']);
        $timezone = $_POST['timezone'];
        $currency = $_POST['currency'];
        $id = $_POST['id'];
        $one_key = $_POST['one_key'];
        $one_hash = $_POST['one_hash'];
        $scredit = $_POST['scredit'];
        $rcredit = $_POST['rcredit'];
        $sms_type = $_POST['sms_type'];
        $auth_key = $_POST['auth_key'];
        $otp_id = $_POST['otp_id'];
        $acc_id = $_POST['acc_id'];
        $auth_token = $_POST['auth_token'];
        $twilio_number = $_POST['twilio_number'];
        $otp_auth = $_POST['otp_auth'];
        $ios_banner_id = $_POST['ios_banner_id'];
        $ios_in_id = $_POST['ios_in_id'];
        $banner_id = $_POST['banner_id'];
        $in_id = $_POST['in_id'];
        $admob = $_POST['admob'];
        $mode = $_POST['mode'];
        $ios_native_ad = $_POST['ios_native_ad'];
        $native_ad = $_POST['native_ad'];
        $target_dir = dirname(dirname(__FILE__)) . "/images/website/";
        $url = "images/website/";
        $temp = explode(".", $_FILES["weblogo"]["name"]);
        $newfilename = round(microtime(true)) . '.' . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["weblogo"]["name"] != '') {
            move_uploaded_file($_FILES["weblogo"]["tmp_name"], $target_file);
            $table = "tbl_setting";
            $field = [
                'timezone' => $timezone,
                'weblogo' => $url,
                'webname' => $webname,
                'currency' => $currency,
                'one_key' => $one_key,
                'one_hash' => $one_hash,
                'scredit' => $scredit,
                'rcredit' => $rcredit,
                'otp_auth' => $otp_auth,
                'twilio_number' => $twilio_number,
                'auth_token' => $auth_token,
                'acc_id' => $acc_id,
                'otp_id' => $otp_id,
                'auth_key' => $auth_key,
                'sms_type' => $sms_type,
                'ios_in_id' => $ios_in_id,
                'ios_banner_id' => $ios_banner_id,
                'in_id' => $in_id,
                'banner_id' => $banner_id,
                'admob' => $admob,
                'mode' => $mode,
                'native_ad' => $native_ad,
                'ios_native_ad' => $ios_native_ad,
            ];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Setting Update Successfully!!", "message" => "Setting section!", "action" => "setting.php"];
            }
        } else {
            $table = "tbl_setting";
            $field = [
                'timezone' => $timezone,
                'webname' => $webname,
                'currency' => $currency,
                'one_key' => $one_key,
                'one_hash' => $one_hash,
                'scredit' => $scredit,
                'rcredit' => $rcredit,
                'otp_auth' => $otp_auth,
                'twilio_number' => $twilio_number,
                'auth_token' => $auth_token,
                'acc_id' => $acc_id,
                'otp_id' => $otp_id,
                'auth_key' => $auth_key,
                'sms_type' => $sms_type,
                'ios_in_id' => $ios_in_id,
                'ios_banner_id' => $ios_banner_id,
                'in_id' => $in_id,
                'banner_id' => $banner_id,
                'admob' => $admob,
                'mode' => $mode,
                'native_ad' => $native_ad,
                'ios_native_ad' => $ios_native_ad,
            ];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = ["ResponseCode" => "200", "Result" => "true", "title" => "Setting Update Successfully!!", "message" => "Offer section!", "action" => "setting.php"];
            }
        }
    } elseif ($_POST["type"] == "add_banner") {
        $okey = $_POST["status"];

        $target_dir = dirname(dirname(__FILE__)) . "/images/banner/";
        $url = "images/banner/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);

        move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
        $table = "tbl_banner";
        $field_values = ["img", "status"];
        $data_values = ["$url", "$okey"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Banner Add Successfully!!",
                "message" => "Banner section!",
                "action" => "list_banner.php",
            ];
        }
    } elseif ($_POST["type"] == "add_sellify_brand") {
        $okey = $_POST["status"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/sellifybrand/";
        $url = "images/sellifybrand/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);

        move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
        $table = "car_brand";
        $field_values = ["img", "status", "title"];
        $data_values = ["$url", "$okey", "$title"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Car Brand Add Successfully!!",
                "message" => "Car Brand section!",
                "action" => "list_car_brand.php",
            ];
        }
    } elseif ($_POST["type"] == "add_brand") {
        $okey = $_POST["status"];
        $subcat_id = $_POST["subcat_id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/brand/";
        $url = "images/brand/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);

        move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
        $table = "tbl_brand";
        $field_values = ["img", "status", "title", "subcat_id"];
        $data_values = ["$url", "$okey", "$title", "$subcat_id"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => " Brand Add Successfully!!",
                "message" => "Brand section!",
                "action" => "list_brand.php",
            ];
        }
    } elseif ($_POST["type"] == "add_subcat_type") {
        $okey = $_POST["status"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $subcat_id = $_POST["subcat_id"];

        $table = "tbl_type";
        $field_values = ["status", "title", "subcat_id"];
        $data_values = ["$okey", "$title", "$subcat_id"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Subcategory Type Add Successfully!!",
                "message" => "Subcategory Type section!",
                "action" => "add_subtype.php",
            ];
        }
    } elseif ($_POST["type"] == "add_sellify_variation") {
        $okey = $_POST["status"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $brand_id = $_POST["brand_id"];

        $table = "car_variation";
        $field_values = ["status", "title", "brand_id"];
        $data_values = ["$okey", "$title", "$brand_id"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Car Variation Add Successfully!!",
                "message" => "Car Variation section!",
                "action" => "add_car_variation.php",
            ];
        }
    } elseif ($_POST["type"] == "add_sellify_variation_type") {
        $okey = $_POST["status"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $brand_id = $_POST["brand_id"];
        $variation_id = $_POST["variation_id"];

        $table = "car_variation_type";
        $field_values = ["status", "title", "brand_id", "variation_id"];
        $data_values = ["$okey", "$title", "$brand_id", "$variation_id"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Car Variation Type Add Successfully!!",
                "message" => "Car Variation Type section!",
                "action" => "add_variation_type.php",
            ];
        }
    } elseif ($_POST["type"] == "add_model") {
        $okey = $_POST["status"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $brand_id = $_POST["brand_id"];
        $subcat_id = $_POST["subcat_id"];

        $table = "tbl_model";
        $field_values = ["status", "title", "brand_id", "subcat_id"];
        $data_values = ["$okey", "$title", "$brand_id", "$subcat_id"];

        $h = new Crud($sellify);
        $check = $h->sellifyinsertdata($field_values, $data_values, $table);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Model Add Successfully!!",
                "message" => "Model section!",
                "action" => "add_model.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_subcat_type") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $subcat_id = $_POST["subcat_id"];

        $table = "tbl_type";
        $field = ["status" => $okey, "title" => $title, "subcat_id" => $subcat_id];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Subcategory  Type Update Successfully!!",
                "message" => "Subcategory  Type section!",
                "action" => "list_subtype.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_sellify_variation_type") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $brand_id = $_POST["brand_id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $variation_id = $_POST["variation_id"];

        $table = "car_variation_type";
        $field = ["status" => $okey, "title" => $title, "brand_id" => $brand_id, "variation_id" => $variation_id];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Car Variation Type Update Successfully!!",
                "message" => "Car Variation Type section!",
                "action" => "list_variation_type.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_model") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $brand_id = $_POST["brand_id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $subcat_id = $_POST["subcat_id"];

        $table = "tbl_model";
        $field = ["status" => $okey, "title" => $title, "brand_id" => $brand_id, "subcat_id" => $subcat_id];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Model Update Successfully!!",
                "message" => "Model section!",
                "action" => "list_model.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_sellify_variation") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $brand_id = $_POST["brand_id"];
        $title = $sellify->real_escape_string($_POST["title"]);

        $table = "car_variation";
        $field = ["status" => $okey, "title" => $title, "brand_id" => $brand_id];
        $where = "where id=" . $id . "";
        $h = new Crud($sellify);
        $check = $h->sellifyupdateData($field, $table, $where);
        if ($check == 1) {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "true",
                "title" => "Car Variation Update Successfully!!",
                "message" => "Car Variation section!",
                "action" => "list_car_variation.php",
            ];
        }
    } elseif ($_POST["type"] == "edit_banner") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $target_dir = dirname(dirname(__FILE__)) . "/images/banner/";
        $url = "images/banner/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["cat_img"]["name"] != "") {
            move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
            $table = "tbl_banner";
            $field = ["status" => $okey, "img" => $url];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Banner Update Successfully!!",
                    "message" => "Banner section!",
                    "action" => "list_banner.php",
                ];
            }
        } else {
            $table = "tbl_banner";
            $field = ["status" => $okey];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Banner Update Successfully!!",
                    "message" => "Banner section!",
                    "action" => "list_banner.php",
                ];
            }
        }
    } elseif ($_POST["type"] == "edit_category") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $total_post = $_POST["total_post"];
        $total_days = $_POST["total_days"];
        $target_dir = dirname(dirname(__FILE__)) . "/images/category/";
        $url = "images/category/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["cat_img"]["name"] != "") {
            move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
            $table = "tbl_category";
            $field = ["status" => $okey, "img" => $url, "total_days" => $total_days, "total_post" => $total_post];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Category Update Successfully!!",
                    "message" => "Category section!",
                    "action" => "list_category.php",
                ];
            }
        } else {
            $table = "tbl_category";
            $field = ["status" => $okey, "total_days" => $total_days, "total_post" => $total_post];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Category Update Successfully!!",
                    "message" => "Category section!",
                    "action" => "list_category.php",
                ];
            }
        }
    } elseif ($_POST["type"] == "edit_sellify_brand") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/sellifybrand/";
        $url = "images/sellifybrand/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["cat_img"]["name"] != "") {
            move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
            $table = "car_brand";
            $field = ["status" => $okey, "img" => $url, "title" => $title];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Car Brand Update Successfully!!",
                    "message" => "Car Brand section!",
                    "action" => "list_car_brand.php",
                ];
            }
        } else {
            $table = "car_brand";
            $field = ["status" => $okey, "title" => $title];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "sellify Brand Update Successfully!!",
                    "message" => "sellify Brand section!",
                    "action" => "list_car_brand.php",
                ];
            }
        }
    } elseif ($_POST["type"] == "edit_brand") {
        $okey = $_POST["status"];
        $id = $_POST["id"];
        $subcat_id = $_POST["subcat_id"];
        $title = $sellify->real_escape_string($_POST["title"]);
        $target_dir = dirname(dirname(__FILE__)) . "/images/brand/";
        $url = "images/brand/";
        $temp = explode(".", $_FILES["cat_img"]["name"]);
        $newfilename = round(microtime(true)) . "." . end($temp);
        $target_file = $target_dir . basename($newfilename);
        $url = $url . basename($newfilename);
        if ($_FILES["cat_img"]["name"] != "") {
            move_uploaded_file($_FILES["cat_img"]["tmp_name"], $target_file);
            $table = "tbl_brand";
            $field = ["status" => $okey, "img" => $url, "title" => $title, "subcat_id" => $subcat_id];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Brand Update Successfully!!",
                    "message" => "Brand section!",
                    "action" => "list_brand.php",
                ];
            }
        } else {
            $table = "tbl_brand";
            $field = ["status" => $okey, "title" => $title, "subcat_id" => $subcat_id];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Brand Update Successfully!!",
                    "message" => "Brand section!",
                    "action" => "list_brand.php",
                ];
            }
        }
    } elseif ($_POST["type"] == "update_status") {
        $id = $_POST["id"];
        $status = $_POST["status"];
        $coll_type = $_POST["coll_type"];
        $page_name = $_POST["page_name"];
        if ($coll_type == "userstatus") {
            $table = "tbl_user";
            $field = "status=" . $status . "";
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData_single($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "User Status Change Successfully!!",
                    "message" => "User section!",
                    "action" => "userlist.php",
                ];
            }
        }
        if ($coll_type == "poststatus") {
            $table = "tbl_post";
            $field = [
                "post_status" => 1,
                "is_approve" => 1,
            ];
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData($field, $table, $where);

            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Ad Approved Successfully!!",
                    "message" => "Ad section!",
                    "action" => "list_post.php",
                ];
            }
        } elseif ($coll_type == "substatus") {
            $table = "tbl_subcategory";
            $field = "status=" . $status . "";
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData_single($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Subcategory Status Change Successfully!!",
                    "message" => "Subcategory section!",
                    "action" => "list_subcategory.php",
                ];
            }
        } elseif ($coll_type == "dark_mode") {
            $table = "tbl_setting";
            $field = "show_dark=" . $status . "";
            $where = "where id=" . $id . "";
            $h = new Crud($sellify);
            $check = $h->sellifyupdateData_single($field, $table, $where);
            if ($check == 1) {
                $returnArr = [
                    "ResponseCode" => "200",
                    "Result" => "true",
                    "title" => "Dark Mode Status Change Successfully!!",
                    "message" => "Dark Mode section!",
                    "action" => $page_name,
                ];
            }
        } else {
            $returnArr = [
                "ResponseCode" => "200",
                "Result" => "false",
                "title" => "Option Not There!!",
                "message" => "Error!!",
                "action" => "dashboard.php",
            ];
        }
    } else {
        $returnArr = ["ResponseCode" => "200", "Result" => "false", "title" => "Don't Try Extra Function!", "message" => "welcome admin!!", "action" => "dashboard.php"];
    }
} else {
    $returnArr = ["ResponseCode" => "200", "Result" => "false", "title" => "Don't Try Extra Function!", "message" => "welcome admin!!", "action" => "dashboard.php"];
}
echo json_encode($returnArr);
?>
