<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
  <title>
   STL viewer
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
 $nbaff = 4;

 $page = $_GET["page"];
 if(!is_numeric($page) || $page < 0)
  $page = 0;

 function human($bytes, $decimals = 2) {
  $sz = array("o", "Ko", "Mo", "Go", "To", "Po");
  $factor = floor((strlen($bytes) - 1) / 3);
  return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor))."&nbsp;".$sz[$factor];
 }

 $files = array_diff(scandir("."), [
  ".",
  "..",
  "index.php",
  "style.css"
 ]);

 $nbstl = count($files);
 $nbpag = ceil($nbstl / $nbaff);

 if($page >= $nbpag)
  $page = $nbpag - 1;

 $data = "<h1>";
 for($i = 0; $i < $nbpag; $i++)
  $data .= "<a href=\"?page=$i\">$i</a> ";
 $data .= "</h1>";

 $files = array_slice($files, $page * $nbaff, $nbaff);

 foreach($files as $f) {
  $data .= "<div class=\"stl\">";
  $data .= "<canvas class=\"3dviewer\" sourcefiles=\"$f\" width=\"300\" height=\"300\"></canvas>";
  $data .= "<h3>";
  $data .= "<a href=\"$f\">$f</a> ";
  $data .= human(filesize($f));
  $data .= "</h3>";
  $data .= "</div>";
 }

 echo $data;
?>

  <script type="text/javascript">
   <!--
    window.addEventListener("load", LoadOnline3DModels, true);
   //-->
  </script>

 </body>
</html>
