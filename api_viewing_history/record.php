<?php
include 'connection.php';

$channelName = $_POST['channel_name'];
$videoTitle = $_POST['video_title'];

$sqlQuery = "INSERT INTO history_table SET channel_name = '$channelName', video_title = '$videoTitle'";

$resultQuery = $connection -> query($sqlQuery);

if($resultQuery) {
    echo json_encode(array("save" => true));
}else{
    echo json_encode(array("save" => false));
}