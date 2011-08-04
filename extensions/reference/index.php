<?php
header('Access-Control-Allow-Origin: *');
?>
<!DOCTYPE HTML>
<head>
  <title>Reference Implementation</title>
  <script type='text/javascript' src='jquery.js'></script>
  <script type='text/javascript' src='page.js'></script>
</head>

<body>
  <h1>Reference Implementation of IAT</h1>

  <p>
    This is a reference implementation of IAT's browser side code.
  </p>

  <textarea id="text">Example text
1.
2.
3.
</textarea>

<p>
  Your current token is: <code id="token">unset</code>
</p>

<ol>
  <li><button id="hello">hello</button></li>
  <li><button id="edit">edit</button></li>
</ol>

</body>
