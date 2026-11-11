#!/bin/bash
set -euo pipefail
dnf install -y nginx
systemctl enable --now nginx

cat > /usr/share/nginx/html/index.html <<EOF
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Librería Tinta · Versión 1</title>
  <style>
    body { max-width: 780px; margin: 50px auto; padding: 24px; font: 20px/1.6 Arial, sans-serif; color: #24342c; background: #f6f3e9; }
    h1 { color: #205c45; margin-bottom: 0; }
    .version { background: #205c45; color: white; padding: 12px 18px; border-radius: 6px; }
    footer { margin-top: 32px; border-top: 1px solid #bcc6bc; padding-top: 16px; font-size: 15px; }
  </style>
</head>
<body>
  <h1>Librería Tinta</h1>
  <p>Tu librería de barrio.</p>
  <p class="version">Servidor 1 · Versión 1</p>
  <p><strong>Horario:</strong> de lunes a sábado, de 10:00 a 14:00 y de 17:00 a 20:00.</p>
  <p><strong>Dirección ficticia:</strong> calle de las Letras, 12, València.</p>
  <p><strong>Recomendación:</strong> El camino, de Miguel Delibes.</p>
  <footer>Desplegado por Cristian Moresi Nadal<br>Servidor: $(hostname)<br>Fecha: $(date '+%d/%m/%Y')</footer>
</body>
</html>
EOF
