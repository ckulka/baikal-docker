<?php
try {
  $subject = uniqid();
  $mail_result = mail("to@example.com", $subject, "Email sent with PHP mail()");

  if ($mail_result) {
    echo $subject;
  } else {
    throw new Exception("mail(...) returned false");
  }
} catch (\Throwable $th) {
  http_response_code(500);
  echo $th->getMessage();
}
?>
