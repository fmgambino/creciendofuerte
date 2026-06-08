<?php require_once 'helpers.php'; need_login(); out(true,['partners'=>db()->query('SELECT id,full_name FROM partners ORDER BY full_name')->fetchAll()]); ?>
