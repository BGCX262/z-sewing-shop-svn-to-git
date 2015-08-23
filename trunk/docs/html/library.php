<?php
  
  require_once('f_format.php');

  show_head();
  show_menu(3);
  show_content();
  echo '<h1>Бібліотека</h1>';
  include "library.html";
  show_content_();
  show_copyright();
  show_close();
  
?>  