<?php

$lua = new Lua("index.lua");
$data = $lua->main($_REQUEST);
header("Content-Type: application/json");
http_response_code($data["status"]);
echo json_encode($data["body"],true)."\n";
