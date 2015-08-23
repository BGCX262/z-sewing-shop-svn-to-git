<?php
  
  require_once('f_format.php');

  show_head();
  show_menu(1);
  show_content();
  echo '<h1>Історія версій</h1>';
  include "history.html";
  show_content_();
  show_copyright();
  show_close();
  
?>  