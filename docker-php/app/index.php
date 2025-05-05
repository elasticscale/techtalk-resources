<?php
require_once 'config.php';

$appName = $_ENV['APP_NAME'] ?? 'This is broken as you are not sending APP_NAME';

echo "<h1>Welcome to $appName!</h1>";
echo "<p>This app is part of your Level 1 Dockerization exercise.</p>";