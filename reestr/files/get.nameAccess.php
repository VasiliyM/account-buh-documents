<?php
    $mysqli = mysqli_connect($host,$user,$password,$db);
    if (mysqli_connect_errno()) {
        printf("Не удалось подключиться: %s\n", mysqli_connect_error());
        exit();
    }
    // для русской кодировки
    mysqli_query($mysqli, "SET NAMES utf8");
    $sql = "SELECT nik FROM tab_access WHERE id = '$idnik'";
    $res = mysqli_query($mysqli, $sql);
    $row = mysqli_fetch_assoc($res);
    $nik = $row['nik'];
    mysqli_free_result($res);
?>