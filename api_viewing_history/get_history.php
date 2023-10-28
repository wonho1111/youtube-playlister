<?php
include 'connection.php';

$channelName = $_POST['channel_name'];

$sqlQuery = "SELECT * FROM history_table WHERE channel_name = '$channelName'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery) {
    $numRows = $resultQuery->num_rows;
    echo json_encode(array("num" => $numRows));
}else{
    echo json_encode(array("num" => $numRows));
}