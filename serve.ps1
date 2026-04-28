$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add('http://localhost:3000/')
$listener.Start()
Write-Host 'Serving on http://localhost:3000'
while ($true) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request
  $res = $ctx.Response
  $path = $req.Url.LocalPath
  if ($path -eq '/') { $path = '/index.html' }
  $file = 'C:\Users\astra\OneDrive\Documents\Claude\website' + $path.Replace('/', '\')
  if (Test-Path $file) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ext = [IO.Path]::GetExtension($file)
    $ct = switch ($ext) {
      '.html' { 'text/html; charset=utf-8' }
      '.css'  { 'text/css' }
      '.js'   { 'application/javascript' }
      '.jpg'  { 'image/jpeg' }
      '.jpeg' { 'image/jpeg' }
      '.pdf'  { 'application/pdf' }
      default { 'application/octet-stream' }
    }
    $res.ContentType = $ct
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $res.StatusCode = 404
  }
  $res.OutputStream.Close()
}
