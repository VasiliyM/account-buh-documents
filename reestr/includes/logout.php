<?php
// закрыть сессию
	session_start();
	unset($_SESSION['session_username']);
    unset($_SESSION['session_idusername']);
	session_destroy();
	header("location: ../index.html");
?>