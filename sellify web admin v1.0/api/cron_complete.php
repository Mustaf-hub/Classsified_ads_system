<?php 
require dirname(dirname(__FILE__)).'/inc/Config.php';
require dirname(dirname(__FILE__)).'/inc/Crud.php';

$timestamp = date("Y-m-d H:i:s");

$table = "tbl_post";
$field = array(
    'is_expire' => "1",
    'is_paid' => "0",
    'post_status' => "0"
);
// Correct condition for expired posts
$where = "WHERE post_expire_date < '".$timestamp."'";

$h = new Crud($sellify);
$check = $h->sellifyupdateData_Api($field, $table, $where);

if ($check) {
    echo "Expired posts updated successfully.";
} else {
    echo "Failed to update expired posts.";
}
