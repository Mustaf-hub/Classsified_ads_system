<?php
require "Config.php";
class Crud
{
    private $sellify;

    public function __construct($sellify)
    {
        $this->sellify = $sellify;
    }

    public function sellifylogin($username, $password, $tblname)
    {
        
            $q = "SELECT * FROM " . $tblname . " WHERE username='" . $username . "' AND password='" . $password . "'";
            return $this->sellify->query($q)->num_rows;
        
    }

    public function sellifyinsertdata($field, $data, $table)
    {
        $field_values = implode(",", $field);
        $data_values = implode("','", $data);

        $sql = "INSERT INTO $table($field_values)VALUES('$data_values')";
        return $this->sellify->query($sql);
    }

    

    public function sellifyinsertdata_id($field, $data, $table)
    {
        $field_values = implode(",", $field);
        $data_values = implode("','", $data);

        $sql = "INSERT INTO $table($field_values)VALUES('$data_values')";
        $result = $this->sellify->query($sql);
        return $this->sellify->insert_id;
    }

    public function sellifyinsertdata_Api($field, $data, $table)
{
    // Ensure both $field and $data arrays have the same length
    if (count($field) !== count($data)) {
        throw new Exception('Field and data count mismatch.');
    }

    // Replace empty strings with NULL for date fields
    foreach ($data as &$value) {
        if ($value === '') {
            $value = 'NULL'; // or use NULL directly in SQL query
        } else {
            $value = "'" . mysqli_real_escape_string($this->sellify, $value) . "'";
        }
    }

    $field_values = implode(",", $field);
    $data_values = implode(",", $data);

    $sql = "INSERT INTO $table($field_values) VALUES($data_values)";

    return $this->sellify->query($sql);
}


    public function sellifyinsertdata_Api_Id($field, $data, $table)
    {
        $field_values = implode(",", $field);
        $data_values = implode("','", $data);

        $sql = "INSERT INTO $table($field_values)VALUES('$data_values')";
        $result = $this->sellify->query($sql);
        return $this->sellify->insert_id;
    }

    public function sellifyupdateData($field, $table, $where)
    {
        $cols = [];

        foreach ($field as $key => $val) {
            
                // check if value is not null then only add that colunm to array
                $cols[] = "$key = '$val'";
            
        }
        $sql = "UPDATE $table SET " . implode(", ", $cols) . " $where";
        return $this->sellify->query($sql);
    }

    

    public function sellifyupdateData_Api($field, $table, $where)
    {
        $cols = [];

        foreach ($field as $key => $val) {
            if ($val != null) {
                // check if value is not null then only add that colunm to array
                $cols[] = "$key = '$val'";
            }
        }
        $sql = "UPDATE $table SET " . implode(", ", $cols) . " $where";
        return $this->sellify->query($sql);
    }

    public function sellifyupdateData_single($field, $table, $where)
    {
        $query = "UPDATE $table SET $field";

        $sql = $query . " " . $where;
        return $this->sellify->query($sql);
    }

    public function sellifyDeleteData($where, $table)
    {
        $sql = "Delete From $table $where";
        return $this->sellify->query($sql);
    }

    public function sellifyDeleteData_Api($where, $table)
    {
        $sql = "Delete From $table $where";
        return $this->sellify->query($sql);
    }
}
?>
