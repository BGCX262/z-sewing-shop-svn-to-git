<?php

function unicod($str) {
    $conv=array();
    for($x=128;$x<=143;$x++) $conv[$x+112]=chr(209).chr($x);
    for($x=144;$x<=191;$x++) $conv[$x+48]=chr(208).chr($x);
    $conv[184]=chr(209).chr(145); #�
    $conv[168]=chr(208).chr(129); #�
    $conv[179]=chr(209).chr(150); #�
    $conv[178]=chr(208).chr(134); #�
    $conv[191]=chr(209).chr(151); #�
    $conv[175]=chr(208).chr(135); #�
    $conv[186]=chr(209).chr(148); #�
    $conv[170]=chr(208).chr(132); #�
    $conv[180]=chr(210).chr(145); #�
    $conv[165]=chr(210).chr(144); #�
    $conv[184]=chr(209).chr(145); #�
    $ar=str_split($str);
    foreach($ar as $b) if(isset($conv[ord($b)])) $nstr.=$conv[ord($b)]; 
    else $nstr.=$b;
    return $nstr;
}

function show_head()
{
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ua">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
    <title>SewingShop</title>
    <link rel="stylesheet" href="style.css"/>
</head>
<body>
  <div id="header">
    <div id="header1">
      &nbsp;
    </div>
    <div id="header2">
      <p>SEWING SHOP v.1.0</p>
    </div>
  </div>
<?php
}

function show_menuitem($text, $active, $new, $link)
{
  if ($active == 0) {
    echo '<span>'.$text.'</span>';
  }
  else {
    if ($new == 0) {
      echo '<a href="'.$link.'">'.$text.'</a>';
    }
    else {
      echo '<a href="'.$link.'" target="_blank">'.$text.'</a>';
    }  
  }
}

function show_menu($index)
{
  echo '<div id="menu">';
  if ($index == 0) {
    $i = 0;
  }
  else {
    $i = 1;
  }
  show_menuitem('�������', $i, 0, 'index.php');
  if ($index == 1) {
    $i = 0;
  }
  else {
    $i = 1;
  }
  show_menuitem('������ �����', $i, 0, 'history.php');
  if ($index == 2) {
    $i = 0;
  }
  else {
    $i = 1;
  }
  show_menuitem('�� ��������?', $i, 0, 'todo.php');
  if ($index == 3) {
    $i = 0;
  }
  else {
    $i = 1;
  }
  show_menuitem('���������', $i, 0, 'library.php');

  if ($index == 10) {
    $i = 0;
  }
  else {
    $i = 1;
  }
  show_menuitem('��������', $i, 0, 'contact.php');
  
  echo '</div>';
  echo '<div id="main">';
}

function show_content()
{
?>
  <div id="content">
<?php
}

function show_content_()
{
?>
  </div>  
<?php
}

function show_copyright()
{
?>
  <div id="footer">
    <p>&copy; Sewing Shop, 2010</p>
  </div>
<?php
}

function show_close()
{
?>
</body>

</html>
<?php
}


?>