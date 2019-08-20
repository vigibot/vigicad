<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
  <title>
   STL
  </title>

  <script src="../../Online3DViewer/jsmodeler/three.min.js" type="text/javascript"></script>
  <script src="../../Online3DViewer/jsmodeler/jsmodeler.js" type="text/javascript"></script>
  <script src="../../Online3DViewer/jsmodeler/jsmodeler.ext.three.js" type="text/javascript"></script>
  <script src="../../Online3DViewer/embeddable/include/online3dembedder.js" type="text/javascript"></script>

  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, user-scalable=no" />
  <link rel="stylesheet" href="style.css" type="text/css" />
 </head>
 <body>

<?php
 function human($bytes, $decimals = 2) {
  $sz = array("o", "Ko", "Mo", "Go", "To", "Po");
  $factor = floor((strlen($bytes) - 1) / 3);
  return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor))."&nbsp;".$sz[$factor];
 }

 $dir = opendir(".");

 while(($f = readdir($dir)) !== false) {
  $ext = substr($f, -4);
  if($f != "." and $f != ".." and $ext == ".stl") {
   $data = "<div class=\"stl\">";
   $data .= "<canvas class=\"3dviewer\" sourcefiles=\"$f\" width=\"250\" height=\"250\"></canvas>";
   $data .= "<div class=\"titre\">";
   $data .= "<a href=\"$f\">$f</a> ";
   $data .= human(filesize($f));
   $data .= "</div>";
   $data .= "</div> ";
  }
  echo $data;
 }
 closedir($dir);
?>

  <script type="text/javascript">
   <!--
    window.addEventListener("load", LoadOnline3DModels, true);
   //-->
  </script>

 </body>
</html>
